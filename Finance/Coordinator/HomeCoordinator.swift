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
    private let chartAssembly: ChartAssembly
    private let exchangeAssembly: ExchangeRateAssembly
    private let stocksAssembly: StocksAssembly
    private let atmAssembly: ATMAssembly
    private let newsCoordinator: NewsCoordinator
    private let coreData: CoreDataServiceProtocol
    private let accountService: AccountServiceProtocol
    private let transactionsService: TransactionsServiceProtocol
    private let categoryService: CategoryServiceProtocol
    private let userService: UserServiceProtocol
    private let stocksService: StocksServiceProtocol
    private let exchangeRateService: ExchangeRateServiceProtocol
    
// MARK: - Lifecycle
    
    init(homeAssembly: HomeAssembly,
         chartAssembly: ChartAssembly,
         exchangeAssembly: ExchangeRateAssembly,
         stocksAssembly: StocksAssembly,
         atmAssembly: ATMAssembly,
         newsCoordinator: NewsCoordinator,
         coreData: CoreDataServiceProtocol,
         accountService: AccountServiceProtocol,
         transactionsService: TransactionsServiceProtocol,
         categoryService: CategoryServiceProtocol,
         userService: UserServiceProtocol,
         stocksService: StocksServiceProtocol,
         exchangeRateService: ExchangeRateServiceProtocol) {
        self.homeAssembly = homeAssembly
        self.chartAssembly = chartAssembly
        self.exchangeAssembly = exchangeAssembly
        self.stocksAssembly = stocksAssembly
        self.atmAssembly = atmAssembly
        self.newsCoordinator = newsCoordinator
        self.coreData = coreData
        self.accountService = accountService
        self.transactionsService = transactionsService
        self.categoryService = categoryService
        self.userService = userService
        self.stocksService = stocksService
        self.exchangeRateService = exchangeRateService
    }
    
// MARK: - Helpers
    
    func start() -> UINavigationController {
        let homeVC = homeAssembly.makeHomeModule(homeCoordinator: self,
                                                 accountService: accountService,
                                                 transactionsService: transactionsService,
                                                 categoryService: categoryService,
                                                 userService: userService)
        let nav = UINavigationController(rootViewController: homeVC)
        navigation = nav
        return nav
    }
}

// MARK: - HomePresenterOutput

extension HomeCoordinator: HomePresenterOutput {
    func showChart() {
        let vc = chartAssembly.makeChartModule(categoryService: categoryService)
        navigation?.pushViewController(vc, animated: true)
    }
    
    func showExchangeRate() {
        let vc = exchangeAssembly.makeExchangeRateModule(coreData: coreData, exchangeRateService: exchangeRateService)
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
        let vc = newsCoordinator.start()
        navigation?.pushViewController(vc, animated: true)
    }
}
