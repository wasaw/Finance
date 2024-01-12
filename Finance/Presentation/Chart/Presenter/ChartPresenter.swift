//
//  ChartPresenter.swift
//  Finance
//
//  Created by Александр Меренков on 11.01.2024.
//

import Foundation

final class ChartPresenter {
    
// MARK: - Properties
    
    weak var input: ChartInput?
    private let categoryService: CategoryServiceProtocol

// MARK: - Lifecycle

    init(categoryService: CategoryServiceProtocol) {
        self.categoryService = categoryService
    }
}

// MARK: - ChartOutput

extension ChartPresenter: ChartOutput {
    func viewIsReady() {
        categoryService.fetchCategoriesAmount { [weak self] result in
            switch result {
            case .success(let categories):
                let displayData = categories.compactMap({ ChartCell.DisplayData(image: $0.image, title: $0.title, amount: String(abs($0.amount))) })
                self?.input?.showData(displayData)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
