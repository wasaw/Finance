//
//  AuthCoordinator.swift
//  Finance
//
//  Created by Александр Меренков on 22.06.2023.
//

import UIKit

final class AuthCoordinator {
    
// MARK: - Properties
    
    private let authAssembly: AuthAssembly
    private let authService: AuthServiceProtocol
    private let coreData = CoreDataService()
    
// MARK: - Lifecycle
    
    init(authAssembly: AuthAssembly, authService: AuthServiceProtocol) {
        self.authAssembly = authAssembly
        self.authService = authService
    }
    
// MARK: - Helpers
    
    func start() -> UIViewController {
        let vc = authAssembly.makeAuthModul(authService: authService)
        return vc
    }
}
