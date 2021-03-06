//
//  TodayViewController.swift
//  table extension 2
//
//  Created by Thomas Horrobin on 22/05/16.
//  Copyright © 2016 Wellington City Council Extension Apps. All rights reserved.
//

import Cocoa
import NotificationCenter

class TodayViewController: NSViewController, NCWidgetProviding, NCWidgetListViewDelegate, NCWidgetSearchViewDelegate {

    @IBOutlet var listViewController: NCWidgetListViewController!
    var searchController: NCWidgetSearchViewController?
    
    // MARK: - NSViewController

    override var nibName: String? {
        return "TodayViewController"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let bs1 = BusStop(latitude: -41.2811885, longitude: 174.7504369, busStopName: "Karori Road at Standen Street (near 90)", sms: "4323")
        let bs2 = BusStop(latitude: -41.2811885, longitude: 174.7504369, busStopName: "Courtenay Place - Paramount", sms: "5000")

        // Set up the widget list view controller.
        // The contents property should contain an object for each row in the list.
        //sleep(5)
        self.listViewController.contents = [bs1, bs2]
    }

    override func dismissViewController(viewController: NSViewController) {
        super.dismissViewController(viewController)

        // The search controller has been dismissed and is no longer needed.
        if viewController == self.searchController {
            self.searchController = nil
        }
    }

    // MARK: - NCWidgetProviding

    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Refresh the widget's contents in preparation for a snapshot.
        // Call the completion handler block after the widget's contents have been
        // refreshed. Pass NCUpdateResultNoData to indicate that nothing has changed
        // or NCUpdateResultNewData to indicate that there is new data since the
        // last invocation of this method.
        completionHandler(.NoData)
    }

    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInset: NSEdgeInsets) -> NSEdgeInsets {
        // Override the left margin so that the list view is flush with the edge.
        var newInsets = defaultMarginInset
        newInsets.left = 0
        return newInsets
    }

    var widgetAllowsEditing: Bool {
        // Return true to indicate that the widget supports editing of content and
        // that the list view should be allowed to enter an edit mode.
        return true
    }

    func widgetDidBeginEditing() {
        // The user has clicked the edit button.
        // Put the list view into editing mode.
        self.listViewController.editing = true
    }

    func widgetDidEndEditing() {
        // The user has clicked the Done button, begun editing another widget,
        // or the Notification Center has been closed.
        // Take the list view out of editing mode.
        self.listViewController.editing = false
    }

    // MARK: - NCWidgetListViewDelegate

    func widgetList(list: NCWidgetListViewController!, viewControllerForRow row: Int) -> NSViewController! {
        // Return a new view controller subclass for displaying an item of widget
        // content. The NCWidgetListViewController will set the representedObject
        // of this view controller to one of the objects in its contents array.
        return ListRowViewController()
    }

    func widgetListPerformAddAction(list: NCWidgetListViewController!) {
        // The user has clicked the add button in the list view.
        // Display a search controller for adding new content to the widget.
        self.searchController = NCWidgetSearchViewController()
        self.searchController!.delegate = self

        // Present the search view controller with an animation.
        // Implement dismissViewController to observe when the view controller
        // has been dismissed and is no longer needed.
        self.presentViewControllerInWidget(self.searchController)
    }

    func widgetList(list: NCWidgetListViewController!, shouldReorderRow row: Int) -> Bool {
        // Return true to allow the item to be reordered in the list by the user.
        return true
    }

    func widgetList(list: NCWidgetListViewController!, didReorderRow row: Int, toRow newIndex: Int) {
        // The user has reordered an item in the list.
//        print(row)
//        print(newIndex)
//        print("==END==")
    }

    func widgetList(list: NCWidgetListViewController!, shouldRemoveRow row: Int) -> Bool {
        // Return true to allow the item to be removed from the list by the user.
        return true
    }

    func widgetList(list: NCWidgetListViewController!, didRemoveRow row: Int) {
        // The user has removed an item from the list.
    }

    // MARK: - NCWidgetSearchViewDelegate

    func widgetSearch(searchController: NCWidgetSearchViewController!, searchForTerm searchTerm: String!, maxResults max: Int) {
        // The user has entered a search term. Set the controller's searchResults property to the matching items.
        searchController.searchResults = []
        loadRestApi(searchTerm)
    }

    func widgetSearchTermCleared(searchController: NCWidgetSearchViewController!) {
        // The user has cleared the search field. Remove the search results.
        searchController.searchResults = nil
    }

    func widgetSearch(searchController: NCWidgetSearchViewController!, resultSelected object: AnyObject!) {
        // The user has selected a search result from the list.
        self.listViewController.contents.append(object)
    }
    
    var searchResults2 = [BusStop]()
    
    func loadRestApi(searchTerm: String!){
        let getEndpoint: String = "https://www.metlink.org.nz/api/v1/StopSearch/" + searchTerm.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLPathAllowedCharacterSet())!
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: getEndpoint)!
        print(url.absoluteString)
        let task = session.dataTaskWithURL(url, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
//            let realResponse2 = response as? NSHTTPURLResponse
//            print(realResponse2?.statusCode)
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
                    self.searchResults2.append(bs)
                }
            } catch {
                print("bad things happened")
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                //self.tableView.reloadData()
                //self.searchController!.searchResults.append(self.searchResults2)
                self.searchController!.searchResults = []
                for busStop in self.searchResults2{
                    self.searchController!.searchResults.append(busStop)
                }
                //self.searchController?.searchResults.appendContentsOf(self.searchResults2)
                //print(self.searchResults2)
            })
        })
        
        task.resume()
    }

}
