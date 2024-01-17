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
    private let accountService: AccountServiceProtocol
    private let categoryService: CategoryServiceProtocol
    
    private let defaults = CustomUserDefaults.shared
    
// MARK: - Lifecycle
    
    init(coreData: CoreDataServiceProtocol,
         firebaseService: FirebaseServiceProtocol,
         accountService: AccountServiceProtocol,
         categoryService: CategoryServiceProtocol) {
        self.coreData = coreData
        self.firebaseService = firebaseService
        self.accountService = accountService
        self.categoryService = categoryService
    }
    
}

// MARK: - TransactionsServiceProtocol

extension TransactionsService: TransactionsServiceProtocol {
    func fetchTransactions(limit: Int?) throws -> [Transaction] {
        do {
            let transactionManagedObject = try self.coreData.fetchTransactions(limit: limit)
            let lastTransaction: [Transaction] = transactionManagedObject.compactMap { transaction in
                guard
                      let date = transaction.date,
                      let comment = transaction.comment,
                      let account = transaction.account,
                      let accountId = account.id,
                      let category = transaction.category,
                      let categoryId = category.id
                else {
                    return nil
                }
                return Transaction(account: accountId,
                                   category: categoryId,
                                   amount: transaction.amount,
                                   date: date,
                                   comment: comment)
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
                guard
                      let date = transaction.date,
                      let comment = transaction.comment,
                      let account = transaction.account,
                      let accountId = account.id,
                      let category = transaction.category,
                      let categoryId = category.id,
                      transaction.amount < 0
                else {
                    return nil
                }
                return Transaction(account: accountId,
                                   category: categoryId,
                                   amount: transaction.amount,
                                   date: date,
                                   comment: comment)
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
    
    func fetchTransactionsByCategory(for id: UUID) throws -> [Transaction] {
        do {
            let categoryManagedObject = try coreData.fetchCategories(id).first
            guard let transactionsManagedObject = categoryManagedObject?.transactions?.array as? [TransactionManagedObject] else {
                throw TransactionError.notFound
            }
            
            let transactions: [Transaction] = transactionsManagedObject.compactMap { transaction in
                guard let account = transaction.account,
                      let accountId = account.id,
                      let date = transaction.date,
                      let comment = transaction.comment else {
                    return nil
                }
                return Transaction(account: accountId,
                                   category: id,
                                   amount: transaction.amount,
                                   date: date,
                                   comment: comment)
            }
            return transactions
        } catch {
            throw error
        }
    }
    
    func saveTransaction(_ transaction: Transaction) {
        guard let currencyRate = defaults.get(for: .currencyRate) as? Double else {
            return
        }
        coreData.save { [weak self] context in
            let transactionManagedObject = TransactionManagedObject(context: context)
            transactionManagedObject.date = transaction.date
            transactionManagedObject.amount = transaction.amount * currencyRate
            transactionManagedObject.comment = transaction.comment
            let fetchRequest = CategoryManagedObject.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", transaction.category as CVarArg)
            let categoriesManagedObject = try context.fetch(fetchRequest).first
            categoriesManagedObject?.addToTransactions(transactionManagedObject)
            
            let fetchRequestAccount = AccountManagedObject.fetchRequest()
            fetchRequestAccount.predicate = NSPredicate(format: "id == %@", transaction.account as CVarArg)
            let accountManagedObject = try context.fetch(fetchRequestAccount).first
            accountManagedObject?.addToTransactions(transactionManagedObject)
            accountManagedObject?.amount += transaction.amount
            
            guard let accountTitle = accountManagedObject?.title,
                  let categoryTitle = categoriesManagedObject?.title else { return }
            let firebaseTransaction = FirebaseTransaction(account: accountTitle,
                                                  category: categoryTitle,
                                                  amount: transaction.amount,
                                                  date: transaction.date,
                                                  comment: transaction.comment)
            self?.firebaseService.saveTransaction(firebaseTransaction)
        }
    }
    
    func upload(_ transactions: [Transaction]) {
        for item in transactions {
            guard let account = try? accountService.fetchAccount(for: item.account),
                  let category = try? categoryService.fetchCategory(for: item.category) else { return }
            let firebaseTransaction = FirebaseTransaction(account: account.title,
                                                          category: category.title,
                                                          amount: item.amount,
                                                          date: item.date,
                                                          comment: item.comment)
            firebaseService.saveTransaction(firebaseTransaction)
        }
    }
    
    func delete() {
        coreData.deleteTransactions()
    }
}
