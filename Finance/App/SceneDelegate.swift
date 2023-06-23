//
//  SceneDelegate.swift
//  Finance
//
//  Created by Александр Меренков on 08.06.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

// MARK: - Assembly
        
    private let homeAssembly = HomeAssembly()
    private let addAssembly = AddTransactionAssembly()
    private let profileAssembly = ProfileAssembly()
    private let exchangeAssembly = ExchangeRateAssembly()
    private let stocksAssembly = StocksAssembly()
    private let network = Network()
    private let config = NetworkConfiguration()
        
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
// MARK: - Coordinator
    
        let homeCoordinator = HomeCoordinator(homeAssembly: homeAssembly,
                                              exchangeAssembly: exchangeAssembly,
                                              stocksAssembly: stocksAssembly,
                                              network: network,
                                              config: config)
        let profileCoordinator = ProfileCoordinator(profileAssembly: profileAssembly)

        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.rootViewController = TabBarController(homeCoordinator: homeCoordinator,
                                                      addAssembly: addAssembly,
                                                      profileCoordinator: profileCoordinator)
        window?.makeKeyAndVisible()
    }
}
