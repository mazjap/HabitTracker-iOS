//
//  HabitController.swift
//  Habit Tracker
//
//  Created by Lambda_School_Loaner_214 on 11/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

enum DayStatus: Int16 {
    case yes = 1
    case no = -1
    case unset = 0
}

class HabitController {
    static let shared = HabitController()
    
    private init() {}
    
    @discardableResult func add(title: String, desc: String, goalDays: Int, notify: Bool, notifyTime: Date) -> Habit {
        let habit = Habit(title: title, desc: desc, goalDays: goalDays, notify: notify, notifyTime: notifyTime)
        CoreDataStack.shared.save()
        addDays(habit: habit)
        
        if notify {
            LocalNotificationManager.shared.scheduleNotification(for: habit)
        }
        return habit
    }
    
    func update(habit: Habit,
                title: String,
                desc: String,
                goalDays: Int,
                notify: Bool,
                notifyTime: Date) {
        habit.title = title
        habit.desc = desc
        habit.goalDays = Int64(goalDays)
        habit.notify = notify
        habit.notifyTime = notifyTime
        CoreDataStack.shared.save()
        
        LocalNotificationManager.shared.deleteNotification(with: habit.id?.uuidString ?? "")
        LocalNotificationManager.shared.scheduleNotification(for: habit)
    }
    
    func updateHabitNotifications(habit: Habit, notify: Bool) {
        let previousHabitNotify = habit.notify
        habit.notify = notify
        CoreDataStack.shared.save()
        if !previousHabitNotify && notify {
            LocalNotificationManager.shared.scheduleNotification(for: habit)
        } else if previousHabitNotify && !notify {
            LocalNotificationManager.shared.deleteNotification(with: habit.id?.uuidString ?? "")
        }
    }
    
    func delete(habit: Habit) {
        CoreDataStack.shared.mainContext.delete(habit)
        CoreDataStack.shared.save()
        LocalNotificationManager.shared.deleteNotification(with: habit.id?.uuidString ?? "")
    }
    
    @discardableResult func addDays (habit: Habit) -> [Day] {
        var days: [Day] = []
        let startDate = habit.startDate ?? Date()
        let currentDate = Date()
        let numDays = Date.daysBetween(date1: startDate, date2: currentDate)
        for lcv in 0...numDays {
            let setDate = startDate.plus(days: UInt(lcv))
            let day = Day(date: setDate)
            habit.addToDays(day)
            days.append(day)
        }
        CoreDataStack.shared.save()
        return days
    }
    
    @discardableResult func addToday(habit: Habit) -> Day {
        let currentDate = Date()
        let day = Day(date: currentDate)
        habit.addToDays(day)
        CoreDataStack.shared.save()
        return day
    }
    
    func updateDayStatus(day: Day, status: DayStatus) {
        day.status = status.rawValue
        CoreDataStack.shared.save()
    }
    
    func updateNewDayStatus(habit: Habit, status: DayStatus) {
        let day = addToday(habit: habit)
        day.status = status.rawValue
        CoreDataStack.shared.save()
    }
    
    func addDay(to habit: Habit, with date: Date) {
        let day = Day(date: date, status: .unset)
        day.habit = habit
    }
    
    func updateHabitDays(habit: Habit) {
        DispatchQueue.main.async {
            guard let lastUpdated = habit.lastUpdated else { return }
            let today = Date()
            let todayCalendar = Calendar.current.dateComponents([.day, .month, .year], from: today)
            let lastUpdatedCalendar = Calendar.current.dateComponents([.day, .month, .year], from: lastUpdated)
            if lastUpdatedCalendar != todayCalendar && today.isGreaterThan(lastUpdated) {
                let count = Calendar.current.dateComponents([.day], from: lastUpdated, to: today).day ?? 0
                for i in 0...count {
                    HabitController.shared.addDay(to: habit, with: today.minus(days: UInt(i)))
                }
            }
            habit.lastUpdated = today
        }
    }
}
