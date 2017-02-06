//
//  DealTableViewCell.swift
//  DealsLister
//
//  Created by Nicholas Allio on 06/02/2017.
//  Copyright © 2017 Nicholas Allio. All rights reserved.
//

import UIKit

class DealTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func setImage(data: Data?) {
        if let data = data {
            self.backgroundImage.image = UIImage(data: data)
            self.activityIndicator.stopAnimating()
        } else {
            self.backgroundImage.image = nil
        }
        
    }
    
    func setupUI(deal: Deal) {
        if let title = deal.title, let count = deal.count, let price = deal.minPrice {
            self.destinationLabel.text = title.uppercased()
            self.countLabel.text = "(\(count))"
            self.priceLabel.text = String(format: "£%.2f", price)
        } else {
            self.destinationLabel.text = "-"
            self.countLabel.text = "(?)"
            self.priceLabel.text = "-.-"
        }
    }

}
