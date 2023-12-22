//
//  CoreDataService.swift
//  Finance
//
//  Created by Александр Меренков on 28.06.2022.
//

import CoreData

final class CoreDataService {
    
// MARK: - Properties
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "Model")
        persistentContainer.loadPersistentStores { _, error in
            guard let error = error else { return }
            print(error)
        }
        return persistentContainer
    }()
    
    private var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
}

// MARK: - CoreDataProtocol

extension CoreDataService: CoreDataServiceProtocol {
    func fetchTransactions(limit: Int?) throws -> [TransactionManagedObject] {
        let fetchRequest = TransactionManagedObject.fetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        if let limit = limit {
            fetchRequest.fetchLimit = limit
        }
        return try viewContext.fetch(fetchRequest)
    }
    
    func fetchTransactionsByRevenue(_ predicate: String) throws -> [TransactionManagedObject] {
        let fetchRequest = TransactionManagedObject.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "type == %@", predicate)
        return try viewContext.fetch(fetchRequest)
    }
    
    func fetchTransactionsByMonth(startDate: Date, endDate: Date) throws -> [TransactionManagedObject] {
        let fetchRequest = TransactionManagedObject.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date >= %@ && date <= %@",
                                             startDate as NSDate,
                                             endDate as NSDate)
        return try viewContext.fetch(fetchRequest)
    }
    
    func fetchUserInformation(uid: String) throws -> [UserManagedObject] {
        let fetchRequest = UserManagedObject.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uid == %@", uid)
        return try viewContext.fetch(fetchRequest)
    }
    
    func fetchAccounts(_ id: UUID?) throws -> [AccountManagedObject] {
        let fetchRequest = AccountManagedObject.fetchRequest()
        if let id = id {
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        }
        return try viewContext.fetch(fetchRequest)
    }
    
    func fetchCategories(_ id: UUID?) throws -> [CategoryManagedObject] {
        let fetchRequest = CategoryManagedObject.fetchRequest()
        if let id = id {
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        }
        return try viewContext.fetch(fetchRequest)
    }
    
    func save(completion: @escaping(NSManagedObjectContext) throws -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.performAndWait {
            do {
                try completion(backgroundContext)
                if backgroundContext.hasChanges {
                    try backgroundContext.save()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteUser() {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest = UserManagedObject.fetchRequest()
            guard let userCollection = try? backgroundContext.fetch(fetchRequest).first else { return }
            backgroundContext.delete(userCollection)
            try? backgroundContext.save()
        }
    }
    
    func deleteTransactions() {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest = TransactionManagedObject.fetchRequest()
            let accountFetchRequest = AccountManagedObject.fetchRequest()
            do {
                let items = try backgroundContext.fetch(fetchRequest)
                for item in items {
                    backgroundContext.delete(item)
                }
                let accounts = try backgroundContext.fetch(accountFetchRequest)
                for account in accounts {
                    account.amount = 0
                }
                try backgroundContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
