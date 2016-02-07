//
//  HttpData.swift
//  FuelMonitor
//
//  Created by Stoyan Dobrev on 2/7/16.
//  Copyright © 2016 SDobrev. All rights reserved.
//

import Foundation
import Alamofire

@objc class HttpData: NSObject {
    var price:Double = 0
    
    func httpRequest (param: String){
        let url = "http://fuelo.net/api/price?key=beb5cdf4554ce11&fuel=" + param;
        Alamofire.request(.GET, url, parameters: ["foo": "bar"])
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    let response = JSON as! NSDictionary
                    
                    //example if there is an id
                    let fuelPrice = response.objectForKey("price")
                    self.price = fuelPrice as! Double
                }
        }
    }
    
}