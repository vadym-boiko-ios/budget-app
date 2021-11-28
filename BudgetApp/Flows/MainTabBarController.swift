//
//  MainTabBarController.swift
//  BudgetApp
//
//  Created by Vadym Boiko on 24.11.2021.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private let firstItem = UINavigationController(rootViewController: ControlPanelViewController())
    private let secondItem =  UINavigationController(rootViewController: ExpenseStatisticsViewController())

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarItems()
        setupTabBar()
    }
        
    private func setupTabBar() {
        let controllers = [firstItem, secondItem]
        self.viewControllers = controllers
    }
    
    private func setupTabBarItems() {
        firstItem.tabBarItem = UITabBarItem(title: .none,
                                            image: UIImage(systemName: "text.justify"),
                                            selectedImage: UIImage(systemName: "text.justify"))
        secondItem.tabBarItem = UITabBarItem(title: .none,
                                             image: UIImage(systemName: "creditcard"),
                                             selectedImage: UIImage(systemName: "creditcard"))
    }
}
