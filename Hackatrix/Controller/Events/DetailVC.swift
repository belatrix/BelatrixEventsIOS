//
//  DetailVC.swift
//  Hackatrix
//
//  Created by Erik Fernando Flores Quispe on 10/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import UIKit

import Alamofire
import AlamofireImage
import SwiftyJSON
import SafariServices
import MapKit
import SVProgressHUD

enum DetailTab {
    case Information
    case Ideas
    case Votes
}

class DetailVC: UIViewController {
    //MARK: - Properties
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var urlBtn: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var informationView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var projectsView: UIView!
    @IBOutlet weak var projectTableView: UITableView!
    var detailEvent: Event?
    var projects: [Project] = []
    var sortedProjects: [Project] = []
    var currentTab: DetailTab = .Information
    var ideas: [Idea]? {
        didSet {
            projectTableView.reloadData()
        }
    }
  
    var currentUser : User?
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        currentUser = UserManager.shared.currentUser
        self.getProjects()
        self.getIdeaList()
        super.viewDidLoad()
        self.setUIElements()
        projectTableView.estimatedRowHeight = 66
        //self.bussinesValidations()
    }

    //MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ProjectDetailVC, segue.identifier == K.segue.project, let indexPath = sender as? IndexPath {
            destination.idea = self.ideas?[indexPath.row]
        } else if let myIdeasVC = segue.destination as? MyIdeasVC, segue.identifier == K.segue.myIdeas {
            myIdeasVC.detailEvent = detailEvent
        }
    }
    
    //MARK: - IBActions
    
    @IBAction func segmentedControlValueChanged(_ sender: Any) {
        if let segmented = sender as? UISegmentedControl {
            switch segmented.selectedSegmentIndex {
            case 0:
                self.informationView.isHidden = false
                self.projectsView.isHidden = true
                self.currentTab = .Information
            case 1:
                self.informationView.isHidden = true
                self.projectsView.isHidden = false
                self.currentTab = .Ideas
                self.projectTableView.setContentOffset(.zero, animated: false)
                self.projectTableView.reloadData()
            case 2:
                self.informationView.isHidden = true
                self.projectsView.isHidden = false
                self.currentTab = .Votes
                self.projectTableView.setContentOffset(.zero, animated: false)
                self.projectTableView.reloadData()
            default:
                self.informationView.isHidden = false
                self.projectsView.isHidden = true
                self.currentTab = .Information
            }
        }
    }

    @IBAction func showWebPage(_ sender: Any) {
        if let registerLink = self.detailEvent?.registerLink, let helpURL = URL(string: registerLink) {
            let safariView = SFSafariViewController(url: helpURL)
            self.present(safariView, animated: true, completion: nil)
        }
    }
    
    //MARK: - Functions
    
    func setUIElements() {
        self.title = self.detailEvent?.title
        if let image = self.detailEvent?.image, let url = URL(string: image) {
            self.mainImage.af_setImage(withURL: url)
        }
        if let datetime = self.detailEvent?.datetime {
            self.dateLbl.text = Utils.date.getFormatterEvent(dateString: datetime)
        }
        if self.detailEvent?.address == "" {
            self.locationLbl.text = "Belatrix"
        } else {
            self.locationLbl.text = self.detailEvent?.address
        }
        self.locationLbl.sizeToFit()
        if self.detailEvent?.details == "" {
            self.descriptionLbl.text = "No hay descripción"
        } else {
            self.descriptionLbl.text = self.detailEvent?.details
        }
        self.urlBtn.setTitle(self.detailEvent?.registerLink ?? "", for: .normal)
        self.setMapRegion()
    }

    func getProjects() {
        SVProgressHUD.show()
        if let eventID = self.detailEvent?.id {
            ProjectManager.shared.getProjects(eventID: eventID) { (projects) in
                SVProgressHUD.dismiss()
                self.projects = projects
                self.sortedProjects = projects.sorted(by: { (p1, p2) -> Bool in
                    let votes1 = p1.votes ?? 0
                    let votes2 = p2.votes ?? 0
                    return votes1 > votes2
                })
             self.projectTableView.reloadData()
            }
        }
    }
    
    func getIdeaList() {
        if let eventID = self.detailEvent?.id {
            ProjectManager.shared.getIdeas(eventID: eventID) { (ideas) in
                self.ideas = ideas
            }
        }
    }
    
    func bussinesValidations() {
        if let isInteractionActive = self.detailEvent?.isInteractionActive, let hasInteractions = self.detailEvent?.hasInteractions {
            if !isInteractionActive {
                self.tabBarController?.tabBar.isHidden = true
            }
            if !hasInteractions {
                self.tabBarController?.tabBar.items?[1].isEnabled = false
            }
        }
    }

    func setMapRegion() {
        let latitudeString = self.detailEvent?.location?.latitude ?? "-12.099947"
        let longitudeString = self.detailEvent?.location?.longitude ?? "-77.018978"
        if let latitud = Double(latitudeString), let longitud = Double(longitudeString) {
            let lat = CLLocationDegrees(exactly: latitud)
            let long = CLLocationDegrees(exactly: longitud)
            let center = CLLocationCoordinate2D(latitude: lat!, longitude: long!)

            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
            self.mapView.setRegion(region, animated: true)

            let annotation = MKPointAnnotation()
            annotation.coordinate = center
            annotation.title = self.detailEvent?.location?.name ?? "Belatrix"
            self.mapView.addAnnotation(annotation)
        }
    }

    func goToMyIdeas() {
        self.performSegue(withIdentifier: K.segue.myIdeas, sender: nil)
    }
  
  func castVote(projectId: Int, eventId: Int) {
      SVProgressHUD.show()
    VoteManager.shared.castVote(eventId: eventId , projectID: projectId , completion: {
        SVProgressHUD.dismiss()
        let alertController = UIAlertController(title: "Hackatrix", message: "Tu voto fue enviado correctamente", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
          self.getProjects()
        }))
          self.present(alertController, animated: true, completion: nil)
      } , error:  { errorMessage in
        SVProgressHUD.dismiss()
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
      })
  }
}

extension DetailVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.currentTab == .Ideas {
            let ideasCount = ideas?.count ?? 0
            if let _ = currentUser {
                //user is log in
                 return ideasCount + 1
            }
            return ideasCount
        }
        return self.sortedProjects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.currentTab == .Ideas {
            if indexPath.row == ideas?.count {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "AddIdeaTableViewCell", for: indexPath) as? AddIdeaTableViewCell {
                    cell.btnAddIdea.addTarget(self, action: #selector(DetailVC.goToMyIdeas), for: .touchUpInside)
                    return cell
                }
            } else {
                if let ideaCell = tableView.dequeueReusableCell(withIdentifier: "IdeaTableViewCell", for: indexPath) as? IdeaTableViewCell {
                    let idea = self.ideas?[indexPath.row]
                    ideaCell.titleLabel.text = idea?.title
                    ideaCell.descriptionLabel.text = idea?.ideaDescription
                    return ideaCell
                }
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectTableViewCell", for: indexPath) as? ProjectTableViewCell {
                var project = self.projects[indexPath.row]
                if self.currentTab == .Votes {
                    project = self.sortedProjects[indexPath.row]
                }
                let title = project.text?.split(separator: "-")[0].trimmingCharacters(in: .whitespacesAndNewlines)
                cell.lblProject.text = title
                if let votes = project.votes {
                    cell.lblScore.text = "\(votes)"
                }
                cell.lblScore.isHidden = self.currentTab == .Ideas
                if self.currentTab == .Ideas {
                    cell.accessoryType = .disclosureIndicator
                } else {
                    cell.accessoryType = .none
                }
                return cell
            }
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.currentTab == .Ideas {
            self.performSegue(withIdentifier: K.segue.project, sender: indexPath)
        } else {
           let project = self.sortedProjects[indexPath.row]
            if let title = project.text , currentUser != nil {
                let alert = UIAlertController(title: "Hackatrix", message: "¿Estás seguro que deseas votar por: \(title)? No podrás corregir tu voto o eliminarlo luego de esta confirmación.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "Sí", style: .default, handler: { (action) in
                  self.castVote(projectId: project.id!, eventId: self.detailEvent!.id!)
                }))
                self.present(alert, animated: false, completion: nil)
            }
        }
    }
}
