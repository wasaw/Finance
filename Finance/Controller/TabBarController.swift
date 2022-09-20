//
//  TabBarController.swift
//  Finance
//
//  Created by Александр Меренков on 08.06.2022.
//

import UIKit
import Firebase

class TabBarController: UITabBarController {
    
//    MARK: - Properties
    
    private var currentUser = CurrentUser()
    
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
                        
        self.delegate = self
        tabBar.backgroundColor = .tabBarBackgroundColor
        tabBar.tintColor = .totalAccountBackground
        tabBar.barTintColor = .white
        
        let homeVC = UINavigationController(rootViewController: HomeController(currentUser))
        homeVC.tabBarItem.image = UIImage(systemName: "house.fill")
        homeVC.tabBarItem.title = "Домашняя"
        
        let addVC = AddTransactionController()
        let named = (view.frame.height < 700) ? "plus-2.png" : "plus-1.png"
        addVC.tabBarItem.image = UIImage(named: named)?.withRenderingMode(.alwaysOriginal)
        let top: CGFloat = (view.frame.height < 700) ? 10 : 20
        addVC.tabBarItem.imageInsets = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)

        let profileVC = UINavigationController(rootViewController: ProfileController(currentUser))
        profileVC.tabBarItem.image = UIImage(systemName: "person.fill")
        profileVC.tabBarItem.title = "Профиль"

        authUser()

        viewControllers = [homeVC, addVC, profileVC]
    }
    
//    MARK: - Helpers
    
    private func authUser() {
        let uid = Auth.auth().currentUser?.uid
        if uid != nil {
            let user = DatabaseService.shared.getUserInformation(uid: uid!)
            self.currentUser.setValue(user: user)
        }
    }
}

//  MARK: - Extensions

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let isAddVC = viewController is AddTransactionController

        if isAddVC {
            let addVC = AddTransactionController()
            if let sheet = addVC.sheetPresentationController {
                sheet.detents = [.large()]
            }
            self.present(addVC, animated: true)
            return false
        }
        return true
    }
}
