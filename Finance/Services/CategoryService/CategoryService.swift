//
//  CategoryService.swift
//  Finance
//
//  Created by Александр Меренков on 14.12.2023.
//

import Foundation

struct Categories {
    let id: UUID
    let title: String
    let image: Data
}

struct CategoriesList {
    let id: UUID
    let title: String
    let image: Data
    let amount: Double
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
    func fetchCategories(completion: @escaping (Result<[Categories], Error>) -> Void) {
        do {
            let categoriesManagedObject = try coreData.fetchCategories(nil)
            let categories: [Categories] = categoriesManagedObject.compactMap { category in
                guard let id = category.id,
                      let data = try? fileStore.getImage(id.uuidString),
                      let title = category.title else { return nil }
                
                return Categories(id: id, title: title, image: data)
            }
            completion(.success(categories))
        } catch {
            completion(.failure(error))
        }
    }
    
    func fetchCategory(for id: UUID) throws -> Categories {
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
            return Categories(id: id, title: title, image: data)
        } catch {
            throw error
        }
    }
    
    func fetchCategoriesAmount(completion: @escaping (Result<[CategoriesList], Error>) -> Void) {
        do {
            let categoriesManagedObject = try coreData.fetchCategories(nil)
            let categoriesList: [CategoriesList] = categoriesManagedObject.compactMap { category in
                guard let transactionsManagedObject = category.transactions?.array as? [TransactionManagedObject],
                          let id = category.id,
                          let title = category.title,
                          let data = try? fileStore.getImage(id.uuidString) else { return nil }
                guard !transactionsManagedObject.isEmpty else { return CategoriesList(id: id, title: title, image: data, amount: 0)}
                var amount: Double = 0
                transactionsManagedObject.forEach({ amount += $0.amount })
                return CategoriesList(id: id, title: title, image: data, amount: amount)
            }
            completion(.success(categoriesList))
        } catch {
            completion(.failure(error))
        }
    }
}
