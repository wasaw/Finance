//
//  DefaultValueService.swift
//  Finance
//
//  Created by Александр Меренков on 28.06.2023.
//

import Foundation

final class DefaultValueService {
    
// MARK: - Properties
    
    private let fileStore: FileStoreProtocol
    
// MARK: - Lifecycle
    
    init(fileStore: FileStoreProtocol) {
        self.fileStore = fileStore
    }
    
}

// MARK: - DefaultValueServiceProtocol

extension DefaultValueService: DefaultValueServiceProtocol {
    func fetchValue() throws -> ([ChoiceCategoryExpense], [ChoiceTypeRevenue]) {
        var category = [ChoiceCategoryExpense]()
        var revenue = [ChoiceTypeRevenue]()
        
        fileStore.readAppInformation("category") { (result: Result<[ChoiceCategoryExpense], FileManagerError>) in
            switch result {
            case .success(let answer):
                category = answer
            case .failure:
                break
            }
        }
        
        fileStore.readAppInformation("revenue") { (result: Result<[ChoiceTypeRevenue], FileManagerError>) in
            switch result {
            case .success(let answer):
                revenue = answer
            case .failure:
                break
            }
        }
        
        return (category, revenue)
    }
    
    func fetchStocks() -> [Stock] {
        var stocks = [Stock]()
        fileStore.readAppInformation("stocks") { (result: Result<[Stock], FileManagerError>) in
            switch result {
            case .success(let answer):
                stocks = answer
            case .failure:
                break
            }
        }
        return stocks
    }
    
    func fetchExchangeValue() -> ([String], [String]) {
        var fullName = [String]()
        var img = [String]()
        
        fileStore.readAppInformation("exchangeFullName") { (result: Result<[String], FileManagerError>) in
            switch result {
            case .success(let answer):
                fullName = answer
            case .failure:
                break
            }
        }
        
        fileStore.readAppInformation("exchangeImg") { (result: Result<[String], FileManagerError>)  in
            switch result {
            case .success(let answer):
                img = answer
            case .failure:
                break
            }
        }
        return (fullName, img)
    }
}
