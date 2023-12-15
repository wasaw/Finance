//
//  CategoryServiceProtocol.swift
//  Finance
//
//  Created by Александр Меренков on 14.12.2023.
//

import Foundation

protocol CategoryServiceProtocol: AnyObject {
    func fetchCategory(completion: @escaping (Result<[Category], Error>) -> Void)
}
