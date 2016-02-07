//
//  HttpData.swift
//  FuelMonitor
//
//  Created by Stoyan Dobrev on 2/7/16.
//  Copyright © 2016 SDobrev. All rights reserved.
//

import Foundation

@objc class HttpData: NSObject {
    var property:String = ""
    func method() {
        print(self.property)
    }
    
    let url = "http://api.myawesomeapp.com"
    Alamofire.request(.GET, url).responseJSON { response in
    switch response.result {
    case .Success(let data):
    let json = JSON(data)
    let name = json["name"].stringValue
    print(name)
    case .Failure(let error):
    print("Request failed with error: \(error)")
    }
    }
}