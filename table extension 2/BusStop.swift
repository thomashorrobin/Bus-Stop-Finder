//
//  BusStop.swift
//  Bus Stop Finder
//
//  Created by Thomas Horrobin on 2/05/16.
//  Copyright © 2016 Wellington City Council Extension Apps. All rights reserved.
//

import Foundation
import MapKit

class BusStop: NSObject {
    var name: String
    var sms: String
//    var latitude: Double
//    var longitude: Double
    
    var title: String? {
        return "Stop: " + sms
    }
    
    var subtitle: String? {
        return name
    }
    
//    var coordinate: CLLocationCoordinate2D {
//        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//    }
    
    override var description: String{
        return name
    }
    
    init(latitude: Double, longitude: Double, busStopName: String, sms: String) {
//        self.latitude = latitude
//        self.longitude = longitude
        self.name = busStopName
        self.sms = sms
    }
    
    init(stop: NSDictionary) {
        self.name = stop["Name"] as! String!
        self.sms = stop["Sms"] as! String!
//        self.latitude = Double(stop["Lat"] as! String)! //4.5//(stop["Lat"] as? Double?)!
//        self.longitude = Double(stop["Long"] as! String)! //3.4//(stop["Long"] as? Double?)!
        
    }
}