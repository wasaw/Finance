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
    private let firebaseService: FirebaseServiceProtocol
    
// MARK: - Lifecycle
    
    init(coreData: CoreDataServiceProtocol, firebaseService: FirebaseServiceProtocol) {
        self.coreData = coreData
        self.firebaseService = firebaseService
    }
    
}

// MARK: - TransactionsServiceProtocol

extension TransactionsService: TransactionsServiceProtocol {
    func fetchTransactions(limit: Int?) throws -> [Transaction] {
        do {
            let transactionManagedObject = try self.coreData.fetchTransactions(limit: limit)
            let lastTransaction: [Transaction] = transactionManagedObject.compactMap { transaction in
                guard let type = transaction.type,
                      let img = transaction.img,
                      let date = transaction.date,
                      let comment = transaction.comment,
                      let category = transaction.category
                else {
                    return nil
                }
                return Transaction(type: type,
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
    
    func fetchTransactionByMonth() throws -> [Transaction] {
        let components = Calendar.current.dateComponents([.month, .year], from: Date())
        guard let startDateOfMonth = Calendar.current.date(from: components) else { return [Transaction]() }
        var oneMonth = DateComponents()
        oneMonth.month = 1
        guard let endDateOfMonth = Calendar.current.date(byAdding: oneMonth, to: startDateOfMonth) else {
            return [Transaction]()
        }
        
        do {
            let transactionManagedObject = try coreData.fetchTransactionsByMonth(startDate: startDateOfMonth, endDate: endDateOfMonth)
            let transactions: [Transaction] = transactionManagedObject.compactMap { transaction in
                guard let type = transaction.type,
                      let img = transaction.img,
                      let date = transaction.date,
                      let comment = transaction.comment,
                      let category = transaction.category
                else {
                    return nil
                }
                return Transaction(type: type,
                                       amount: transaction.amount,
                                       img: img,
                                       date: date,
                                       comment: comment,
                                       category: category)
            }
            return transactions
        } catch {
            throw error
        }
    }
    
    func fetchAmountBy(_ predicate: String) throws -> Double {
        do {
            let transactionManagedObject = try self.coreData.fetchTransactionsByRevenue(predicate)
            let transactionsAmount = transactionManagedObject.compactMap({ $0.amount })
            let amount = transactionsAmount.reduce(0, +)
            return amount
        } catch {
            throw error
        }
    }
    
    func saveTransaction(_ transaction: Transaction) {
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
        firebaseService.saveTransaction(transaction)
    }
    
    func upload(_ transactions: [Transaction]) {
        for item in transactions {
            firebaseService.saveTransaction(item)
        }
    }
    
    func delete() {
        coreData.deleteTransactions()
    }
}
