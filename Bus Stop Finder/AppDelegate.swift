//
//  AppDelegate.swift
//  Bus Stop Finder
//
//  Created by Thomas Horrobin on 1/05/16.
//  Copyright © 2016 Wellington City Council Extension Apps. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var windowList = [TestWindowController]()

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    
    func openMyWindow(sms: String)
    {
        let storyboard = NSStoryboard(name: "Main",bundle: nil)
//        print("got here 1")
        
        if true
        {
            if let vc = storyboard.instantiateControllerWithIdentifier("firstWindowController") as? DepartureVeiwController
            {
//                print("got here 2")
                let myWindow = NSWindow(contentViewController: vc)
                vc.loadRestApi(sms)
                myWindow.title = "Stop: " + sms
                myWindow.makeKeyAndOrderFront(self)
                let controller = TestWindowController(window: myWindow)
                windowList.append(controller)
//                print("got here 3")
                controller.showWindow(self)
                
            }
        }
    }

}

