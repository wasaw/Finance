//
//  TabBarAssembly.swift
//  Finance
//
//  Created by Александр Меренков on 10.01.2024.
//

import UIKit

final class TabBarAssembly {
    
    private let defaults = CustomUserDefaults.shared
    
// MARK: - Assembly

    private let homeAssembly: HomeAssembly
    private let addAssembly: AddTransactionAssembly
    private let profileAssembly: ProfileAssembly
    private let progressAssembly: ProgressAssembly
    private let chartAssembly: ChartAssembly
    private let exchangeAssembly: ExchangeRateAssembly
    private let stocksAssembly: StocksAssembly
    private let authAssembly: AuthAssembly
    private let atmAssembly: ATMAssembly
    private let newsAssembly: NewsAssembly
    
// MARK: - Core

    private let network: Network
    private let coreData: CoreDataService
    private let fileStore: FileStore

// MARK: - Services
    
    private let defaultValueService: DefaultValueService
    private let accountService: AccountService
    private let categoryService: CategoryService
    private let firebaseService: FirebaseService
    private let transactionsService: TransactionsService
    private let authService: AuthService
    private let userService: UserService
    private let stocksService: StocksService
    private let exchangeRateService: ExchangeRateService
    private let newsService: NewsService
    
// MARK: - Coordinator
    
    let newsCoordinator: NewsCoordinator
    let homeCoordinator: HomeCoordinator
    let authCoordinator: AuthCoordinator
    let profileCoordinator: ProfileCoordinator

// MARK: - Lifecycle
    
    init() {
        self.homeAssembly = HomeAssembly()
        self.addAssembly = AddTransactionAssembly()
        self.profileAssembly = ProfileAssembly()
        self.progressAssembly = ProgressAssembly()
        self.chartAssembly = ChartAssembly()
        self.exchangeAssembly = ExchangeRateAssembly()
        self.stocksAssembly = StocksAssembly()
        self.authAssembly = AuthAssembly()
        self.atmAssembly = ATMAssembly()
        self.newsAssembly = NewsAssembly()
        
        self.network = Network()
        self.coreData = CoreDataService()
        self.fileStore = FileStore()
        
        self.defaultValueService = DefaultValueService(fileStore: fileStore, coreData: coreData)
        self.accountService = AccountService(fileStore: fileStore, coreData: coreData)
        self.categoryService = CategoryService(fileStore: fileStore, coreData: coreData)
        self.firebaseService = FirebaseService(network: network,
                                              fileStore: fileStore)
        self.transactionsService = TransactionsService(coreData: coreData,
                                                      firebaseService: firebaseService,
                                                      accountService: accountService,
                                                      categoryService: categoryService)
        
        self.authService = AuthService(coreData: coreData, firebaseService: firebaseService)
        self.userService = UserService(coreData: coreData,
                                      fileStore: fileStore,
                                      firebaseService: firebaseService)
        self.stocksService = StocksService(network: network,
                                           defaultValueService: defaultValueService)
        self.exchangeRateService = ExchangeRateService(network: network,
                                                      defaultValueService: defaultValueService)
        self.newsService = NewsService(network: network)
        
        self.newsCoordinator = NewsCoordinator(newsAssembly: newsAssembly, newsService: newsService)
        self.homeCoordinator = HomeCoordinator(homeAssembly: homeAssembly,
                                               chartAssembly: chartAssembly,
                                               exchangeAssembly: exchangeAssembly,
                                               stocksAssembly: stocksAssembly,
                                               atmAssembly: atmAssembly,
                                               newsCoordinator: newsCoordinator,
                                               coreData: coreData,
                                               accountService: accountService,
                                               transactionsService: transactionsService,
                                               categoryService: categoryService,
                                               userService: userService,
                                               stocksService: stocksService,
                                               exchangeRateService: exchangeRateService)
        self.authCoordinator = AuthCoordinator(authAssembly: authAssembly,
                                               authService: authService,
                                               transactionsService: transactionsService)
        self.profileCoordinator = ProfileCoordinator(profileAssembly: profileAssembly,
                                                     progressAssembly: progressAssembly,
                                                     authService: authService,
                                                     userService: userService,
                                                     authCoordinator: authCoordinator,
                                                     exchageRateService: exchangeRateService,
                                                     transactionsService: transactionsService)
        
        if defaults.get(for: .isFirstLaunce) == nil {
            defaultValueService.saveValue()
            defaults.set(false, key: .isFirstLaunce)
        }
        _ = DefaultValue(fileStore: fileStore)
    }
// MARK: - Helpers
    
    func makeTabBar() -> UIViewController {
        return TabBarController(homeCoordinator: homeCoordinator,
                                addAssembly: addAssembly,
                                profileCoordinator: profileCoordinator, coreData: coreData,
                                accountService: accountService,
                                categoryService: categoryService,
                                transactionsService: transactionsService,
                                defaultValueService: defaultValueService,
                                fileStore: fileStore)
    }
}
