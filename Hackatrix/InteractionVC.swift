//
//  InteractionVC.swift
//  Hackatrix
//
//  Created by Erik Fernando Flores Quispe on 10/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class InteractionVC: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var tableViewInteraction: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var detailEvent:Event!
    var projects:[Project] = [] {
        didSet {
            self.tableViewInteraction.reloadData()
        }
    }
    let userDefaults = UserDefaults.standard

    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let showWelcome = self.userDefaults.bool(forKey: K.key.showedWelcomeAlertInteraction)
        if showWelcome {
            self.showWelcomeAlert()
        }
        self.getProjects {
            self.activityIndicator.stopAnimating()
            self.tableViewInteraction.isHidden = false
        }
        self.addPullRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       self.tabBarController?.navigationItem.title = "Votar"
    }
    
    //MARK: - Functions
    
    func getProjects(complete: (()->Void)? = nil) {
        Alamofire.request(api.url.event.interactionWith(eventID: self.detailEvent.id!)).responseJSON { response in
            if let responseServer = response.result.value {
                let json = JSON(responseServer)
                for (_,subJson):(String, JSON) in json {
                    self.projects.append(Project(data: subJson))
                }
                if complete != nil {
                    complete!()
                }
            }
        }
    }
    
    func showWelcomeAlert(){
        let titleWelcome = self.detailEvent.title
        let messageWelcome = self.detailEvent.interactionText
        let alert = UIAlertController(title: titleWelcome, message: messageWelcome, preferredStyle: .alert)
        let btnAccept = UIAlertAction(title: "Participar", style: .default) { (alertAction) in
            self.userDefaults.set(false, forKey: K.key.showedWelcomeAlertInteraction)
        }
        alert.addAction(btnAccept)
        self.present(alert, animated: true, completion: nil)
    }
    
    func voteFor(_ project:Project) {
        let titleConfirmation = self.detailEvent.title
        let tmpMessageConfirmation = self.detailEvent.interactionConfirmationText
        let messageConfirmation = tmpMessageConfirmation?.replacingOccurrences(of: "%s", with: project.text!)
        let alert = UIAlertController(title: titleConfirmation, message: messageConfirmation, preferredStyle: .alert)
        let btnAccept = UIAlertAction(title: "Si", style: .default) { (alertAction) in
            self.tableViewInteraction.isHidden = true
            self.projects = []
            self.tableViewInteraction.reloadData()
            self.activityIndicator.startAnimating()
            self.sendVoteForProject(withID: project.id!, complete: {
                self.getProjects {
                    self.tableViewInteraction.isHidden = false
                    self.activityIndicator.stopAnimating()
                }
            })
            self.userDefaults.set(true, forKey: K.key.interactionForAProject)
        }
        let btnCancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(btnAccept)
        alert.addAction(btnCancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showValidationInteractionAlertFor() {
        let titleValidation = self.detailEvent.title
        let messageValidation = "No se puede votar mas de una vez"
        let alert = UIAlertController(title: titleValidation, message: messageValidation, preferredStyle: .alert)
        let btnAccept = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(btnAccept)
        self.present(alert, animated: true, completion: nil)
    }
    
    func addPullRefresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,action: #selector(self.refreshTable(sender:)),for: .valueChanged)
        if #available(iOS 10.0, *) {
            self.tableViewInteraction.refreshControl = refreshControl
        } else {
            self.tableViewInteraction.addSubview(refreshControl)
        }
    }
    
    func refreshTable(sender: UIRefreshControl) {
        self.projects = []
        self.tableViewInteraction.reloadData()
        self.getProjects{
            sender.endRefreshing()
        }
    }
    
    func sendVoteForProject(withID id:Int, complete : @escaping ()->Void) {
        
        let url = api.url.event.voteWith(interactionID: id)
        Alamofire.request(url, method: .patch).responseJSON { (response) in
            complete()
        }
    }
}

//MARK: - UITableViewDataSource


extension InteractionVC:UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cell.interaction) as! InteractionCell
        cell.nameProject.text = self.projects[indexPath.row].text
        cell.numberOfVote.text = "\(self.projects[indexPath.row].votes!)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.projects.count
    }
    
}

//MARK: - UITableViewDelegate

extension InteractionVC:UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let isInteraction = self.userDefaults.bool(forKey: K.key.interactionForAProject)
        if !isInteraction {
            self.voteFor(self.projects[indexPath.row])
        } else {
            self.showValidationInteractionAlertFor()
        }
    }
    
}
