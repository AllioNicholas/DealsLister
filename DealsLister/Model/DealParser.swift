//
//  DealParser.swift
//  DealsLister
//
//  Created by Nicholas Allio on 05/02/2017.
//  Copyright © 2017 Nicholas Allio. All rights reserved.
//

import UIKit

struct ParsingConstant {
    //General
    static let aggregates = "Aggregates"
    static let HotelsByChildDest = "HotelsByChildDestination"
    
    //Deal
    static let title = "Title"
    static let count = "Count"
    static let minPrice = "MinPrice"
    static let position = "Position"
}

class DealParser: NSObject {
    
    func parsedDeals(data: Data) -> [Deal]? {
        var parsedResut: [Deal] = []
        do {
            let parsedJSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
            if let parsedJSON = parsedJSON {
                if let aggregates = parsedJSON[ParsingConstant.aggregates] as? [String:Any] {
                    if let deals = aggregates[ParsingConstant.HotelsByChildDest] as? [String:[String:Any]] {
                        for (typeAndIdString, deal) in deals {
                            let typeAndId = typeAndIdString.components(separatedBy: "|")
                            var dealDict: [String:Any] = [:]
                            dealDict[DealConstant.type] = Int(typeAndId[0])
                            dealDict[DealConstant.id] = Int(typeAndId[1])
                            dealDict[DealConstant.title] = deal[ParsingConstant.title] as? String
                            dealDict[DealConstant.count] = deal[ParsingConstant.count] as? Int
                            dealDict[DealConstant.minPrice] = deal[ParsingConstant.minPrice] as? Double
                            dealDict[DealConstant.position] = deal[ParsingConstant.position] as? Int
                            
                            let newDeal = Deal(dict: dealDict)
                            parsedResut.append(newDeal)
                        }
                        return parsedResut
                    }
                }
            }
            return nil
        } catch {
            return nil
        }
    }

}
