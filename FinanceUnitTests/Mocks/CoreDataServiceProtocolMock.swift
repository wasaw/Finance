//
//  CoreDataServiceProtocolMock.swift
//  FinanceUnitTests
//
//  Created by Александр Меренков on 04.08.2023.
//

import CoreData
@testable import Finance

final class CoreDataServiceProtocolMock: CoreDataServiceProtocol {

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
}
