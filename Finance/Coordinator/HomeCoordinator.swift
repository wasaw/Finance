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
    private let exchangeAssembly: ExchangeRateAssembly
    
// MARK: - Lifecycle
    
    init(homeAssembly: HomeAssembly,
         exchangeAssembly: ExchangeRateAssembly) {
        self.homeAssembly = homeAssembly
        self.exchangeAssembly = exchangeAssembly
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
        let vc = exchangeAssembly.makeExchangeRateModule()
        navigation?.pushViewController(vc, animated: true)
    }
    
    func showStock() {
        let vc = StocksViewController()
        navigation?.pushViewController(vc, animated: true)
    }
}
