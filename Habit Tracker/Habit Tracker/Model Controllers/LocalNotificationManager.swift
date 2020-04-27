//
//  LocalNotificationManager.swift
//  Habit Tracker
//
//  Created by Jordan Christensen on 11/20/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import UserNotifications
import CoreData

class LocalNotificationManager {
    public static let shared = LocalNotificationManager()
    
    var notifications = [Notification]()
    let reuseId = "HABIT_ACTION"
    
    func listScheduledNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            for notification in notifications {
                print(notification)
            }
        }
    }
    
    func schedule() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization()
            case .authorized, .provisional:
                self.scheduleNotifications()
            default:
                break
            }
        }
    }
    
    func scheduleNotification(for habit: Habit) {
        guard let id = habit.id, let title = habit.title, let notifyTime = habit.notifyTime else { return }
        let datetime = Calendar.current.dateComponents([.hour, .minute, .second], from: notifyTime)
        notifications.append(Notification(id: id.uuidString, title: "Habit Reminder", body: "Have you completed your \(title) habit today?", subtitle: nil, datetime: datetime))
        schedule()
    }
    
    func deleteNotification(with habit: Habit) {
        guard let id = habit.id?.uuidString else { return }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [id])
        
        for (i, notification) in notifications.enumerated() where notification.id == id {
            notifications.remove(at: i)
        }
    }
    
    func deleteAllNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            for notification in notifications {
                let id = notification.identifier
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
                UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [id])
            }
        }
        
        notifications = [Notification]()
    }
    
    private func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { didAllow, error in
            if let error = error {
                NSLog("Error: \(error)")
            } else if !didAllow {
                NSLog("User notifications are not enabled. Please enable in settings")
            } else {
                self.scheduleNotifications()
            }
        }
    }
    
    private func scheduleNotifications() {
        for notification in notifications {
            let notificationCenter = UNUserNotificationCenter.current()
            let completeAction = UNNotificationAction(identifier: "COMPLETE_ACTION",
                                                      title: "Yes",
                                                      options: [.foreground])
            let failAction = UNNotificationAction(identifier: "FAIL_ACTION",
                                                  title: "No",
                                                  options: [.foreground])
            let habitCategory = UNNotificationCategory(identifier: reuseId,
                                                       actions: [completeAction, failAction],
                                                       intentIdentifiers: [],
                                                       hiddenPreviewsBodyPlaceholder: "",
                                                       options: .customDismissAction)
            
            notificationCenter.setNotificationCategories([habitCategory])
            
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.subtitle = notification.subtitle ?? ""
            content.body = notification.body
            content.sound = .defaultCritical
            content.categoryIdentifier = reuseId
            content.userInfo = ["HABBIT_ID": notification.id]
            
            let request: UNNotificationRequest
            if devNotifications {
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 20, repeats: false)
                request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            } else {
                let trigger = UNCalendarNotificationTrigger(dateMatching: notification.datetime, repeats: true)
                request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            }
            
            notificationCenter.add(request) { error in
                if let error = error {
                    NSLog("Error adding notification: \(error)")
                    return
                } else {
                    NSLog("Notification scheduled. ID: \(notification.id)")
                }
            }
        }
    }
    
    private init() {}
}

struct Notification {
    var id: String
    var title: String
    var body: String
    var subtitle: String?
    var datetime: DateComponents
}
