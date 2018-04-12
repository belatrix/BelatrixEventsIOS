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
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.detail {
            if let tabBarVC = segue.destination as? UITabBarController, let detailVC = tabBarVC.viewControllers?[0] as? DetailVC, let interactionVC = tabBarVC.viewControllers?[1] as? InteractionVC {
                if self.eventTypeSelected == .upcoming {
                    interactionVC.detailEvent = self.upcomingEvents[currentEventSelected.row]
                    detailVC.detailEvent = self.upcomingEvents[currentEventSelected.row]
                } else if self.eventTypeSelected == .past {
                    interactionVC.detailEvent = self.pastEvents[currentEventSelected.row]
                    detailVC.detailEvent = self.pastEvents[currentEventSelected.row]
                } else {
                    interactionVC.detailEvent = self.featuredBanner
                    detailVC.detailEvent = self.featuredBanner
                }
            }
        }
    }
    
    //MARK: - Functions
    
    func getBanner(complete: @escaping () -> Void) {
        Alamofire.request(api.url.event.featured).responseJSON { response in
            if let responseServer = response.result.value {
                let json = JSON(responseServer)
                self.featuredBanner = Event(data: json)
                if let featuredBannerImage = self.featuredBanner.image, let url = URL(string: featuredBannerImage) {
                    self.bannerImage.af_setImage(
                        withURL: url,
                        imageTransition: .crossDissolve(0.2)
                    )
                }
                complete()
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
    
    func getEventOf(type:EventType) {
        var eventURL = api.url.event.upcoming
        if type == .past {
            eventURL = api.url.event.past
        }
        
        Alamofire.request(eventURL).responseJSON { response in
            if let responseServer = response.result.value {
                let json = JSON(responseServer)
                for (_, subJson): (String, JSON) in json {
                    if type == .upcoming {
                        self.upcomingEvents.append(Event(data: subJson))
                    } else {
                        self.pastEvents.append(Event(data: subJson))
                    }
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



