//
//  ProjectDetailVC.swift
//  Hackatrix
//
//  Created by Franco Castellano on 4/24/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import UIKit
import SVProgressHUD

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
    var isFromModarator = false
    
    override func viewDidLoad() {
        self.getParticipants()
        self.getCandidates()
        super.viewDidLoad()
        //load logged user
        currentUser = UserManager.shared.currentUser
        isUserLogged = currentUser != nil
        tableView.estimatedRowHeight = 66
        self.setUIElements()
    }
    
    func isAuthor() -> Bool {
        if let userId = currentUser?.id, let authorId = idea?.author?.id {
            return userId == authorId
        }
        return false
    }
    
    func setUIElements() {
        self.title = idea?.title
    }
    
    func getParticipants() {
        guard let id = idea?.id else {
            return
        }
        SVProgressHUD.show()
        ProjectManager.shared.getParticipants(ideaId: id) { [weak self] (participants) in
            SVProgressHUD.dismiss()
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
    
    func approveCandidate(_ user: User) {
        guard let id = idea?.id, let userId = user.id else {
            return
        }
        ProjectManager.shared.approveCandidateWithId(userId, ideaId: id, success: {[weak self] (sucess) in
            //refresh participants
            self?.getParticipants()
        }) {[weak self] (error) in
            self?.showErrorAlert(errorMessage: error)
        }
    }
    
    func unregisterParticipant(_ user: User) {
        guard let id = idea?.id, let userId = user.id else {
            return
        }
        ProjectManager.shared.unregisterParticipantWithId(userId, ideaId: id, success: {
            (participants) in
            self.participants = participants
        }, error: { (errorMessage) in
            self.showErrorAlert(errorMessage: errorMessage)
        })
    }
    
    func validateIdea(sender: AnyObject) {
        //        validate idea
    }
    
    func approveCandidate(sender: AnyObject) {
        let uiSwitch = sender as! UISwitch
        let row = uiSwitch.tag
        if let candidate = candidates?.teamMembers[row] {
            approveCandidate(candidate)
        }
    }
    
    func showErrorAlert(errorMessage: String? = "No se pudo completar su solicitud") {
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
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
            ProjectManager.shared.unregisterParticipantWithId(userLoggedId, ideaId: id, success: {
                (participants) in
                self.participants = participants
                let alertController = UIAlertController(title: "", message: "Su registro ha sido cancelado", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                
            }, error: { (errorMessage) in
                self.showErrorAlert(errorMessage: errorMessage)
            })
        } else if candidates?.isCandidate ?? false {
            //unregister user as candidate
            ProjectManager.shared.unregisterAsCandidate(ideaId: id , success: { (candidates) in
                self.candidates = candidates
                let alertController = UIAlertController(title: "Solictud cancelada", message: "Su solicitud de ingreso ha sido cancelada", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                
            }, error: { (errorMessage) in
                self.showErrorAlert(errorMessage: errorMessage)
            })
        } else {
            //register user as candidate
            ProjectManager.shared.registerAsCandidate(ideaId: id , success:  { (candidates) in
                self.candidates = candidates
                let alertController = UIAlertController(title: "Solictud enviada", message: "Su solicitud de ingreso ha sido enviada correctamente", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            } , error : {
                (errorMessage) in
                self.showErrorAlert(errorMessage: errorMessage)
            })
        }
    }
}

extension ProjectDetailVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return isAuthor() ? 3 : 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == IdeaVCSections.details.rawValue {
            return "Sobre la idea"
        } else if section == IdeaVCSections.participants.rawValue {
            return "Participantes"
        } else if section == IdeaVCSections.candidates.rawValue {
            return "Candidatos"
        } else {
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == IdeaVCSections.details.rawValue {
            //details cell
            return isFromModarator ? 2 : 1
        } else if section == IdeaVCSections.participants.rawValue {
            //participants
            let participantsCount = participants?.teamMembers.count ?? 0
            if isUserLogged && !isAuthor() {
                return participantsCount + 1
            } else{
                return participantsCount
            }
        } else if section == IdeaVCSections.candidates.rawValue {
            //participants
            return candidates?.teamMembers.count ?? 0
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        switch section {
        case IdeaVCSections.details.rawValue:
            if indexPath.row == 0 {
                if let detailsCell = tableView.dequeueReusableCell(withIdentifier: "IdeaDetailsTableViewCell", for: indexPath) as? IdeaDetailsTableViewCell {
                    detailsCell.ideaDescription.text = idea?.ideaDescription
                    let author = idea?.author
                    detailsCell.authorName.text = author?.fullName
                    detailsCell.authorEmail.text = author?.email
                    detailsCell.authorPhoneNumber.text = author?.phoneNumber
                    detailsCell.authorRole.text = author?.role?.name
                    return detailsCell
                }
            } else {
                if let detailsCell = tableView.dequeueReusableCell(withIdentifier: "IdeaValidationTableViewCell", for: indexPath) as? IdeaValidationTableViewCell {
                    let isIdeaValid = idea?.isValid ?? false
                    detailsCell.ideaValidSwitch.setOn(isIdeaValid, animated: false)
                    detailsCell.ideaValidSwitch.addTarget(self, action: #selector(self.validateIdea(sender:)), for: .valueChanged)
                    return detailsCell
                }
            }
        case IdeaVCSections.participants.rawValue:
            if indexPath.row == 0 && isUserLogged && !isAuthor() {
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
                    let offset = (isUserLogged && !isAuthor()) ? 1 : 0
                    let participant = participants?.teamMembers[indexPath.row - offset]
                    cell.name.text = participant?.fullName
                    cell.email.text = participant?.email
                    cell.phone.text = participant?.phoneNumber
                    cell.role.text = participant?.role?.name
                    cell.isActive.isHidden = true
                    return cell
                }
            }
        case IdeaVCSections.candidates.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectParticipantTableViewCell", for: indexPath) as? ProjectParticipantTableViewCell {
                let candidate = candidates?.teamMembers[indexPath.row]
                cell.name.text = candidate?.fullName
                cell.email.text = candidate?.email
                cell.phone.text = candidate?.phoneNumber
                cell.role.text = candidate?.role?.name
                let isParticipant = participants?.teamMembers.filter { $0.id == candidate?.id}.count ?? 0 > 0
                cell.isActive.setOn(isParticipant, animated: false)
                cell.isActive.isHidden = false
                cell.isActive.tag = indexPath.row
                cell.isActive.addTarget(self, action: #selector(self.approveCandidate(sender:)), for: .valueChanged)
                return cell
            }
            break
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

}

