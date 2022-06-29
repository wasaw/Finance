//
//  DatabaseService.swift
//  Finance
//
//  Created by Александр Меренков on 28.06.2022.
//

import Foundation
import CoreData
import UIKit

class DatabaseService {
    static let shared = DatabaseService()
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
//    MARK: - isEmpty
    
    func firstLaunce() -> Bool {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        
        do {
            let result = try context.fetch(fetchRequest)
            if result.isEmpty {
                return true
            }
        } catch let error as NSError {
            print(error)
        }
        return false
    }
    
//    MARK: - Add
    func addCategoryInfornation(category: [CategoryExpense]) {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        
        do {
            let result = try context.fetch(fetchRequest)
            if (result.first as? NSManagedObject) == nil {
                guard let entity = NSEntityDescription.entity(forEntityName: "Category", in: context) else { return }

                for item in category {
                    let newCategory = NSManagedObject(entity: entity, insertInto: context)
                    
                    newCategory.setValue(item.name, forKey: "name")
                    newCategory.setValue(item.img, forKey: "img")
                    
                    do {
                        try context.save()
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    func addTypeInformation(type: [TypeRevenue]) {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Type")
        
        do {
            let result = try context.fetch(fetchRequest)
            if (result.first as? NSManagedObject) == nil {
                guard let entity = NSEntityDescription.entity(forEntityName: "Type", in: context) else { return }
                
                for item in type {
                    let newType = NSManagedObject(entity: entity, insertInto: context)
                    
                    newType.setValue(item.name, forKey: "name")
                    newType.setValue(item.img, forKey: "img")
                    newType.setValue(0, forKey: "count")
                    
                    do {
                        try context.save()
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    func addServiceInformation(service: [ServiceDescription]) {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Service")
        
        do {
            let result = try context.fetch(fetchRequest)
            if (result.first as? NSManagedObject) == nil {
                guard let entity = NSEntityDescription.entity(forEntityName: "Service", in: context) else { return }
                
                for item in service {
                    let newService = NSManagedObject(entity: entity, insertInto: context)
                    
                    newService.setValue(item.name, forKey: "name")
                    newService.setValue(item.img, forKey: "img")
                    
                    do {
                        try context.save()
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
//    MARK: - Get
    
    func getCategoryInformation() -> [CategoryExpense] {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        var category = [CategoryExpense]()
        
        do {
            let result = try context.fetch(fetchRequest)
            for data in result {
                if let data = data as? NSManagedObject {
                    let name = data.value(forKey: "name") as? String ?? ""
                    let img = data.value(forKey: "img") as? String ?? ""
                    let item = CategoryExpense(name: name, img: img)
                    category.append(item)
                }
            }
        } catch let error as NSError {
            print(error)
        }
        return category
    }
    
    func getTypeInformation() -> [TypeRevenue]{
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Type")
        var type = [TypeRevenue]()
        
        do {
            let result = try context.fetch(fetchRequest)
            for data in result {
                if let data = data as? NSManagedObject {
                    let name = data.value(forKey: "name") as? String ?? ""
                    let img = data.value(forKey: "img") as? String ?? ""
                    let item = TypeRevenue(name: name, img: img)
                    type.append(item)
                }
            }
        } catch let error as NSError {
            print(error)
        }
        return type
    }
    
    func getServiceInformation() -> [ServiceDescription] {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Service")
        var service = [ServiceDescription]()
        
        do {
            let result = try context.fetch(fetchRequest)
            for data in result {
                if let data = data as? NSManagedObject {
                    let name = data.value(forKey: "name") as? String ?? ""
                    let img = data.value(forKey: "img") as? String ?? ""
                    let item = ServiceDescription(name: name, img: img)
                    service.append(item)
                }
            }
        } catch let error as NSError {
            print(error)
        }
        return service
    }
}
