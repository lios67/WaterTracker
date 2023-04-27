//
//  SettingsViewController.swift
//  WaterTracker
//
//  Created by Oscar lin on 4/22/23.
//

import UIKit
import CoreData
import UserNotifications


class SettingsViewController: UIViewController {
    var notificationGranted = false
    @IBAction func addNotification(_ sender: UIButton) {
        if notificationGranted{
            repeatNotification()
        }else{
            print("notification not granted")
        }
    }
    @IBAction func notificationStatus(_ sender: UIButton) {
        var displayString = "Current Pending Notifications "
        UNUserNotificationCenter.current().getPendingNotificationRequests {
            (requests) in
            displayString += "count:\(requests.count)\t"
            for request in requests{
                displayString += request.identifier + "\t"
            }
            print(displayString)
        }
    }
    @IBAction func stopNotification(_ sender: UIButton) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["water.reminder"])
    }
    
    func repeatNotification(){
        let center=UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title="Water Break!!!"
        content.body="STOP and Take a Break to Drink 2-3 cups of Water"
        content.categoryIdentifier = "water.reminder.category"
        //Fire in one hour (60*60) 1 min: 60
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (60*60), repeats: true)
        let request = UNNotificationRequest(identifier: "water.reminder", content: content, trigger: trigger)
        center.add(request) { (error) in
            if let error = error {
                print("error in water reminder: \(error.localizedDescription)")
            }else{
                print("added notification:\(request.identifier)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        // Do any additional setup after loading the view.
        let center=UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert,.sound]){
            (granted, error) in
            self.notificationGranted = granted
            if let error = error {
                print("granted, but Error in notification permission:\(error.localizedDescription)")
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
