//
//  LocalNotificationManager.swift
//  Habit Tracker
//
//  Created by Jordan Christensen on 11/20/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import UserNotifications

class LocalNotificationManager {
    public static let shared = LocalNotificationManager()
    
    var notifications = [Notification]()

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
//        let datetime = DateComponents(calendar: nil, timeZone: TimeZone(abbreviation: ""), era: <#T##Int?#>, year: <#T##Int?#>, month: <#T##Int?#>, day: <#T##Int?#>, hour: <#T##Int?#>, minute: <#T##Int?#>, second: <#T##Int?#>, nanosecond: <#T##Int?#>, weekday: <#T##Int?#>, weekdayOrdinal: <#T##Int?#>, quarter: <#T##Int?#>, weekOfMonth: <#T##Int?#>, weekOfYear: <#T##Int?#>, yearForWeekOfYear: <#T##Int?#>)
        
//        guard let id = habit.id, let title = habit.title else { return }
//        notifications.append(Notification(id: id.uuidString, title: "Have you completed your \(title) habit today?", subtitle: nil, datetime: datetime))
        schedule()
    }
    
    func deleteNotificiation(with id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
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
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.sound = .defaultCritical

            let trigger = UNCalendarNotificationTrigger(dateMatching: notification.datetime, repeats: true)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    NSLog("Error adding notification: \(error)")
                    return
                } else {
                    print("Notification scheduled. ID: \(notification.id)")
                }
            }
        }
    }

    private init() {}
}

struct Notification {
    var id: String
    var title: String
    var subtitle: String?
    var datetime: DateComponents
}
