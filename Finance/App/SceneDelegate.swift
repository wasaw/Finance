//
//  SceneDelegate.swift
//  Finance
//
//  Created by Александр Меренков on 08.06.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
        
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
// MARK: - Assembly
        
        let homeAssembly = HomeAssembly()
        let addAssembly = AddTransactionAssembly()
        let profileAssembly = ProfileAssembly()
        let exchangeAssembly = ExchangeRateAssembly()
        let stocksAssembly = StocksAssembly()
        let authAssembly = AuthAssembly()
        let atmAssembly = ATMAssembly()
        let newsAssembly = NewsAssembly()
        let lastTransaction = LastTransactionAssembly()
        let network = Network()
        let requestBuilder = RequestBuilder()
        let fileStore = FileStore()
        let coreData = CoreDataService()
        let defaultValueService = DefaultValueService(fileStore: fileStore)
        let firebaseService = FirebaseService(network: network, fileStore: fileStore)
        let transactionsService = TransactionsService(coreData: coreData, firebaseService: firebaseService)
        let exchangeRequest = ExchangeRateRequest()
        let stocksRequest = StocksRequest()
        let newsRequest = NewsRequest()
        let authService = AuthService(coreData: coreData, firebaseService: firebaseService)
        let userService = UserService(coreData: coreData,
                                      fileStore: fileStore,
                                      firebaseService: firebaseService)
        let stocksService = StocksService(network: network,
                                          requestBuilder: requestBuilder,
                                          defaultValueService: defaultValueService,
                                          stocksRequest: stocksRequest)
        let exchangeRateService = ExchangeRateService(network: network,
                                                      requestBuilder: requestBuilder,
                                                      defaultValueService: defaultValueService,
                                                      exchangeRequest: exchangeRequest)
        let newsService = NewsService(network: network,
                                      requestBuilder: requestBuilder,
                                      newsRequest: newsRequest)
        
// MARK: - Coordinator
    
        let newsCoordinator = NewsCoordinator(newsAssembly: newsAssembly, newsService: newsService)
        let homeCoordinator = HomeCoordinator(homeAssembly: homeAssembly,
                                              exchangeAssembly: exchangeAssembly,
                                              stocksAssembly: stocksAssembly,
                                              atmAssembly: atmAssembly,
                                              newsCoordinator: newsCoordinator,
                                              lastTransaction: lastTransaction,
                                              coreData: coreData,
                                              transactionsService: transactionsService,
                                              userService: userService,
                                              stocksService: stocksService,
                                              exchangeRateService: exchangeRateService)
        let authCoordinator = AuthCoordinator(authAssembly: authAssembly,
                                              authService: authService,
                                              transactionsService: transactionsService)
        let profileCoordinator = ProfileCoordinator(profileAssembly: profileAssembly,
                                                    authService: authService,
                                                    userService: userService,
                                                    authCoordinator: authCoordinator,
                                                    exchageRateService: exchangeRateService,
                                                    transactionsService: transactionsService)

        guard let scene = (scene as? UIWindowScene) else { return }
        
        _ = DefaultValue(fileStore: fileStore)
        window = UIWindow(windowScene: scene)
        window?.rootViewController = TabBarController(homeCoordinator: homeCoordinator,
                                                      addAssembly: addAssembly,
                                                      profileCoordinator: profileCoordinator, coreData: coreData,
                                                      transactionsService: transactionsService,
                                                      defaultValueService: defaultValueService)
        window?.makeKeyAndVisible()
    }
}
