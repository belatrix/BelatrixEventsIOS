//
//  MainVC.swift
//  Hackatrix
//
//  Created by Erik Fernando Flores Quispe on 9/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class MainVC: UIViewController {
    //MARK: - Properties
    
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var upcomingCollectionView: UICollectionView!
    @IBOutlet weak var pastCollectionView: UICollectionView!
    @IBOutlet weak var featureTitle: UILabel!
    @IBOutlet weak var activityUpcoming: UIActivityIndicatorView!
    @IBOutlet weak var activityPass: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    var featuredBanner: Event! = nil
    var upcomingEvents: [Event] = [] {
        didSet {
            self.activityUpcoming.stopAnimating()
            self.upcomingCollectionView.reloadData()
        }
    }
    var pastEvents:[Event] = [] {
        didSet {
            self.activityPass.stopAnimating()
            self.pastCollectionView.reloadData()
        }
    }
    var eventTypeSelected: EventType!
    var currentEventSelected: IndexPath!
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getBanner {
            self.addTitleinMainBanner()
            self.addActionToEventsTo(images: self.bannerImage)
        }
        self.addRefreshController()
        self.getEventOf(type: .upcoming)
        self.getEventOf(type: .past)
       NotificationCenter.default.addObserver(self, selector: #selector(refreshTab(notification:)), name: .notification_event, object: nil)
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.detail {
            if let detailVC = segue.destination as? DetailVC {
                if self.eventTypeSelected == .upcoming {
                    detailVC.detailEvent = self.upcomingEvents[currentEventSelected.row]
                } else if self.eventTypeSelected == .past {
                    detailVC.detailEvent = self.pastEvents[currentEventSelected.row]
                } else {
                    detailVC.detailEvent = self.featuredBanner
                }
            }
        }
    }
    
    //MARK: - Functions
    
    func getBanner(completion: @escaping () -> Void) {
        EventManager.shared.getFeaturedEvent { [weak self] (event) in
            if let weakSelf = self {
                weakSelf.featuredBanner = event
                if let featuredBannerImage = weakSelf.featuredBanner.image, let url = URL(string: featuredBannerImage) {
                    weakSelf.bannerImage.af_setImage(
                        withURL: url,
                        imageTransition: .crossDissolve(0.2)
                    )
                }
                completion()
            }
        }
    }
    
    func addTitleinMainBanner() {
        self.featureTitle.text = featuredBanner.title
    }
    
    func addActionToEventsTo(images eventImage: UIImageView) {
        let actionTap = UITapGestureRecognizer(target: self, action: #selector(self.showDetail))
        actionTap.numberOfTapsRequired = 1
        eventImage.isUserInteractionEnabled = true
        eventImage.addGestureRecognizer(actionTap)
    }
    
    func showDetail() {
        self.eventTypeSelected = .current
        self.performSegue(withIdentifier: K.segue.detail, sender: nil)
    }
    
    func getEventOf(type: EventType) {
        EventManager.shared.getEvent(type: type) { [weak self] (events) in
            if let weakSelf = self {
                if type == .upcoming {
                    weakSelf.upcomingEvents = events
                } else if type == .past {
                    weakSelf.pastEvents = events
                }
            }
        }
    }
    
    func addRefreshController() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(self.refreshContent), for: .valueChanged)
        if #available(iOS 10.0, *) {
            self.scrollView.refreshControl = refresh
        } else {
            self.scrollView.addSubview(refresh)
        }
    }
    
    func refreshContent(sender:UIRefreshControl) {
        self.getBanner {
            self.addTitleinMainBanner()
            self.addActionToEventsTo(images: self.bannerImage)
        }
        self.upcomingEvents = []
        self.upcomingCollectionView.reloadData()
        self.getEventOf(type: .upcoming)
        self.pastEvents = []
        self.pastCollectionView.reloadData()
        self.getEventOf(type: .past)
        sender.endRefreshing()
    }
  
  func refreshTab(notification: NSNotification) {
    self.navigationController?.popToRootViewController(animated: false)
  }
}

//MARK: - UICollectionViewDataSource

extension MainVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return self.upcomingEvents.count
        }else if collectionView.tag == 1 {
            return self.pastEvents.count
        }else {
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.cell.event, for: indexPath) as? EventCell {
            if collectionView.tag == 0 {
                if let image = self.upcomingEvents[indexPath.row].image, let url = URL(string: image), let title =  self.upcomingEvents[indexPath.row].title {
                    cell.eventImage.af_setImage(withURL: url, imageTransition: .crossDissolve(0.2))
                    cell.eventTitle.text = title
                }
            } else if collectionView.tag == 1 {
                if let image = self.pastEvents[indexPath.row].image, let url = URL(string: image), let title =  self.pastEvents[indexPath.row].title {
                    cell.eventImage.af_setImage(withURL: url, imageTransition: .crossDissolve(0.2))
                    cell.eventTitle.text = title
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }
}

//MARK: - UICollectionViewDelegate

extension MainVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0 {
            self.currentEventSelected = indexPath
            self.eventTypeSelected = .upcoming
        } else if collectionView.tag == 1 {
            self.currentEventSelected = indexPath
            self.eventTypeSelected = .past
        }
        self.performSegue(withIdentifier: K.segue.detail, sender: nil)
    }
}



