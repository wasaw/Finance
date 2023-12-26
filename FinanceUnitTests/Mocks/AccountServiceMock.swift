//
//  AccountServiceMock.swift
//  FinanceUnitTests
//
//  Created by Александр Меренков on 26.12.2023.
//

import Foundation
@testable import Finance

final class AccountServiceMock: AccountServiceProtocol {

    var invokedFetchAccounts = false
    var invokedFetchAccountsCount = 0
    var stubbedFetchAccountsCompletionResult: (Result<[Account], Error>, Void)?

    func fetchAccounts(completion: @escaping (Result<[Account], Error>) -> Void) {
        invokedFetchAccounts = true
        invokedFetchAccountsCount += 1
        if let result = stubbedFetchAccountsCompletionResult {
            completion(result.0)
        }
    }

    var invokedFetchAccount = false
    var invokedFetchAccountCount = 0
    var invokedFetchAccountParameters: (uid: UUID, Void)?
    var invokedFetchAccountParametersList = [(uid: UUID, Void)]()
    var stubbedFetchAccountError: Error?
    var stubbedFetchAccountResult: Account!

    func fetchAccount(for uid: UUID) throws -> Account {
        invokedFetchAccount = true
        invokedFetchAccountCount += 1
        invokedFetchAccountParameters = (uid, ())
        invokedFetchAccountParametersList.append((uid, ()))
        if let error = stubbedFetchAccountError {
            throw error
        }
        return stubbedFetchAccountResult
    }
}
