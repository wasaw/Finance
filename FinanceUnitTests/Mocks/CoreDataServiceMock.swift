//
//  CoreDataServiceMock.swift
//  FinanceUnitTests
//
//  Created by Александр Меренков on 04.08.2023.
//

import CoreData
@testable import Finance

final class CoreDataServiceMock: CoreDataServiceProtocol {

    var invokedFetchTransactions = false
    var invokedFetchTransactionsCount = 0
    var stubbedFetchTransactionsError: Error?
    var stubbedFetchTransactionsResult: [TransactionManagedObject]! = []

    func fetchTransactions() throws -> [TransactionManagedObject] {
        invokedFetchTransactions = true
        invokedFetchTransactionsCount += 1
        if let error = stubbedFetchTransactionsError {
            throw error
        }
        return stubbedFetchTransactionsResult
    }

    var invokedFetchTransactionsByRevenue = false
    var invokedFetchTransactionsByRevenueCount = 0
    var invokedFetchTransactionsByRevenueParameters: (predicate: String, Void)?
    var invokedFetchTransactionsByRevenueParametersList = [(predicate: String, Void)]()
    var stubbedFetchTransactionsByRevenueError: Error?
    var stubbedFetchTransactionsByRevenueResult: [TransactionManagedObject]! = []

    func fetchTransactionsByRevenue(_ predicate: String) throws -> [TransactionManagedObject] {
        invokedFetchTransactionsByRevenue = true
        invokedFetchTransactionsByRevenueCount += 1
        invokedFetchTransactionsByRevenueParameters = (predicate, ())
        invokedFetchTransactionsByRevenueParametersList.append((predicate, ()))
        if let error = stubbedFetchTransactionsByRevenueError {
            throw error
        }
        return stubbedFetchTransactionsByRevenueResult
    }

    var invokedFetchUserInformation = false
    var invokedFetchUserInformationCount = 0
    var invokedFetchUserInformationParameters: (uid: String, Void)?
    var invokedFetchUserInformationParametersList = [(uid: String, Void)]()
    var stubbedFetchUserInformationError: Error?
    var stubbedFetchUserInformationResult: [UserManagedObject]! = []

    func fetchUserInformation(uid: String) throws -> [UserManagedObject] {
        invokedFetchUserInformation = true
        invokedFetchUserInformationCount += 1
        invokedFetchUserInformationParameters = (uid, ())
        invokedFetchUserInformationParametersList.append((uid, ()))
        if let error = stubbedFetchUserInformationError {
            throw error
        }
        return stubbedFetchUserInformationResult
    }

    var invokedSave = false
    var invokedSaveCount = 0
    var stubbedSaveCompletionResult: (NSManagedObjectContext, Void)?

    func save(completion: @escaping(NSManagedObjectContext) throws -> Void) {
        invokedSave = true
        invokedSaveCount += 1
        if let result = stubbedSaveCompletionResult {
            try? completion(result.0)
        }
    }

    var invokedDeleteUser = false
    var invokedDeleteUserCount = 0

    func deleteUser() {
        invokedDeleteUser = true
        invokedDeleteUserCount += 1
    }

    var invokedDeleteTransactions = false
    var invokedDeleteTransactionsCount = 0

    func deleteTransactions() {
        invokedDeleteTransactions = true
        invokedDeleteTransactionsCount += 1
    }
}
