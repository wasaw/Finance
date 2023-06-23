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
    private let stocksAssembly: StocksAssembly
    private let network: NetworkProtocol
    private let config: NetworkConfiguration
    
// MARK: - Lifecycle
    
    init(homeAssembly: HomeAssembly,
         exchangeAssembly: ExchangeRateAssembly,
         stocksAssembly: StocksAssembly,
         network: NetworkProtocol,
         config: NetworkConfiguration) {
        self.homeAssembly = homeAssembly
        self.exchangeAssembly = exchangeAssembly
        self.stocksAssembly = stocksAssembly
        self.network = network
        self.config = config
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
        let vc = exchangeAssembly.makeExchangeRateModule(network: network, config: config)
        navigation?.pushViewController(vc, animated: true)
    }
    
    func showStock() {
        let vc = stocksAssembly.makeStocksModule(network: network, config: config)
        navigation?.pushViewController(vc, animated: true)
    }
}
