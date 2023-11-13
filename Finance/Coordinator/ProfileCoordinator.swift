//
//  ProfileCoordinator.swift
//  Finance
//
//  Created by Александр Меренков on 21.06.2023.
//

import UIKit

final class ProfileCoordinator {
    
// MARK: - Properties
    
    private var navigation: UINavigationController?
    private var profileView: UIViewController?
    private let profileAssembly: ProfileAssembly
    private let progressAssembly: ProgressAssembly
    private let authService: AuthServiceProtocol
    private let userService: UserServiceProtocol
    private let authCoordinator: AuthCoordinator
    private let exchangeRateService: ExchangeRateServiceProtocol
    private let transactionsService: TransactionsServiceProtocol
    private var presenterViewController: UIViewController?
    
// MARK: - Lifecycle
    
    init(profileAssembly: ProfileAssembly,
         progressAssembly: ProgressAssembly,
         authService: AuthServiceProtocol,
         userService: UserServiceProtocol,
         authCoordinator: AuthCoordinator,
         exchageRateService: ExchangeRateServiceProtocol,
         transactionsService: TransactionsServiceProtocol) {
        self.profileAssembly = profileAssembly
        self.progressAssembly = progressAssembly
        self.authService = authService
        self.userService = userService
        self.authCoordinator = authCoordinator
        self.exchangeRateService = exchageRateService
        self.transactionsService = transactionsService
    }
    
// MARK: - Helpers
    
    func start() -> UINavigationController {
        let vc = profileAssembly.makeProfileModule(output: self,
                                                   authService: authService,
                                                   userService: userService,
                                                   exchageRateService: exchangeRateService,
                                                   transactionsService: transactionsService)
        let nav = UINavigationController(rootViewController: vc)
        navigation = nav
        presenterViewController = vc
        profileView = vc
        return nav
    }
}

// MARK: - ProfilePresenterOutput

extension ProfileCoordinator: ProfilePresenterOutput {
    func showAuth() {
        let authViewController = authCoordinator.start()
        presenterViewController?.view.addSubview(authViewController.view)
        presenterViewController?.addChild(authViewController)
        authViewController.didMove(toParent: presenterViewController)
    }
    
    func showProgressMenu() {
        let vc = progressAssembly.makeProgressModule(output: self)
        navigation?.pushViewController(vc, animated: true)
    }
}
