//
//  ProjectDetailVC.swift
//  Hackatrix
//
//  Created by Franco Castellano on 4/24/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import UIKit

class ProjectDetailVC: UIViewController {
    @IBOutlet weak var lblDescription: UILabel!

    var idea: Idea?
    var participants: [Employee] = []

    override func viewDidLoad() {
        self.getParticipants()
        super.viewDidLoad()
        self.setUIElements()
    }

    func setUIElements() {
        let title = self.idea?.title?.split(separator: "-")[0].trimmingCharacters(in: .whitespacesAndNewlines)
        let description = self.idea?.title?.split(separator: "-")[1].trimmingCharacters(in: .whitespacesAndNewlines)
        self.title = title
        self.lblDescription.text = description
    }

    func getParticipants() {
        //TODO: call get participants and refresh tableview
    }

    func subscribe() {
        //TODO: call subscribe method and refresh tableview
    }
}

extension ProjectDetailVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.participants.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == self.participants.count {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectSubscribeTableViewCell", for: indexPath) as? ProjectSubscribeTableViewCell {
                cell.btnSubscribe.addTarget(self, action: #selector(ProjectDetailVC.subscribe), for: .touchUpInside)
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectParticipantTableViewCell", for: indexPath) as? ProjectParticipantTableViewCell {
                cell.lblParticipant.text = ""
                return cell
            }
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
}
