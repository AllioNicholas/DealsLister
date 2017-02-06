//
//  Deal.swift
//  DealsLister
//
//  Created by Nicholas Allio on 05/02/2017.
//  Copyright © 2017 Nicholas Allio. All rights reserved.
//

import UIKit

struct DealConstant {
    static let type = "Type"
    static let id = "Id"
    static let title = "Title"
    static let count = "Count"
    static let minPrice = "MinPrice"
    static let position = "Position"
}

class Deal: NSObject {
    var type: Int!
    var id: Int!
    var title: String?
    var count: Int?
    var minPrice: Double?
    var position: Int?
    
    var imageData: Data?
    
    init(dict: [String:Any]) {
        super.init()
        self.type = dict[DealConstant.type] as! Int
        self.id = dict[DealConstant.id] as! Int
        self.title = dict[DealConstant.title] as? String
        self.count = dict[DealConstant.count] as? Int
        self.minPrice = dict[DealConstant.minPrice] as? Double
        self.position = dict[DealConstant.position] as? Int
    }

}
