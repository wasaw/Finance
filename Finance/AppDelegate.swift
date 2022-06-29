//
//  AppDelegate.swift
//  Finance
//
//  Created by Александр Меренков on 08.06.2022.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let databaseService = DatabaseService.shared
        if databaseService.firstLaunce() {

            let revenue = [TypeRevenue(name: "Зарплата", img: "calendar.png"), TypeRevenue(name: "Продажа", img: "sales.png"), TypeRevenue(name: "Проценты", img: "price-tag.png"), TypeRevenue(name: "Наличные", img: "salary.png"), TypeRevenue(name: "Вклад", img: "deposit.png"), TypeRevenue(name: "Иное", img: "other.png")]

            let category = [CategoryExpense(name: "Продукты", img: "products.png"), CategoryExpense(name: "Транспорт", img: "transportation.png"), CategoryExpense(name: "Образование", img: "education.png"), CategoryExpense(name: "Подписки", img: "subscription.png"), CategoryExpense(name: "Прочее", img: "other.png"), CategoryExpense(name: "Связь", img: "chat.png"), CategoryExpense(name: "Развлечения", img: "cinema.png"), CategoryExpense(name: "Ресторан", img: "fast-food.png"), CategoryExpense(name: "Здоровье", img: "healthcare.png")]

            let service = [ServiceDescription(name: "Курс валют", img: "exchange-rate.png"), ServiceDescription(name: "Акции", img: "stock-market.png")]
            
            databaseService.addTypeInformation(type: revenue)
            databaseService.addCategoryInfornation(category: category)
            databaseService.addServiceInformation(service: service)
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

//    MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: {(storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolver error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
//    MARK: - Core Data Saving support
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolver error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

