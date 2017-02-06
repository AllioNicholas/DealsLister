//
//  ContentDispatcher.swift
//  DealsLister
//
//  Created by Nicholas Allio on 05/02/2017.
//  Copyright © 2017 Nicholas Allio. All rights reserved.
//

import UIKit

struct RequestConstant {
    static let idParam = "&id="
    static let typeParam = "&type="
    static let widthParam = "&width="
    static let heightParam = "&height="
}

class ContentDispatcher: NSObject {
    fileprivate let session = URLSession.shared
    fileprivate let parser = DealParser()
    
    fileprivate let baseUrlDealsString = "https://www.travelrepublic.co.uk/api/hotels/deals/search?fields=Aggregates.HotelsByChildDestination"
    fileprivate let baseUrlImageString = "https://d2f0rb8pddf3ug.cloudfront.net/api2/destination/images/getfromobject?useDialsImages=true"
    
    fileprivate let jsonBody: [String:Any] = ["CheckInDate":"2017-05-10T00:00:00.000Z",
                                              "Flexibility":3,
                                              "Duration":7,
                                              "Adults":2,
                                              "DomainId":1,
                                              "CultureCode":"en-gb",
                                              "CurrencyCode":"GBP",
                                              "OriginAirports":["LHR","LCY","LGW","LTN","STN","SEN"],
                                              "FieldFlags":8143571,
                                              "IncludeAggregates":true
    ]
    
    func getDeals(_ completionHandler: @escaping ([Deal]?)->()) {
        if let url = URL(string: baseUrlDealsString) {
            
            do {
                let bodyData = try JSONSerialization.data(withJSONObject: jsonBody, options: .prettyPrinted)
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                request.httpBody = bodyData
                
                getData(request: request, { (data) in
                    if let data = data {
                        let deals = self.parser.parsedDeals(data: data)
                        completionHandler(deals)
                    } else {
                        completionHandler(nil)
                    }
                })
                
            } catch {
                completionHandler(nil)
            }
        }
    }
    
    func getImage(id: Int, type: Int, width: Int, height: Int, _ completion: @escaping (Data?)->()) {
        let urlString = baseUrlImageString +
            RequestConstant.idParam + "\(id)" +
            RequestConstant.typeParam + "\(type)" +
            RequestConstant.heightParam + "\(height)" +
            RequestConstant.widthParam + "\(width)"
        
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            getData(request: request, { (data) in
                if let data = data {
                    completion(data)
                } else {
                    completion(nil)
                }
            })
        }
    }
    
    fileprivate func getData(request: URLRequest, _ completionHandler: @escaping (Data?)->()) {
        let task = session.dataTask(with: request) { (data, response, error) in
            guard (error == nil) else {
                completionHandler(nil)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completionHandler(nil)
                return
            }
            
            guard let data = data else {
                completionHandler(nil)
                return
            }
            
            completionHandler(data)
        }
        
        task.resume()
    }

}
