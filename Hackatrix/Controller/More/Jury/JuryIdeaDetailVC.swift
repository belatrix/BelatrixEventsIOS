//
//  JuryIdeaDetailVC.swift
//  Hackatrix
//
//  Created by Diego Velasquez on 5/20/18.
//  Copyright © 2018 Belatrix. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

class JuryIdeaDetailVC : UIViewController {
  
  var idea : Idea!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var headerView: UIView!
  var elements: [Rate] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    sizeHeaderToFit()
  }
  
  func sizeHeaderToFit() {
    let headerView = tableView.tableHeaderView!
    let height = descriptionLabel.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
    let height2 = titleLabel.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
    var frame = headerView.frame
    frame.size.height = height + height2 + 75
    headerView.frame = frame
    tableView.tableHeaderView = headerView
  }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.juryRate {
            let dvc = segue.destination as! JuryIdeaRateVC
            dvc.rate = sender as! Rate
            dvc.idea = idea
            dvc.delegate = self
        }
    }
  
  func setupUI(){
    titleLabel.text = idea.title
    descriptionLabel.text = idea.ideaDescription
    getCriteriaList()
  }
  
  func getCriteriaList() {
    SVProgressHUD.show()
    ProjectManager.shared.getIdeaRateList(ideaId: idea.id!, completion: { rateList in
      SVProgressHUD.dismiss()
      self.elements = rateList
    })
  }

}


extension JuryIdeaDetailVC: UITableViewDataSource , UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let rate  = elements[indexPath.row]
    performSegue(withIdentifier: K.segue.juryRate, sender: rate)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "juryCell", for: indexPath)
    let rate  = elements[indexPath.row]
    cell.textLabel?.text = rate.categoryName
    let valueString = rate.value == 0 ? "Calificar" : "\(rate.value ?? 0)"
    cell.detailTextLabel?.text = valueString
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return elements.count
  }
}

extension JuryIdeaDetailVC: JuryIdeaRateDelegate{
  
  func onJuryRated() {
    self.getCriteriaList()
  }
}
