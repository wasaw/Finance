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
        let lastTransaction = LastTransactionAssembly()
        let network = Network()
        let config = NetworkConfiguration()
        let fileStore = FileStore()
        let coreData = CoreDataService()
        let defaultValueService = DefaultValueService(fileStore: fileStore)
        let firebaseService = FirebaseService()
        let transactionsService = TransactionsService(coreData: coreData, firebaseService: firebaseService)
        let authService = AuthService(coreData: coreData, firebaseService: firebaseService)
        let userService = UserService(coreData: coreData,
                                      fileStore: fileStore,
                                      firebaseService: firebaseService)
        let stocksService = StocksService(network: network,
                                          config: config,
                                          defaultValueService: defaultValueService)
        let exchangeRateService = ExchangeRateService(network: network,
                                                      config: config,
                                                      defaultValueService: defaultValueService)
        
// MARK: - Coordinator
    
        let homeCoordinator = HomeCoordinator(homeAssembly: homeAssembly,
                                              exchangeAssembly: exchangeAssembly,
                                              stocksAssembly: stocksAssembly,
                                              lastTransaction: lastTransaction,
                                              network: network,
                                              config: config,
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
