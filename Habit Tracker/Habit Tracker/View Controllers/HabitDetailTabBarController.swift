//
//  HabitDetailTabBarController.swift
//  Habit Tracker
//
//  Created by Lambda_School_Loaner_214 on 11/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class HabitDetailTabBarController: UITabBarController {
    
    // MARK: - Properties
    var habit: Habit?
    
    // MARK: - IBOutlets
    @IBOutlet private weak var myTabBar: UITabBar!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let vcs = self.viewControllers {
            for vc in vcs {
                print(vc)
                if var vci = vc as? HabitHandlerProtocol {
                    vci.habit = self.habit
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
// MARK: - Extensions
}
extension HabitDetailTabBarController: UITabBarControllerDelegate {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
    }
}
