//
//  MyIdeasVC.swift
//  Hackatrix
//
//  Created by Carlos Alberto Monzon Salvador on 5/17/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import UIKit
import SVProgressHUD

class MyIdeasVC: UIViewController {
    
    var detailEvent: Event?
    
    @IBOutlet weak var tableView: UITableView!
    
    var ideas: [Idea]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(MyIdeasVC.handleRefresh(_:)),for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        getUserIdeas()
        super.viewDidLoad()
        tableView.estimatedRowHeight = 66
        tableView.addSubview(refreshControl)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.getUserIdeas(pullToRefresh: true)
    }
    
    func getUserIdeas(pullToRefresh:Bool = false) {
        if !pullToRefresh {
            SVProgressHUD.show()
        }
        ProjectManager.shared.getUserIdeas() {[weak self] (ideas) in
            if pullToRefresh {
                self?.refreshControl.endRefreshing()
            } else {
                SVProgressHUD.dismiss()
            }
            self?.ideas = ideas
        }
    }
    func addNewIdea() {
        self.performSegue(withIdentifier: K.segue.newIdea, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ProjectDetailVC, segue.identifier == K.segue.project, let indexPath = sender as? IndexPath {
            destination.idea = self.ideas?[indexPath.row]
        }
        else if let addNewIdeaVC = segue.destination as? AddNewIdeaVC, segue.identifier == K.segue.newIdea {
            addNewIdeaVC.eventId = detailEvent?.id
            addNewIdeaVC.delegate = self
        }
    }
}

extension MyIdeasVC: AddNewIdeaDelegate {
    func complete(idea: Idea) {
        ideas?.append(idea)
    }
}

extension MyIdeasVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let ideasCount = ideas?.count ?? 0
        if let _ = UserManager.shared.currentUser {
            //user is log in
            return ideasCount + 1
        }
        return ideasCount
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == ideas?.count {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "AddIdeaTableViewCell", for: indexPath) as? AddIdeaTableViewCell {
                cell.btnAddIdea.addTarget(self, action: #selector(MyIdeasVC.addNewIdea), for: .touchUpInside)
                return cell
            }
        } else {
            if let ideaCell = tableView.dequeueReusableCell(withIdentifier: "MyIdeaTableViewCell", for: indexPath) as? MyIdeaTableViewCell {
                let idea = self.ideas?[indexPath.row]
                ideaCell.title.text = idea?.title
                ideaCell.ideaDescription.text = idea?.ideaDescription
                ideaCell.validated.isHidden = !(idea?.isValid ?? false)
                return ideaCell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: K.segue.project, sender: indexPath)
    }
}
