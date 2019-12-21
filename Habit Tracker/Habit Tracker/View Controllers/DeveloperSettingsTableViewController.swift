//
//  DeveloperSettingsTableViewController.swift
//  Habit Tracker
//
//  Created by Jordan Christensen on 11/27/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class DeveloperSettingsTableViewController: UITableViewController {
    
    @IBOutlet private weak var notificationsSwitch: UISwitch!
    @IBOutlet private weak var testDataSwitch: UISwitch!
    @IBOutlet private weak var uselessSwitch: UISwitch!
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        notificationsSwitch.isOn = devNotifications
        testDataSwitch.isOn = testData
    }
    
    @IBAction private func notificationsToggled(_ sender: UISwitch) {
        devNotifications = sender.isOn
        userDefaults.set(sender.isOn, forKey: "devNotifications")
    }
    
    @IBAction private func testDataToggled(_ sender: UISwitch) {
        testData = sender.isOn
        userDefaults.set(sender.isOn, forKey: "testData")
    }
    
    @IBAction private func uselessToggled(_ sender: UISwitch) {
        
    }
    
    @IBAction private func deleteNotifications(_ sender: UIButton) {
        LocalNotificationManager.shared.deleteAllNotifications()
        
        let alert = UIAlertController(title: "Notifications Deleted",
                                      message: "Turn notifications off then on for each habit if you would like to continue receiving notifications",
                                      preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
}
