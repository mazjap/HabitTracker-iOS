//
//  AppDelegate.swift
//  Habit Tracker
//
//  Created by Lambda_School_Loaner_214 on 11/15/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                      options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "Habit_Tracker")
        container.loadPersistentStores(completionHandler: { _ /*storeDescription*/, error in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        let habitID = userInfo["HABBIT_ID"] as? String
        if response.actionIdentifier != "COMPLETE_ACTION" && response.actionIdentifier != "FAIL_ACTION" {
            return
        }
        let frc = fetchHabits()
        
        let arr = frc.fetchedObjects?.filter { $0.id?.uuidString == habitID }
        guard let habit = arr?.first else { return }
        let today = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        if let days = habit.days?.allObjects as? [Day] {
            let arr = days.filter({ Calendar.current.dateComponents([.day, .month, .year], from: $0.date ?? Date(timeIntervalSince1970: 0)) == today })
            if arr.isEmpty {
                performSwitchWithoutDay(with: response, habit: habit)
            } else {
                guard let day = arr.first else {
                    NSLog("Error, day existed but was invalid!")
                    return
                }
                performSwitchWithDay(with: response, habit: habit, day: day)
            }
        }
        
        completionHandler()
    }
    
    func fetchHabits() -> NSFetchedResultsController<Habit> {
        let request: NSFetchRequest<Habit> = Habit.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: CoreDataStack.shared.mainContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self as? NSFetchedResultsControllerDelegate
        do {
            try frc.performFetch()
        } catch {
            fatalError("Unable to fetch object: \(error)")
        }
        
        return frc
    }
    
    func performSwitchWithoutDay(with response: UNNotificationResponse, habit: Habit) {
        switch response.actionIdentifier {
        case "COMPLETE_ACTION":
            HabitController.shared.updateNewDayStatus(habit: habit, status: .yes)
            NSLog("Notification was marked as complete")
        case "FAIL_ACTION":
            HabitController.shared.updateNewDayStatus(habit: habit, status: .no)
            NSLog("Notification was marked as failed")
        default:
            HabitController.shared.updateNewDayStatus(habit: habit, status: .unset)
            NSLog("No response was given from notification")
        }
    }
    
    func performSwitchWithDay(with response: UNNotificationResponse, habit: Habit, day: Day) {
        switch response.actionIdentifier {
        case "COMPLETE_ACTION":
            HabitController.shared.updateDayStatus(day: day, status: .yes)
            NSLog("Notification was marked as complete")
            habit.lastUpdated = day.date ?? habit.lastUpdated
        case "FAIL_ACTION":
            HabitController.shared.updateDayStatus(day: day, status: .no)
            NSLog("Error, day existed but was invalid!")
            habit.lastUpdated = day.date ?? habit.lastUpdated
        default:
            HabitController.shared.updateDayStatus(day: day, status: .unset)
            NSLog("Error, day existed but was invalid!")
            habit.lastUpdated = day.date ?? habit.lastUpdated
        }
    }
}
