//
//  CategoryService.swift
//  Finance
//
//  Created by Александр Меренков on 14.12.2023.
//

import Foundation

struct Category {
    let id: UUID
    let title: String
}

final class CategoryService {
    
// MARK: - Properties
    
    private let coreData: CoreDataServiceProtocol
    
// MARK: - Lifecycle
    
    init(coreData: CoreDataServiceProtocol) {
        self.coreData = coreData
    }
}

// MARK: - CategoryServiceProtocol

extension CategoryService: CategoryServiceProtocol {
    func fetchCategory(completion: @escaping (Result<[Category], Error>) -> Void) {
        do {
            let categoriesManagedObject = try coreData.fetchCategories()
            let categories: [Category] = categoriesManagedObject.compactMap { category in
                guard let id = category.id,
                      let title = category.title else { return nil }
                return Category(id: id, title: title)
            }
            completion(.success(categories))
        } catch {
            completion(.failure(error))
        }
    }
}
