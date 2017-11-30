//
//  Scheduler.swift
//  Whiterose-Remainder
//
//  Created by Mauricio Lorenzetti on 25/11/17.
//  Copyright © 2017 Mauricio Lorenzetti. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class Scheduler {
    
    let nc:UNUserNotificationCenter
    //#BUG: notification custom sound lasts only while the alert banner lasts on screen
    //let options:UNAuthorizationOptions = [.sound, .alert]
    let options:UNAuthorizationOptions = [.sound]
    
    init(){
        nc = UNUserNotificationCenter.current()
        nc.requestAuthorization(options: options) { (granted, error) in
            if let e = error {
                print(e.localizedDescription)
            }
        }
    }
    
    func scheduleForHour(hour: Int, half: Bool){
        
        let content = UNMutableNotificationContent()
        let hourAMPM = ((hour+11) % 12) + 1 //0 and 12 hours have 12 bells
        
        content.sound = UNNotificationSound(named: half ? "bell1.aiff" : "bell\(hourAMPM).aiff")
        
        if options.contains(.alert) {
            content.title = "Hey! Listen!"
            content.body = half ? "It's \(hour) and a half o'clock" : "It's \(hour) o'clock"
        }
        
        var date = DateComponents()
        date.hour = hour
        date.minute = half ? 30 : 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        
        let request = UNNotificationRequest(identifier: "\(hour):\(half)", content: content, trigger: trigger)
        
        nc.add(request, withCompletionHandler: { (error: Error?) in
            if let e = error {
                print(e.localizedDescription)
            } else {
                UserDefaults.standard.set(true, forKey: "status")
            }
        })
    }
    
    func removeAllNotifications() {
        nc.removeAllPendingNotificationRequests()
    }
    
}
