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
    func fetchTransactions() throws -> [TransactionManagedObject] {
        let fetchRequest = TransactionManagedObject.fetchRequest()
        return try viewContext.fetch(fetchRequest)
    }
    
    func fetchTransactionsByRevenue(_ predicate: String) throws -> [TransactionManagedObject] {
        let fetchRequest = TransactionManagedObject.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "type == %@", predicate)
        return try viewContext.fetch(fetchRequest)
    }
    
    func fetchUserInformation(uid: String) throws -> [UserManagedObject] {
        let fetchRequest = UserManagedObject.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uid == %@", uid)
        return try viewContext.fetch(fetchRequest)
    }
    
    func save(completion: @escaping(NSManagedObjectContext) throws -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            do {
                try completion(backgroundContext)
                if backgroundContext.hasChanges {
                    try backgroundContext.save()
                }
            } catch {
                print(error)
            }
        }
    }
}
