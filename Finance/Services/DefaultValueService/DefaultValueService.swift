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
}
