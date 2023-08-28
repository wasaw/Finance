//
//  TabBarController.swift
//  Finance
//
//  Created by Александр Меренков on 08.06.2022.
//

import UIKit

final class TabBarController: UITabBarController {
    
// MARK: - Properties
    
    private let homeCoordinator: HomeCoordinator
    private let addAssembly: AddTransactionAssembly
    private let profileCoordinator: ProfileCoordinator
    private let coreData: CoreDataServiceProtocol
    private let transactionsService: TransactionsServiceProtocol
    private let defaultValueService: DefaultValueServiceProtocol
        
// MARK: - Lifecycle
    
    init(homeCoordinator: HomeCoordinator,
         addAssembly: AddTransactionAssembly,
         profileCoordinator: ProfileCoordinator,
         coreData: CoreDataServiceProtocol,
         transactionsService: TransactionsServiceProtocol,
         defaultValueService: DefaultValueServiceProtocol) {
        
        self.homeCoordinator = homeCoordinator
        self.addAssembly = addAssembly
        self.profileCoordinator = profileCoordinator
        self.coreData = coreData
        self.transactionsService = transactionsService
        self.defaultValueService = defaultValueService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        let addVC = addAssembly.makeAddTransactionModul(transactionsService: transactionsService, defaultValueService: defaultValueService)
        let named = (view.frame.height < 700) ? "plus-2.png" : "plus-1.png"
        addVC.tabBarItem.image = UIImage(named: named)?.withRenderingMode(.alwaysOriginal)
        let top: CGFloat = (view.frame.height < 700) ? 10 : 25
        addVC.tabBarItem.imageInsets = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)

        let profileVC = profileCoordinator.start()
        profileVC.tabBarItem.image = UIImage(systemName: "person.fill")
        profileVC.tabBarItem.title = "Профиль"
                
        viewControllers = [homeVC, addVC, profileVC]
    }
}

// MARK: - Extensions

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let isAddVC = viewController is AddTransactionViewController

        if isAddVC {
            let addVC = addAssembly.makeAddTransactionModul(transactionsService: transactionsService, defaultValueService: defaultValueService)
            if let sheet = addVC.sheetPresentationController {
                sheet.detents = [.large()]
            }
            self.present(addVC, animated: true)
            return false
        }
        return true
    }
}
