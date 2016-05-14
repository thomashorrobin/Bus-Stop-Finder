//
//  RealtimeBoard.swift
//  Bus Stop Finder
//
//  Created by Thomas Horrobin on 11/05/16.
//  Copyright © 2016 Wellington City Council Extension Apps. All rights reserved.
//

import Foundation

class RealtimeBoard {
    var stop: BusStop
    var departures = [RealtimeDepartureEstimate]()
    
    init(board: NSDictionary){
        stop = BusStop(stop: board["Stop"] as! NSDictionary)
        for departure in board["Services"] as! NSArray {
            departures.append(RealtimeDepartureEstimate(estimate: departure as! NSDictionary))
        }
    }
    
}