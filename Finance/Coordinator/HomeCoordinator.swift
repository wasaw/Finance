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
    private let coreData: CoreDataServiceProtocol
    private let transactionsService: TransactionsServiceProtocol
    private let userService: UserServiceProtocol
    private let stocksService: StocksServiceProtocol
    private let exchangeRateService: ExchangeRateServiceProtocol
    
// MARK: - Lifecycle
    
    init(homeAssembly: HomeAssembly,
         exchangeAssembly: ExchangeRateAssembly,
         stocksAssembly: StocksAssembly,
         network: NetworkProtocol,
         config: NetworkConfiguration,
         coreData: CoreDataServiceProtocol,
         transactionsService: TransactionsServiceProtocol,
         userService: UserServiceProtocol,
         stocksService: StocksServiceProtocol,
         exchangeRateService: ExchangeRateServiceProtocol) {
        self.homeAssembly = homeAssembly
        self.exchangeAssembly = exchangeAssembly
        self.stocksAssembly = stocksAssembly
        self.network = network
        self.config = config
        self.coreData = coreData
        self.transactionsService = transactionsService
        self.userService = userService
        self.stocksService = stocksService
        self.exchangeRateService = exchangeRateService
    }
    
// MARK: - Helpers
    
    func start() -> UINavigationController {
        let homeVC = homeAssembly.makeHomeModule(homeCoordinator: self,
                                                 transactionsService: transactionsService,
                                                 userService: userService)
        let nav = UINavigationController(rootViewController: homeVC)
        navigation = nav
        return nav
    }
}

// MARK: - HomePresenterOutput

extension HomeCoordinator: HomePresenterOutput {
    func showExchangeRate() {
        let vc = exchangeAssembly.makeExchangeRateModule(network: network,
                                                         config: config,
                                                         coreData: coreData, exchangeRateService: exchangeRateService)
        navigation?.pushViewController(vc, animated: true)
    }
    
    func showStock() {
        let vc = stocksAssembly.makeStocksModule(stocksService: stocksService)
        navigation?.pushViewController(vc, animated: true)
    }
}
