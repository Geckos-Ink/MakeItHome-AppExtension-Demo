//
//  ViewController.swift
//  MiH-AppExtension-Demo
//
//  Created by Riccardo Cecchini on 31/05/24.
//

import Cocoa

class ViewController: NSViewController {

    let client : AppExtensionHTTPClient = AppExtensionHTTPClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func buttonConnectClick(_ sender: Any) {
        client.connect(bundleId: "ink.geckos.makeithome.MiH-AppExtension-Demo")
    }



}

