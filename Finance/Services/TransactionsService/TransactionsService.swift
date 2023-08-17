//
//  TransactionsService.swift
//  Finance
//
//  Created by Александр Меренков on 27.06.2023.
//

import Foundation

final class TransactionsService {
    
// MARK: - Properties
    
    private let coreData: CoreDataServiceProtocol
    
// MARK: - Lifecycle
    
    init(coreData: CoreDataServiceProtocol) {
        self.coreData = coreData
    }
    
}

// MARK: - TransactionsServiceProtocol

extension TransactionsService: TransactionsServiceProtocol {
    func fetchTransactions() throws -> [LastTransaction] {
        do {
            let transactionManagedObject = try self.coreData.fetchTransactions()
            let lastTransaction: [LastTransaction] = transactionManagedObject.compactMap { transaction in
                guard let type = transaction.type,
                      let img = transaction.img,
                      let date = transaction.date,
                      let comment = transaction.comment,
                      let category = transaction.category
                else {
                    return nil
                }
                return LastTransaction(type: type,
                                       amount: transaction.amount,
                                       img: img,
                                       date: date,
                                       comment: comment,
                                       category: category)
            }
            return lastTransaction
        } catch {
            throw error
        }
    }
    
    func saveTransaction(_ transaction: LastTransaction) {
        guard let currencyRate = UserDefaults.standard.value(forKey: "currencyRate") as? Double else {
            return
        }
        coreData.save { context in
            let transactionManagedObject = TransactionManagedObject(context: context)
            transactionManagedObject.type = transaction.type
            transactionManagedObject.category = transaction.category
            transactionManagedObject.img = transaction.img
            transactionManagedObject.date = transaction.date
            transactionManagedObject.amount = transaction.amount * currencyRate
            transactionManagedObject.comment = transaction.comment
        }
    }
}
