//
//  CategoryServiceProtocol.swift
//  Finance
//
//  Created by Александр Меренков on 14.12.2023.
//

import Foundation

protocol CategoryServiceProtocol: AnyObject {
    func fetchCategories(completion: @escaping (Result<[Categories], Error>) -> Void)
    func fetchCategory(for id: UUID) throws -> Categories
    func fetchCategoriesAmount(completion: @escaping (Result<[CategoriesList], Error>) -> Void)
}
