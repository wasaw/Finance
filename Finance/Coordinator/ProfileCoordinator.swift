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
    private let coreData: CoreDataServiceProtocol
    private let authService: AuthServiceProtocol
    
// MARK: - Lifecycle
    
    init(profileAssembly: ProfileAssembly,
         coreData: CoreDataServiceProtocol,
         authService: AuthServiceProtocol) {
        self.profileAssembly = profileAssembly
        self.coreData = coreData
        self.authService = authService
    }
    
// MARK: - Helpers
    
    func start() -> UINavigationController {
        let vc = profileAssembly.makeProfileModule(coreData: coreData,
                                                   authService: authService)
        let nav = UINavigationController(rootViewController: vc)
        profileView = vc
        return nav
    }
}
