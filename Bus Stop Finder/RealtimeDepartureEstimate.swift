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
    
    init(estimate: NSDictionary){
        routeId = estimate["ServiceID"] as! String
        destination = estimate["DestinationStopName"] as! String
        secondsTillDeparture = Int(estimate["DisplayDepartureSeconds"] as! String)!
    }
}