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
    
    func httpRequest (param: String){
        let url = "http://fuelo.net/api/price?key=beb5cdf4554ce11&fuel=" + param;
        Alamofire.request(.GET, url, parameters: ["foo": "bar"])
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    let response = JSON as! NSDictionary
                    let fuelPrice = response.objectForKey("price")
                    let price = fuelPrice as! Double
                    
                    print(price)
                }
        }
    }
}