//
//  ListRowViewController.swift
//  table extension 2
//
//  Created by Thomas Horrobin on 22/05/16.
//  Copyright © 2016 Wellington City Council Extension Apps. All rights reserved.
//

import Cocoa

class ListRowViewController: NSViewController {

    override var nibName: String? {
        return "ListRowViewController"
    }

    @IBAction func btnAction(sender: AnyObject) {
        btnOutlet.title = "hi tom heh"
    }
    @IBOutlet weak var btnOutlet: NSButton!
    
    override func loadView() {
        super.loadView()
        //let bs = BusStop()
        // Insert code here to customize the view
    }

}

