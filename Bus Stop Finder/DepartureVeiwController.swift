//
//  DepartureVeiwController.swift
//  Bus Stop Finder
//
//  Created by Thomas Horrobin on 11/05/16.
//  Copyright © 2016 Wellington City Council Extension Apps. All rights reserved.
//

import Cocoa

class DepartureVeiwController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    var board: RealtimeBoard?
    @IBOutlet weak var tableView: NSTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.setDelegate(self)
        tableView.setDataSource(self)
        loadRestApi()
        // Do view setup here.
    }
    
    func loadRestApi(){
        let getEndpoint: String = "https://www.metlink.org.nz/api/v1/StopDepartures/4323"
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: getEndpoint)!
        let task = session.dataTaskWithURL(url, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            // Make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else {
                    print("Not a 200 response")
                    return
            }
            
            // Read the JSON
            do {
                
                // Parse the JSON to get the IP
                let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                self.board = RealtimeBoard(board: jsonDictionary)
                
                self.tableView.reloadData()
                //print(self.board?.stop.name)
                
            } catch {
                print("bad things happened")
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                //self.tableView.reloadData()
                
            })
        })
        
        task.resume()
    }
    
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        if let b = board {
            return b.departures.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        
        var s: String
        
        if let b = board {
            
            if tableColumn!.title == "Bus" //if you have more columns
            {
                s = b.departures[row].routeId
            }
            else if tableColumn!.title == "Destination"  //second column
            {
                s = b.departures[row].destination
            }
            else //second column
            {
                s = String(b.departures[row].secondsTillDeparture)
            }
            
        } else {
            return 0
        }
        
        return s
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        let row = tableView.selectedRow
        print(row)
        // a row was selected, to something with that information!
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}
