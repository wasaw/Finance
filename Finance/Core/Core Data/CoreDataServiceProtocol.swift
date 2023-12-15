//
//  CoreDataServiceProtocol.swift
//  Finance
//
//  Created by Александр Меренков on 27.06.2023.
//

import Foundation
import CoreData

protocol CoreDataServiceProtocol: AnyObject {
    func fetchTransactions(limit: Int?) throws -> [TransactionManagedObject]
    func fetchTransactionsByRevenue(_ predicate: String) throws -> [TransactionManagedObject]
    func fetchTransactionsByMonth(startDate: Date, endDate: Date) throws -> [TransactionManagedObject]
    func fetchUserInformation(uid: String) throws -> [UserManagedObject]
    func fetchAccounts() throws -> [AccountManagedObject]
    func fetchCategories() throws -> [CategoryManagedObject]
    func save(completion: @escaping(NSManagedObjectContext) throws -> Void)
    func deleteUser()
    func deleteTransactions()
}
