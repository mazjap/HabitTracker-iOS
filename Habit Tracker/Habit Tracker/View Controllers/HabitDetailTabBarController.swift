//
//  HabitDetailTabBarController.swift
//  Habit Tracker
//
//  Created by Lambda_School_Loaner_214 on 11/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class HabitDetailTabBarController: UITabBarController {
    
    //MARK: - Properties
    var habit: Habit?
    
    //MARK: - IBOutlets
    @IBOutlet weak var myTabBar: UITabBar!
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let vcs = self.viewControllers {
            for vc in vcs {
                print (vc)
                if var vci = vc as? HabitHandlerProtocol {
                    vci.habit = self.habit
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    //MARK: - Extensions
}
extension HabitDetailTabBarController: UITabBarControllerDelegate {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
    }
}
