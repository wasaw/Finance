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
        let lessWidth: CGFloat = (view.frame.height < 700) ? 15 : 20
        let lessHeight: CGFloat = (view.frame.height < 700) ? 5 : 15
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
        tabBar.barTintColor = .white
        
        let homeVC = UINavigationController(rootViewController: HomeController())
        homeVC.tabBarItem.image = UIImage(systemName: "house.fill")
        homeVC.tabBarItem.title = "Домашняя"
        
        let addVC = UINavigationController(rootViewController: AddTransactionController())
        addVC.tabBarItem.image = UIImage(named: "plus-1.png")?.withRenderingMode(.alwaysOriginal)
        let top: CGFloat = (view.frame.height < 700) ? 10 : 20
        addVC.tabBarItem.imageInsets = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
        
        let profileVC = UINavigationController(rootViewController: LogInController())
        profileVC.tabBarItem.image = UIImage(systemName: "person.fill")
        profileVC.tabBarItem.title = "Профиль"
        
        viewControllers = [homeVC, addVC, profileVC]
    }
}
