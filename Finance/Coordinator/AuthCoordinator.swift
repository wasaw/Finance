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
    private var authViewController: UIViewController?
    
// MARK: - Lifecycle
    
    init(authAssembly: AuthAssembly, authService: AuthServiceProtocol) {
        self.authAssembly = authAssembly
        self.authService = authService
    }
    
// MARK: - Helpers
    
    func start() -> UIViewController {
        let vc = authAssembly.makeAuthModul(output: self, authService: authService)
        authViewController = vc
        return vc
    }
}

// MARK: - AuthPresenterOutput

extension AuthCoordinator: AuthPresenterOutput {
    func dismissView() {
        authViewController?.willMove(toParent: nil)
        authViewController?.removeFromParent()
        authViewController?.view.removeFromSuperview()
    }
}
