//
//  CategoryServiceMock.swift
//  FinanceUnitTests
//
//  Created by Александр Меренков on 26.12.2023.
//

import Foundation
@testable import Finance

final class CategoryServiceMock: CategoryServiceProtocol {

    var invokedFetchCategories = false
    var invokedFetchCategoriesCount = 0
    var stubbedFetchCategoriesCompletionResult: (Result<[Categories], Error>, Void)?

    func fetchCategories(completion: @escaping (Result<[Categories], Error>) -> Void) {
        invokedFetchCategories = true
        invokedFetchCategoriesCount += 1
        if let result = stubbedFetchCategoriesCompletionResult {
            completion(result.0)
        }
    }

    var invokedFetchCategory = false
    var invokedFetchCategoryCount = 0
    var invokedFetchCategoryParameters: (id: UUID, Void)?
    var invokedFetchCategoryParametersList = [(id: UUID, Void)]()
    var stubbedFetchCategoryError: Error?
    var stubbedFetchCategoryResult: Categories!

    func fetchCategory(for id: UUID) throws -> Categories {
        invokedFetchCategory = true
        invokedFetchCategoryCount += 1
        invokedFetchCategoryParameters = (id, ())
        invokedFetchCategoryParametersList.append((id, ()))
        if let error = stubbedFetchCategoryError {
            throw error
        }
        return stubbedFetchCategoryResult
    }
}
