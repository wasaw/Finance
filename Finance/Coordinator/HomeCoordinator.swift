//
//  HomeCoordinator.swift
//  Finance
//
//  Created by Александр Меренков on 20.06.2023.
//

import UIKit

final class HomeCoordinator {
    
// MARK: - Properties
    
    private var navigation: UINavigationController?
    private let homeAssembly: HomeAssembly
    
// MARK: - Lifecycle
    
    init(homeAssembly: HomeAssembly) {
        self.homeAssembly = homeAssembly
    }
    
// MARK: - Helpers
    
    func start() -> UINavigationController {
        let homeVC = homeAssembly.makeHomeModule(homeCoordinator: self)
        let nav = UINavigationController(rootViewController: homeVC)
        navigation = nav
        return nav
    }
}

// MARK: - HomePresenterOutput

extension HomeCoordinator: HomePresenterOutput {
    func showExchangeRate() {
        let vc = ExchangeRateViewController()
        navigation?.pushViewController(vc, animated: true)
    }
    
    func showStock() {
        let vc = StocksViewController()
        navigation?.pushViewController(vc, animated: true)
    }
}
