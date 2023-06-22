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
    private let profileAssembly: ProfileAssembly
    
// MARK: - Lifecycle
    
    init(profileAssembly: ProfileAssembly) {
        self.profileAssembly = profileAssembly
    }
    
// MARK: - Helpers
    
    func start() -> UINavigationController {
        let vc = profileAssembly.makeProfileModule()
        let nav = UINavigationController(rootViewController: vc)
        navigation = nav
        return nav
    }
}
