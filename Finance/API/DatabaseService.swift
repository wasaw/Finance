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
    func addCategoryInfornation(category: [ChoiceCategoryExpense]) {
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
    
    func addTypeInformation(type: [ChoiceTypeRevenue]) {
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
    
    func addServiceInformation(service: [ChoiceService]) {
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
    
    func saveTransaction(transaction: LastTransaction) {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Transaction")
        
        do {
            guard let entity = NSEntityDescription.entity(forEntityName: "Transaction", in: context) else { return }
            
            let newTransaction  = NSManagedObject(entity: entity, insertInto: context)
            newTransaction.setValue(transaction.type, forKey: "type")
            newTransaction.setValue(transaction.category, forKey: "category")
            newTransaction.setValue(transaction.ammount, forKey: "ammount")
            newTransaction.setValue(transaction.comment, forKey: "comment")
            
            try context.save()
        } catch let error as NSError {
            print(error)
        }
    }
    
//    MARK: - Get
    
    func getCategoryInformation() -> [ChoiceCategoryExpense] {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        var category = [ChoiceCategoryExpense]()
        
        do {
            let result = try context.fetch(fetchRequest)
            for data in result {
                if let data = data as? NSManagedObject {
                    let name = data.value(forKey: "name") as? String ?? ""
                    let img = data.value(forKey: "img") as? String ?? ""
                    let item = ChoiceCategoryExpense(name: name, img: img)
                    category.append(item)
                }
            }
        } catch let error as NSError {
            print(error)
        }
        return category
    }
    
    func getTypeInformation() -> [ChoiceTypeRevenue]{
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Type")
        var type = [ChoiceTypeRevenue]()
        
        do {
            let result = try context.fetch(fetchRequest)
            for data in result {
                if let data = data as? NSManagedObject {
                    let name = data.value(forKey: "name") as? String ?? ""
                    let img = data.value(forKey: "img") as? String ?? ""
                    let item = ChoiceTypeRevenue(name: name, img: img)
                    type.append(item)
                }
            }
        } catch let error as NSError {
            print(error)
        }
        return type
    }
    
    func getServiceInformation() -> [ChoiceService] {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Service")
        var service = [ChoiceService]()
        
        do {
            let result = try context.fetch(fetchRequest)
            for data in result {
                if let data = data as? NSManagedObject {
                    let name = data.value(forKey: "name") as? String ?? ""
                    let img = data.value(forKey: "img") as? String ?? ""
                    let item = ChoiceService(name: name, img: img)
                    service.append(item)
                }
            }
        } catch let error as NSError {
            print(error)
        }
        return service
    }
}
