//
//  AppDelegate.swift
//  Finance
//
//  Created by Александр Меренков on 08.06.2022.
//

import UIKit
import CoreData
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        let isLaunchedBefore = UserDefaults.standard.bool(forKey: "isLaunchedBefore")
        if !isLaunchedBefore {
            DispatchQueue.main.async {
//                DatabaseService.shared.setDefaultValue { result in
//                    switch result {
//                    case .success:
//                        UserDefaults.standard.set(true, forKey: "isLaunchedBefore")
//                    case .failure(let error):
//                        print(error.localizedDescription)
//                    }
//                }
            }
        }
        return true
    }

// MARK: - UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
