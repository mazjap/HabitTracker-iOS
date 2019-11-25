//
//  HabitsTableViewController.swift
//  Habit Tracker
//
//  Created by Lambda_School_Loaner_214 on 11/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import CoreData

class HabitsTableViewController: UITableViewController {

    // MARK: - Properties
    lazy var frc: NSFetchedResultsController<Habit>! = {
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
        guard let habits = frc.fetchedObjects else { return }
        for habit in habits {
            updateHabitDays(habit: habit)
        }
        self.tableView.rowHeight = 80.0
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        updateColors()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frc.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HabitCell", for: indexPath) as? HabitTableViewCell else { return UITableViewCell() }
        cell.clipsToBounds = true
        cell.accessibilityIdentifier = "HabitCell\(indexPath.row)"
        let habit = frc.object(at: indexPath)
        cell.habit = habit
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        guard let cell = tableView.cellForRow(at: indexPath) as? HabitTableViewCell else { return }
//        cell.layer.cornerRadius = 13
//        if editingStyle == .delete {
//            HabitController.shared.delete(habit: frc.object(at: indexPath))
//        }
//    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { _, view, _ in
            print("button pressed!")
            HabitController.shared.delete(habit: self.frc.object(at: indexPath))
            UIGraphicsBeginImageContext(view.frame.size)
            UIGraphicsEndImageContext()
        }
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    override func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? HabitTableViewCell else { return }
        cell.layer.cornerRadius = 13
    }
    
    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        tableView.reloadRows(at: [indexPath], with: .automatic)
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
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShowHabitDetailSegue":
            guard   let indexPath = tableView.indexPathForSelectedRow,
                    let vc = segue.destination as? HabitDetailViewController else { return }
            let habit = frc.object(at: indexPath)
            vc.habit = habit
        case "AddHabitDetailSegue":
            break
        default:
            break
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateColors()
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension HabitsTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
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
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
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
