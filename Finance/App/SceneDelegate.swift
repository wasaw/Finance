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
        let network = Network()
        let config = NetworkConfiguration()
        let fileStore = FileStore()
        let coreData = CoreDataService()
        let defaultValueService = DefaultValueService(fileStore: fileStore)
        let transactionsService = TransactionsService(coreData: coreData)
        
// MARK: - Coordinator
    
        let homeCoordinator = HomeCoordinator(homeAssembly: homeAssembly,
                                              exchangeAssembly: exchangeAssembly,
                                              stocksAssembly: stocksAssembly,
                                              network: network,
                                              config: config,
                                              coreData: coreData,
                                              transactionsService: transactionsService)
        let profileCoordinator = ProfileCoordinator(profileAssembly: profileAssembly, coreData: coreData)

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
