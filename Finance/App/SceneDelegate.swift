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
        
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
// MARK: - Coordinator
    
        let homeCoordinator = HomeCoordinator(homeAssembly: homeAssembly)
        let addCoordinator = AddTransactionCoordinator()
        let profileCoordinator = ProfileCoordinator()

        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.rootViewController = TabBarController(homeCoordinator: homeCoordinator,
                                                      addCoordinator: addCoordinator,
                                                      profileCoordinator: profileCoordinator)
        window?.makeKeyAndVisible()
    }
}
