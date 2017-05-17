//
//  NewsVC.swift
//  Hackatrix
//
//  Created by Erik Fernando Flores Quispe on 9/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import DZNEmptyDataSet

class NewsVC: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var tableViewNews: UITableView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    var news:[News] = [] {
        didSet {
            self.tableViewNews.reloadData()
        }
    }
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customStyleTableView()
        self.getNews {
            self.tableViewNews.isHidden = false
            self.activity.stopAnimating()
        }
        self.addPullRefresh()
        
        
    }
    
    //MARK: - Functions
    
    func customStyleTableView() {
        self.tableViewNews.rowHeight = UITableViewAutomaticDimension
        self.tableViewNews.estimatedRowHeight = 50
        self.tableViewNews.emptyDataSetSource = self
        self.tableViewNews.emptyDataSetDelegate = self
        self.tableViewNews.tableFooterView = UIView()
    }
    
    func getNews(complete: (()->Void)? = nil) {
        Alamofire.request(api.url.notifications.all).responseJSON { response in
            if let responseServer = response.result.value {
                let json = JSON(responseServer)
                for (_,subJson):(String, JSON) in json {
                    self.news.append(News(data: subJson))
                }
                if complete != nil {
                    complete!()
                }
            }
        }
    }
    
    func addPullRefresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,action: #selector(self.refreshTable(sender:)),for: .valueChanged)
        if #available(iOS 10.0, *) {
            self.tableViewNews.refreshControl = refreshControl
        } else {
            self.tableViewNews.addSubview(refreshControl)
        }
    }
    
    func refreshTable(sender: UIRefreshControl) {
        self.news = []
        self.tableViewNews.reloadData()
        self.getNews {
         sender.endRefreshing()
        }
    }


}

//MARK: - UITableViewDataSource

extension NewsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cell.news) as! NewsCell
        cell.dateLbl.text = Utils.date.getFormatter(dateString: self.news[indexPath.row].datetime!)
        cell.descriptionLbl.text = self.news[indexPath.row].text
        return cell
    }
}

//MARK: - UITableViewDelegate

extension NewsVC: UITableViewDelegate {

}

//MARK: - DZNEmptyData

extension NewsVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "BelatrixLogo")
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}

