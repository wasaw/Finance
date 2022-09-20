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
                    newType.setValue(0, forKey: "amount")
                    
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
        let fetchRequestType = NSFetchRequest<NSFetchRequestResult>(entityName: "Type")
        fetchRequestType.predicate = NSPredicate(format: "name == %@", transaction.type)
        
        do {
            guard let entity = NSEntityDescription.entity(forEntityName: "Transaction", in: context) else { return  }
            guard let entityType = NSEntityDescription.entity(forEntityName: "Type", in: context) else { return  }
            
            let newTransaction  = NSManagedObject(entity: entity, insertInto: context)
            newTransaction.setValue(transaction.type, forKey: "type")
            newTransaction.setValue(transaction.category, forKey: "category")
            newTransaction.setValue(transaction.img, forKey: "img")
            newTransaction.setValue(transaction.date, forKey: "date")
            newTransaction.setValue(transaction.amount, forKey: "amount")
            newTransaction.setValue(transaction.comment, forKey: "comment")
            
            let result = try context.fetch(fetchRequestType)
            var amount = 0
            for data in result {
                if let data = data as? NSManagedObject {
                    amount = data.value(forKey: "amount") as? Int ?? -1
                    data.setValue(transaction.amount + amount, forKey: "amount")
                }
            }
            
            try context.save()
        } catch let error as NSError {
            print(error)
        }
    }
    
    func saveUser(user: User) {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LoginUser")
        
        do {
            guard let entity = NSEntityDescription.entity(forEntityName: "LoginUser", in: context) else { return }
                    
            let newTransaction = NSManagedObject(entity: entity, insertInto: context)
            newTransaction.setValue(user.login, forKey: "login")
            newTransaction.setValue(user.uid, forKey: "uid")
            newTransaction.setValue(user.email, forKey: "email")
            let profileImageUrl = user.profileImageUrl?.absoluteString ?? ""
            newTransaction.setValue(profileImageUrl, forKey: "profileImageUrl")
            newTransaction.setValue(user.authorized, forKey: "authorized")
            
            do {
                try context.save()
            } catch let error as NSError {
                print(error)
            }
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
                    let amount = data.value(forKey: "amount") as? Int ?? 0
                    let item = ChoiceTypeRevenue(name: name, img: img, amount: amount)
                    type.append(item)
                }
            }
        } catch let error as NSError {
            print(error)
        }
        return type
    }
    
    func getTransactionInformation() -> [LastTransaction] {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Transaction")
        var lastTransaction = [LastTransaction]()
        let sort = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.fetchLimit = 5
        
        do {
            let result = try context.fetch(fetchRequest)
            for data in result {
                if let data = data as? NSManagedObject {
                    let type = data.value(forKey: "type") as? String ?? ""
                    let category = data.value(forKey: "category") as? String ?? ""
                    let img = data.value(forKey: "img") as? String ?? ""
                    let amount = data.value(forKey: "amount") as? Int ?? 0
                    let date = data.value(forKey: "date") as? Date ?? Date(timeIntervalSinceNow: 0)
                    let comment = data.value(forKey: "comment") as? String ?? ""
                    let item = LastTransaction(type: type, amount: amount, img: img, date: date, comment: comment, category: category)
                    lastTransaction.append(item)
                }
            }
        } catch let error as NSError {
            print(error)
        }
        
        return lastTransaction
    }
    
    func getUserInformation(uid: String) -> User? {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LoginUser")
        fetchRequest.predicate = NSPredicate(format: "uid == %@", uid)
        
        do {
            let result = try context.fetch(fetchRequest)
            for data in result {
                if let data = data as? NSManagedObject {
                    let uid = data.value(forKey: "uid") as? String ?? ""
                    let login = data.value(forKey: "login") as? String ?? ""
                    let email = data.value(forKey: "email") as? String ?? ""
                    let profileImageUrl = data.value(forKey: "profileImageUrl") as? String ?? ""
                    let authorized = data.value(forKey: "authorized") as? Bool ?? false
                    let user = User(uid: uid, login: login, email: email, profileImageUrl: profileImageUrl, authorized: authorized)
                    return user
                }
            }
        } catch let error as NSError {
            print(error)
        }
        
        return nil
    }
}
