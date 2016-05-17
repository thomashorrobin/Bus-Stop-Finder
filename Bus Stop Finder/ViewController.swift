//
//  ViewController.swift
//  Bus Stop Finder
//
//  Created by Thomas Horrobin on 1/05/16.
//  Copyright © 2016 Wellington City Council Extension Apps. All rights reserved.
//

import Cocoa
import MapKit
import CoreLocation
//import AppKit

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource, MKMapViewDelegate  {
    
    @IBAction func addThing(sender: NSButton) {
        myObjects.append(MyObject(p1: "Wilbur",p2: "Townsend"))
        tableView.reloadData()
        
        let alert = NSAlert()
        alert.messageText = "Warning"
        alert.addButtonWithTitle("Yes")
        alert.addButtonWithTitle("No")
        alert.informativeText = "You have made changes, are you sure you want to discard them? " + stops.count.description
        
        alert.runModal()
    }
    
    @IBOutlet weak var mainMap: MKMapView!
    
    
    @IBOutlet weak var tableView: NSTableView!
    
    var myObjects = [MyObject]()
    var stops = [BusStop]()

    override func viewDidLoad() {
        super.viewDidLoad()
        myObjects.append(MyObject(p1: "dee",p2: "edfs"))
        myObjects.append(MyObject(p1: "William",p2: "Fussey"))
        myObjects.append(MyObject(p1: "Thomas",p2: "Horrobin"))
        tableView.setDelegate(self)
        tableView.setDataSource(self)
        mainMap.delegate = self
        let l = CLLocationCoordinate2D(latitude: -41.286103, longitude: 174.775535)
        var s = MKCoordinateSpan()
        s.latitudeDelta = 0.03
        s.longitudeDelta = 0.03
        let r = MKCoordinateRegion(center: l, span: s)
        
        mainMap.setRegion(r, animated: false)
        loadRestApi()
    }// Here we add disclosure button inside annotation window
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        print("viewForannotation")
        if annotation is MKUserLocation {
            //return nil
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            //println("Pinview was nil")
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
        }
        
        let button = NSButton()
        button.title = "hello button"
        button.target = self
        
        button.action = #selector(dealWithWhatever)
        
        pinView?.rightCalloutAccessoryView = button
        
        
        return pinView
    }
    
    
    
    @objc
    func dealWithWhatever(sender: AnyObject?) {
        print(sender?.description)
    }
    
    func loadRestApi(){
        let getEndpoint: String = "http://104.236.117.15:1337/stops" 
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
                let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                
                for j in jsonDictionary {
                    let bs = BusStop(stop: j as! NSDictionary)
                    
                    self.stops.append(bs)
                    self.mainMap.addAnnotation(bs)
                }
            } catch {
                print("bad things happened")
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
                
            })
        })
        
        task.resume()
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return stops.count //your data ist the array of data for each row
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        
        var s: String
        
        if tableColumn!.title == "Bus Stop Name" //if you have more columns
        {
            s = stops[row].name
        }
        else if tableColumn!.title == "Bus Stop Number"  //second column
        {
            s = stops[row].sms
        }
        else if tableColumn!.title == "Lat"  //second column
        {
            s = String(format:"%.1f", stops[row].latitude)
        }
        else //second column
        {
            s = String(format:"%.1f", stops[row].longitude)
        }
        
        return s
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        let row = tableView.selectedRow
        print(stops[row].name)
        // a row was selected, to something with that information!
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

