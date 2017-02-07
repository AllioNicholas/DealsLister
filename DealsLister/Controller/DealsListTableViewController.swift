//
//  DealsListTableViewController.swift
//  DealsLister
//
//  Created by Nicholas Allio on 05/02/2017.
//  Copyright © 2017 Nicholas Allio. All rights reserved.
//

import UIKit

class DealsListTableViewController: UITableViewController {
    
    var contendDispatcher = ContentDispatcher()
    var dealsList: [Deal]?
    var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.attributedTitle = NSAttributedString(string: "")
        self.tableView.refreshControl?.addTarget(self, action: #selector(loadDeals), for: .valueChanged)
        
        loadDeals()
    }
    
    func loadingMode(setOn: Bool) {
        if setOn {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            self.tableView.backgroundView = activityIndicator
            activityIndicator.startAnimating()
            self.tableView.separatorStyle = .none
        } else {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.tableView.refreshControl?.endRefreshing()
            self.activityIndicator = nil
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: self.tableView.frame.height))
            noDataLabel.text = "No deals available"
            noDataLabel.textAlignment = .center
            self.tableView.backgroundView = noDataLabel
            self.tableView.separatorStyle = .none
        }
    }
    
    func loadDeals() {
        loadingMode(setOn: true)
        contendDispatcher.getDeals { (deals) in
            if let deals = deals {
                self.dealsList = deals
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.loadingMode(setOn: false)
                }
            } else {
                let alert = UIAlertController(title: "Error", message: "An error occurred while downloading deals", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Retry", style: .cancel, handler: { (action) in
                    self.loadDeals()
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                    self.loadingMode(setOn: false)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if let deals =  self.dealsList {
            if deals.count > 0 {
                self.tableView.backgroundView = nil
                self.tableView.separatorStyle = .singleLine
                return 1
            } else {
                let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: self.tableView.frame.height))
                noDataLabel.text = "No deals available"
                noDataLabel.textAlignment = .center
                self.tableView.backgroundView = noDataLabel
                self.tableView.separatorStyle = .none
                return 0
            }
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let deals = self.dealsList {
            return deals.count
        } else {
            return 0
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dealCell", for: indexPath) as? DealTableViewCell

        if let cell = cell, let deals = self.dealsList {
            let currentDeal = deals[indexPath.row]
            
            if let data = currentDeal.imageData {
                cell.setImage(data: data)
            } else {
                cell.setImage(data: nil)
                contendDispatcher.getImage(id: currentDeal.id, type: currentDeal.type, width: Int(cell.frame.width)*3, height: Int(cell.frame.height)*3, { (data) in
                    if let data = data {
                        deals[indexPath.row].imageData = data
                        DispatchQueue.main.async {
                            cell.setImage(data: data)
                        }
                    }
                })
            }
            
            cell.setupUI(deal: currentDeal)
            return cell
        }
        
        return DealTableViewCell()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
