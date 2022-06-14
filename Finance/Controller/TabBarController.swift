//
//  TabBarController.swift
//  Finance
//
//  Created by Александр Меренков on 08.06.2022.
//

import UIKit

class TabBarController: UITabBarController {
    
//    MARK: - Lifecycle
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let lessWidth: CGFloat = 20
        let lessHeight: CGFloat = 15
        tabBar.frame.size.width = view.frame.width - lessWidth
        tabBar.frame.size.height = tabBar.frame.size.height - lessHeight
        tabBar.frame.origin.y = tabBar.frame.origin.y - lessHeight / 2
        tabBar.frame.origin.x = lessWidth / 2
        tabBar.layer.cornerRadius = lessWidth
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tabBar.backgroundColor = .tabBarBackgroundColor
        tabBar.tintColor = .totalAccountBackground
        tabBar.barTintColor = .backgroundColor
        
        let homeVC = UINavigationController(rootViewController: HomeController())
        homeVC.tabBarItem.image = UIImage(systemName: "house.fill")
        homeVC.tabBarItem.title = "Домашняя"
        
        let profileVC = UINavigationController(rootViewController: HomeController())
        profileVC.tabBarItem.image = UIImage(systemName: "person.fill")
        profileVC.tabBarItem.title = "Профиль"
        
        viewControllers = [homeVC, profileVC]
    }
}
