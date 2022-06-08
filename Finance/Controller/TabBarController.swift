//
//  TabBarController.swift
//  Finance
//
//  Created by Александр Меренков on 08.06.2022.
//

import UIKit

class TabBarController: UITabBarController {
    
//    MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.backgroundColor = .white
        
        let homeVC = UINavigationController(rootViewController: HomeController())
        homeVC.tabBarItem.image = UIImage(systemName: "house.fill")
        homeVC.tabBarItem.title = "Домашняя"
        
        let profileVC = UINavigationController(rootViewController: HomeController())
        profileVC.tabBarItem.image = UIImage(systemName: "person.fillgi")
        profileVC.tabBarItem.title = "Профиль"
        
        viewControllers = [homeVC, profileVC]
    }
}
