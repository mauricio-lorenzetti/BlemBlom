//
//  ViewController.swift
//  BlemBlom!
//
//  Created by Mauricio Lorenzetti on 26/11/17.
//  Copyright © 2017 Mauricio Lorenzetti. All rights reserved.
//

import UIKit
import SwiftySound

class ViewController: UIViewController {
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    let scheduler:Scheduler = Scheduler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateStatus()
    }
    
    func updateStatus() {
        if UserDefaults.standard.bool(forKey: "status") {
            actionButton.setTitle("Stop", for: .normal)
            statusLabel.text = "Running..."
            Sound.play(file:"tic-toc", fileExtension:"wav", numberOfLoops: -1)
        } else {
            actionButton.setTitle("Start", for: .normal)
            statusLabel.text = "Not running\nTap start to run..."
            Sound.stopAll()
        }
    }
    
    @IBAction func performAction(_ sender: Any) {
        if UserDefaults.standard.bool(forKey: "status") {
            scheduler.removeAllNotifications()
            UserDefaults.standard.set(false, forKey: "status")
        } else {
            _ = Array(0...23).map{
                scheduler.scheduleForHour(hour: $0, half: false)
                scheduler.scheduleForHour(hour: $0, half: true)
            }
            UserDefaults.standard.set(true, forKey: "status")
        }
        updateStatus()
    }

}

