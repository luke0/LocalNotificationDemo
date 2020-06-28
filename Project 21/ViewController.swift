//
//  ViewController.swift
//  Project 21
//
//  Created by Luke Inger on 25/06/2020.
//  Copyright © 2020 Luke Inger. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }

    @objc func registerLocal(){
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {
            granted, error in
            
            if granted {
                print("Yay!!")
            } else {
                print("Boo!!")
            }
        })
        
    }
    
    @objc func scheduleLocal(){
        
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Late Wakeup Call"
        content.body = "Early bird catches the worm"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "123"]
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        
        //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }

    func registerCategories(){
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more", options: .foreground)
        let later = UNNotificationAction(identifier: "later", title: "Remind me later", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, later], intentIdentifiers: [], options: [])
        
        center.setNotificationCategories([category])
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Customer data received \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // the user swiped to unlock
                print("default")
            case "show":
                print("show more info")
            case "later":
                print("remind me later")
            default:
                break
            }
        }
        
        completionHandler()
        
    }
}

