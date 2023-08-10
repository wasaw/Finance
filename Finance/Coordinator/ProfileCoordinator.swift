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
    
// MARK: - Lifecycle
    
    init(profileAssembly: ProfileAssembly,
         authService: AuthServiceProtocol,
         userService: UserServiceProtocol) {
        self.profileAssembly = profileAssembly
        self.authService = authService
        self.userService = userService
    }
    
// MARK: - Helpers
    
    func start() -> UINavigationController {
        let vc = profileAssembly.makeProfileModule(authService: authService, userService: userService)
        let nav = UINavigationController(rootViewController: vc)
        profileView = vc
        return nav
    }
}
