//
//  HabitsTableViewController.swift
//  Habit Tracker
//
//  Created by Lambda_School_Loaner_214 on 11/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class HabitsTableViewController: UITableViewController {
    
    @IBOutlet private weak var settingsButton: UIBarButtonItem!
    
    // MARK: - Properties
    private lazy var frc: NSFetchedResultsController<Habit>! = {
        let fetchRequest: NSFetchRequest<Habit> = Habit.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: CoreDataStack.shared.mainContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        do { try frc.performFetch() } catch { fatalError("NSFetchedResultsController failed: \(error)") }
        print("HabitsTableViewController: Habits fetched: \(String(describing: frc.fetchedObjects?.count))")
        return frc
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.accessibilityIdentifier = "MyHabitsTableView"
        UNUserNotificationCenter.current().delegate = self
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        self.tableView.rowHeight = 80.0
        refresh()
    }
    
    override internal func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        updateColors()
        refresh()
    }

    // MARK: - Table view data source
    override internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frc.sections?[section].numberOfObjects ?? 0
    }

    override internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HabitCell", for: indexPath) as? HabitTableViewCell else { return UITableViewCell() }
        cell.clipsToBounds = true
        cell.accessibilityIdentifier = "HabitCell\(indexPath.row)"
        let habit = frc.object(at: indexPath)
        cell.habit = habit
        return cell
    }

    override internal func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            HabitController.shared.delete(habit: self.frc.object(at: indexPath))
            refresh()
        }
    }
    
    override internal func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? HabitTableViewCell else { return }
        cell.layer.cornerRadius = 13
    }
    
    private func updateHabitDays(habit: Habit) {
        let bcx = CoreDataStack.shared.container.newBackgroundContext()
        bcx.perform {
            HabitController.shared.updateHabitDays(habit: habit)
        }
    }
    
    private func updateViews() {
        updateColors()
    }
    
    private func updateColors() {
        view.backgroundColor = .backgroundColor
        
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.htTextColor]
        navigationController?.navigationBar.largeTitleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.htTextColor]
        navigationController?.navigationBar.tintColor = UIColor.htTextColor
        
        tableView.separatorColor = .clear
        
        updateSettingsButton()
    }
    
    @objc
    private func refresh() {
        tableView.reloadData()
        guard let habits = frc.fetchedObjects else { return }
        var dev = false
        for habit in habits {
            updateHabitDays(habit: habit)
            if habit.title?.lowercased() == "dev" && habit.desc?.lowercased() == "settings" {
                dev = true
            }
        }
        devSettings = dev
        UserDefaults.standard.set(devSettings, forKey: "devSettings")
//
        updateSettingsButton()
        refreshControl?.endRefreshing()
    }
    
    private func updateSettingsButton() {
        if devSettings {
            settingsButton.isEnabled = true
            settingsButton.tintColor = .htTextColor
        } else {
            settingsButton.isEnabled = false
            settingsButton.tintColor = .clear
        }
    }

    // MARK: - Navigation
    override internal func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShowHabitDetailSegue":
            guard let indexPath = tableView.indexPathForSelectedRow,
                let vc = segue.destination as? HabitDetailViewController else { return }
            let habit = frc.object(at: indexPath)
            vc.habit = habit
        case "AddHabitDetailSegue":
            break
        default:
            break
        }
    }
    
    override internal func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateColors()
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension HabitsTableViewController: NSFetchedResultsControllerDelegate {
    
    internal func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    internal func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    internal func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    internal func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError("Unknown Change Type occured")
        }
    }
}

extension HabitsTableViewController: UNUserNotificationCenterDelegate {
    internal func userNotificationCenter(_ center: UNUserNotificationCenter,
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
    
    private func fetchHabits() -> NSFetchedResultsController<Habit> {
        let request: NSFetchRequest<Habit> = Habit.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: CoreDataStack.shared.mainContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            fatalError("Unable to fetch object: \(error)")
        }
        
        return frc
    }
    
    private func performSwitchWithoutDay(with response: UNNotificationResponse, habit: Habit) {
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
    
    private func performSwitchWithDay(with response: UNNotificationResponse, habit: Habit, day: Day) {
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
