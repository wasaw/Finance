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
        
        let databaseService = DatabaseService.shared
        if databaseService.firstLaunce() {

            let revenue = [ChoiceTypeRevenue(name: "Зарплата", img: "calendar.png"), ChoiceTypeRevenue(name: "Продажа", img: "sales.png"), ChoiceTypeRevenue(name: "Проценты", img: "price-tag.png"), ChoiceTypeRevenue(name: "Наличные", img: "salary.png"), ChoiceTypeRevenue(name: "Вклад", img: "deposit.png"), ChoiceTypeRevenue(name: "Иное", img: "other.png")]

            let category = [ChoiceCategoryExpense(name: "Продукты", img: "products.png"), ChoiceCategoryExpense(name: "Транспорт", img: "transportation.png"), ChoiceCategoryExpense(name: "Образование", img: "education.png"), ChoiceCategoryExpense(name: "Подписки", img: "subscription.png"), ChoiceCategoryExpense(name: "Прочее", img: "other.png"), ChoiceCategoryExpense(name: "Связь", img: "chat.png"), ChoiceCategoryExpense(name: "Развлечения", img: "cinema.png"), ChoiceCategoryExpense(name: "Ресторан", img: "fast-food.png"), ChoiceCategoryExpense(name: "Здоровье", img: "healthcare.png")]
            
            databaseService.addTypeInformation(type: revenue)
            databaseService.addCategoryInfornation(category: category)
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

