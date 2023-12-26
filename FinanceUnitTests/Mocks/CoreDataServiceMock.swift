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
    var invokedFetchTransactionsParameters: (limit: Int?, Void)?
    var invokedFetchTransactionsParametersList = [(limit: Int?, Void)]()
    var stubbedFetchTransactionsError: Error?
    var stubbedFetchTransactionsResult: [TransactionManagedObject]! = []

    func fetchTransactions(limit: Int?) throws -> [TransactionManagedObject] {
        invokedFetchTransactions = true
        invokedFetchTransactionsCount += 1
        invokedFetchTransactionsParameters = (limit, ())
        invokedFetchTransactionsParametersList.append((limit, ()))
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

    var invokedFetchTransactionsByMonth = false
    var invokedFetchTransactionsByMonthCount = 0
    var invokedFetchTransactionsByMonthParameters: (startDate: Date, endDate: Date)?
    var invokedFetchTransactionsByMonthParametersList = [(startDate: Date, endDate: Date)]()
    var stubbedFetchTransactionsByMonthError: Error?
    var stubbedFetchTransactionsByMonthResult: [TransactionManagedObject]! = []

    func fetchTransactionsByMonth(startDate: Date, endDate: Date) throws -> [TransactionManagedObject] {
        invokedFetchTransactionsByMonth = true
        invokedFetchTransactionsByMonthCount += 1
        invokedFetchTransactionsByMonthParameters = (startDate, endDate)
        invokedFetchTransactionsByMonthParametersList.append((startDate, endDate))
        if let error = stubbedFetchTransactionsByMonthError {
            throw error
        }
        return stubbedFetchTransactionsByMonthResult
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

    var invokedFetchAccounts = false
    var invokedFetchAccountsCount = 0
    var invokedFetchAccountsParameters: (id: UUID?, Void)?
    var invokedFetchAccountsParametersList = [(id: UUID?, Void)]()
    var stubbedFetchAccountsError: Error?
    var stubbedFetchAccountsResult: [AccountManagedObject]! = []

    func fetchAccounts(_ id: UUID?) throws -> [AccountManagedObject] {
        invokedFetchAccounts = true
        invokedFetchAccountsCount += 1
        invokedFetchAccountsParameters = (id, ())
        invokedFetchAccountsParametersList.append((id, ()))
        if let error = stubbedFetchAccountsError {
            throw error
        }
        return stubbedFetchAccountsResult
    }

    var invokedFetchCategories = false
    var invokedFetchCategoriesCount = 0
    var invokedFetchCategoriesParameters: (id: UUID?, Void)?
    var invokedFetchCategoriesParametersList = [(id: UUID?, Void)]()
    var stubbedFetchCategoriesError: Error?
    var stubbedFetchCategoriesResult: [CategoryManagedObject]! = []

    func fetchCategories(_ id: UUID?) throws -> [CategoryManagedObject] {
        invokedFetchCategories = true
        invokedFetchCategoriesCount += 1
        invokedFetchCategoriesParameters = (id, ())
        invokedFetchCategoriesParametersList.append((id, ()))
        if let error = stubbedFetchCategoriesError {
            throw error
        }
        return stubbedFetchCategoriesResult
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
