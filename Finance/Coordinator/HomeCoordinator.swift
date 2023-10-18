//
//  HomeCoordinator.swift
//  Finance
//
//  Created by Александр Меренков on 20.06.2023.
//

import UIKit

private enum Constants {
    static let viewCorner: CGFloat = 26
}

final class HomeCoordinator {
    
// MARK: - Properties
    
    private var navigation: UINavigationController?
    private let homeAssembly: HomeAssembly
    private let exchangeAssembly: ExchangeRateAssembly
    private let stocksAssembly: StocksAssembly
    private let atmAssembly: ATMAssembly
    private let newsAssembly: NewsAssembly
    private let lastTransaction: LastTransactionAssembly
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
         atmAssembly: ATMAssembly,
         newsAssembly: NewsAssembly,
         lastTransaction: LastTransactionAssembly,
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
        self.atmAssembly = atmAssembly
        self.newsAssembly = newsAssembly
        self.lastTransaction = lastTransaction
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
    
    func showATM() {
        let vc = atmAssembly.makeATMModule()
        navigation?.pushViewController(vc, animated: true)
    }
    
    func showNews() {
        let vc = newsAssembly.makeNewsModule()
        navigation?.pushViewController(vc, animated: true)
    }
    
    func showLastTransaction(_ transaction: Transaction) {
        let vc = lastTransaction.makeLastTransactionModule(transaction)
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = Constants.viewCorner
        }
        navigation?.present(vc, animated: true)
    }
}
