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
    var dealsList: [Deal] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contendDispatcher.getDeals { (deals) in
            if let deals = deals {
                self.dealsList = deals
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.dealsList.count > 0 {
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dealsList.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dealCell", for: indexPath) as? DealTableViewCell

        if let cell = cell {
            let currentDeal = self.dealsList[indexPath.row]
            
            if let data = currentDeal.imageData {
                cell.setImage(data: data)
            } else {
                cell.setImage(data: nil)
                contendDispatcher.getImage(id: currentDeal.id, type: currentDeal.type, width: Int(cell.frame.width)*3, height: Int(cell.frame.height)*3, { (data) in
                    if let data = data {
                        self.dealsList[indexPath.row].imageData = data
                        cell.setImage(data: data)
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
