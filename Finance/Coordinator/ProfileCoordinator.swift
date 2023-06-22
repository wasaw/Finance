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
    
// MARK: - Lifecycle
    
    init(profileAssembly: ProfileAssembly) {
        self.profileAssembly = profileAssembly
    }
    
// MARK: - Helpers
    
    func start() -> UINavigationController {
        let vc = profileAssembly.makeProfileModule(profileCoordinator: self)
        let nav = UINavigationController(rootViewController: vc)
        profileView = vc
        return nav
    }
}

// MARK: - ProfileOutput

extension ProfileCoordinator: ProfilePresenterOutput {
    
}
