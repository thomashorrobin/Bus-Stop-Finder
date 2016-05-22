//
//  RealtimeDepartureEstimate.swift
//  Bus Stop Finder
//
//  Created by Thomas Horrobin on 11/05/16.
//  Copyright © 2016 Wellington City Council Extension Apps. All rights reserved.
//

import Foundation

class RealtimeDepartureEstimate {
    var routeId: String
    var destination: String
    var secondsTillDeparture: Int
    typealias t = (secs: Int, mins: Int, hrs: Int)
    
    init(estimate: NSDictionary){
        routeId = estimate["ServiceID"] as! String
        destination = estimate["DestinationStopName"] as! String
        //secondsTillDeparture = Int(estimate["DisplayDepartureSeconds"] as! String)!
        secondsTillDeparture = estimate["DisplayDepartureSeconds"] as! Int
    }
    
//    func displaySecs(tup: t) -> String {
//        if t.mins == 0 {
//            return String(t.secs)
//        } else if t.hrs == 0 {
//            return String(t.mins)
//        } else {
//            return String(t.hrs)
//        }
//    }
    
    func divmod(seconds: Int) -> t {
        let s = seconds % 60
        let m = seconds / 60
        let h = m / 60
        return (s,m,h)
    }
}