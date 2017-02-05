//
//  ContentDispatcher.swift
//  DealsLister
//
//  Created by Nicholas Allio on 05/02/2017.
//  Copyright © 2017 Nicholas Allio. All rights reserved.
//

import UIKit

class ContentDispatcher: NSObject {
    fileprivate let session = URLSession.shared
    fileprivate let parser = DealParser()
    
    fileprivate let ursString = "https://www.travelrepublic.co.uk/api/hotels/deals/search?fields=Aggregates.HotelsByChildDestination"

}
