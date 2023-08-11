//
//  ProfileCoordinator.swift
//  Finance
//
//  Created by Александр Меренков on 21.06.2023.
//

import UIKit

final class ProfileCoordinator {
    
// MARK: - Properties
    
    private var profileView: UIViewController?
    private let profileAssembly: ProfileAssembly
    private let authService: AuthServiceProtocol
    private let userService: UserServiceProtocol
    private let authCoordinator: AuthCoordinator
    private var presenterViewController: UIViewController?
    
// MARK: - Lifecycle
    
    init(profileAssembly: ProfileAssembly,
         authService: AuthServiceProtocol,
         userService: UserServiceProtocol,
         authCoordinator: AuthCoordinator) {
        self.profileAssembly = profileAssembly
        self.authService = authService
        self.userService = userService
        self.authCoordinator = authCoordinator
    }
    
// MARK: - Helpers
    
    func start() -> UINavigationController {
        let vc = profileAssembly.makeProfileModule(output: self, authService: authService, userService: userService)
        let nav = UINavigationController(rootViewController: vc)
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
}
