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
    let image: Data
}

final class CategoryService {
    
// MARK: - Properties
    
    private let fileStore: FileStoreProtocol
    private let coreData: CoreDataServiceProtocol
    
// MARK: - Lifecycle
    
    init(fileStore: FileStoreProtocol, coreData: CoreDataServiceProtocol) {
        self.fileStore = fileStore
        self.coreData = coreData
    }
}

// MARK: - CategoryServiceProtocol

extension CategoryService: CategoryServiceProtocol {
    func fetchCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
        do {
            let categoriesManagedObject = try coreData.fetchCategories(nil)
            let categories: [Category] = categoriesManagedObject.compactMap { category in
                guard let id = category.id,
                      let data = try? fileStore.getImage(id.uuidString),
                      let title = category.title else { return nil }
                
                return Category(id: id, title: title, image: data)
            }
            completion(.success(categories))
        } catch {
            completion(.failure(error))
        }
    }
    
    func fetchCategory(for id: UUID) throws -> Category {
        do {
            let categoriesManagedObject = try coreData.fetchCategories(id).first
            guard
                let category = categoriesManagedObject,
                let id = category.id,
                let data = try? fileStore.getImage(id.uuidString),
                let title = category.title
            else {
                throw TransactionError.notFound
            }
            return Category(id: id, title: title, image: data)
        } catch {
            throw error
        }
    }
}
