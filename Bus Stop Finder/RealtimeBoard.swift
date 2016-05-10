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
    
    init(board: NSDictionary){
        stop = BusStop(stop: board["Stop"] as! NSDictionary)
    }
    
}