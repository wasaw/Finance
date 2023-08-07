//
//  TestCoreDataStack.swift
//  FinanceUnitTests
//
//  Created by Александр Меренков on 04.08.2023.
//

import CoreData

final class TestCoreDataStack {
    func getMenagedObjectContext() -> NSManagedObjectContext {
         let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main]) ?? NSManagedObjectModel()

         let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)

         do {
             try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil)
         } catch {
             print("error")
         }

         let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
         managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator

         return managedObjectContext
     }
}

extension NSManagedObject {
    convenience init(usedContext: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        guard let entity = NSEntityDescription.entity(forEntityName: name, in: usedContext) else {
            self.init(context: usedContext)
            return
        }
        self.init(entity: entity, insertInto: usedContext)
    }
}
