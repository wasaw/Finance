//
//  CoreDataProtocol.swift
//  Finance
//
//  Created by Александр Меренков on 27.06.2023.
//

import Foundation
import CoreData

protocol CoreDataProtocol: AnyObject {
    func fetchTransactions() throws -> [TransactionManagedObject]
    func fetchUserInformation(uid: String) throws -> [UserManagedObject]
    func save(completion: @escaping(NSManagedObjectContext) throws -> Void)
}
