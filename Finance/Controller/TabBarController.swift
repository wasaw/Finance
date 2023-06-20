//
//  TabBarController.swift
//  Finance
//
//  Created by Александр Меренков on 08.06.2022.
//

import UIKit
import Firebase

final class TabBarController: UITabBarController {
    
// MARK: - Properties
    
    private var currentUser = CurrentUser()
    private let homeCoordinator = HomeCoordinator()
        
// MARK: - Lifecycle
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let boundWidth: CGFloat = 20
        tabBar.frame.size.width = view.frame.width - boundWidth
        tabBar.frame.size.height *= 0.9
        tabBar.frame.origin.y -= 10
        tabBar.frame.origin.x = boundWidth / 2
        tabBar.layer.cornerRadius = boundWidth
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        tabBar.backgroundColor = .tabBarBackgroundColor
        tabBar.tintColor = .selectViewBackground
        tabBar.barTintColor = .white
        
        let homeVC = homeCoordinator.start()
        homeVC.tabBarItem.image = UIImage(systemName: "house.fill")
        homeVC.tabBarItem.title = "Домашняя"
        
        let addVC = AddTransactionViewController()
        let named = (view.frame.height < 700) ? "plus-2.png" : "plus-1.png"
        addVC.tabBarItem.image = UIImage(named: named)?.withRenderingMode(.alwaysOriginal)
        let top: CGFloat = (view.frame.height < 700) ? 10 : 25
        addVC.tabBarItem.imageInsets = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)

        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        profileVC.tabBarItem.image = UIImage(systemName: "person.fill")
        profileVC.tabBarItem.title = "Профиль"
        
        authUser()
        
        viewControllers = [homeVC, addVC, profileVC]
    }
    
// MARK: - Helpers
    
    private func authUser() {
        let uid = Auth.auth().currentUser?.uid
        guard let uid = uid else { return }
        DatabaseService.shared.getUserInformation(uid: uid) { result in
            switch result {
            case .success(let user):
                self.currentUser.setValue(user: user)
            case .failure(let error):
                self.alert(with: "Ошибка", massage: error.localizedDescription)
            }
        }
    }
}

// MARK: - Extensions

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let isAddVC = viewController is AddTransactionViewController

        if isAddVC {
            let addVC = AddTransactionViewController()
            if let sheet = addVC.sheetPresentationController {
                sheet.detents = [.large()]
            }
            self.present(addVC, animated: true)
            return false
        }
        return true
    }
}
