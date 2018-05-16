//
//  ProjectDetailVC.swift
//  Hackatrix
//
//  Created by Franco Castellano on 4/24/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import UIKit

enum IdeaVCSections: Int {
    case details = 0
    case participants = 1
    case candidates = 2
}

class ProjectDetailVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var idea: Idea?
    var currentUser: User?
    var participants: Participants? {
        didSet {
          tableView.reloadData()
        }
    }
    var candidates: Candidates? {
        didSet {
            tableView.reloadData()
        }
    }
    var isUserLogged = false

    override func viewDidLoad() {
        self.getParticipants()
        super.viewDidLoad()
        //load logged user
        currentUser = UserManager.shared.currentUser
        isUserLogged = currentUser != nil
        tableView.estimatedRowHeight = 66
        self.setUIElements()
    }

    func setUIElements() {
        self.title = idea?.title
    }

    func getParticipants() {
        guard let id = idea?.id else {
            return
        }
        ProjectManager.shared.getParticipants(ideaId: id) { [weak self] (participants) in
            self?.participants = participants
        }
    }
    
    func getCandidates() {
        guard let id = idea?.id else {
            return
        }
        ProjectManager.shared.getCandidates(ideaId: id) { [weak self] (candidates) in
            self?.candidates = candidates
        }
    }
    
    func showErrorAlert() {
        let alertController = UIAlertController(title: "Error", message: "No se pudo completar su solicitud", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func subscribe() {
        guard let id = idea?.id, let userLoggedId = currentUser?.id else {
            return
        }
        if participants?.isRegistered ?? false {
            //unregister user as participant
            ProjectManager.shared.unregisterParticipantWithId(userLoggedId, ideaId: id) { (participants) in
                if let participants = participants {
                    self.participants = participants
                    let alertController = UIAlertController(title: "", message: "Su registro ha sido cancelado", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    self.showErrorAlert()
                }
            }
        } else if candidates?.isCandidate ?? false {
            //unregister user as candidate
            ProjectManager.shared.unregisterAsCandidate(ideaId: id) { (candidates) in
                if let candidates = candidates {
                    self.candidates = candidates
                    let alertController = UIAlertController(title: "Solictud cancelada", message: "Su solicitud de ingreso ha sido cancelada", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    self.showErrorAlert()
                }
            }
        } else {
            //register user as candidate
            ProjectManager.shared.registerAsCandidate(ideaId: id) { (candidates) in
                if let candidates = candidates {
                    self.candidates = candidates
                    let alertController = UIAlertController(title: "Solictud enviada", message: "Su solicitud de ingreso ha sido enviada correctamente", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Error", message: "No se pudo completar su solicitud de ingreso", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}

extension ProjectDetailVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == IdeaVCSections.details.rawValue {
            return "Sobre la idea"
        } else if section == IdeaVCSections.participants.rawValue {
            return "Participantes"
        } else {
            return ""
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == IdeaVCSections.details.rawValue {
            //details cell
            return 1
        } else if section == IdeaVCSections.participants.rawValue {
            //participants
            let participantsCount = participants?.teamMembers.count ?? 0
            if isUserLogged {
                return participantsCount + 1
            } else{
                return participantsCount
            }
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        switch section {
        case IdeaVCSections.details.rawValue:
            if let detailsCell = tableView.dequeueReusableCell(withIdentifier: "IdeaDetailsTableViewCell", for: indexPath) as? IdeaDetailsTableViewCell {
                detailsCell.ideaDescription.text = idea?.ideaDescription
                let author = idea?.author
                detailsCell.authorName.text = author?.fullName
                detailsCell.authorEmail.text = author?.email
                detailsCell.authorRole.text = author?.role?.name
                return detailsCell
            }
            return UITableViewCell()
        case IdeaVCSections.participants.rawValue:
            if indexPath.row == 0 && isUserLogged {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectSubscribeTableViewCell", for: indexPath) as? ProjectSubscribeTableViewCell {
                    cell.btnSubscribe.addTarget(self, action: #selector(ProjectDetailVC.subscribe), for: .touchUpInside)
                    
                    if participants?.isRegistered ?? false {
                        //user registered
                        cell.btnSubscribe.setTitle("Eliminar registro", for: .normal)
                        cell.btnSubscribe.tintColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                    } else if candidates?.isCandidate ?? false {
                        //user candidate
                        cell.btnSubscribe.setTitle("Cancelar Solicitud", for: .normal)
                        cell.btnSubscribe.tintColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                    } else {
                        //user not candidate
                        cell.btnSubscribe.setTitle("Solicitar Ingreso", for: .normal)
                        cell.btnSubscribe.tintColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
                    }
                    return cell
                }
            } else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectParticipantTableViewCell", for: indexPath) as? ProjectParticipantTableViewCell {
                    let offset = isUserLogged ? 1 : 0
                    let participant = participants?.teamMembers[indexPath.row - offset]
                    cell.name.text = participant?.fullName
                    cell.email.text = participant?.email
                    cell.phone.text = participant?.phoneNumber
                    cell.role.text = participant?.role?.name
                    return cell
                }
            }
            return UITableViewCell()
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
