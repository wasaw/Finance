//
//  ChartPresenter.swift
//  Finance
//
//  Created by Александр Меренков on 11.01.2024.
//

import Foundation
import DGCharts

final class ChartPresenter {
    
// MARK: - Properties
    
    weak var input: ChartInput?
    private let categoryService: CategoryServiceProtocol

// MARK: - Lifecycle

    init(categoryService: CategoryServiceProtocol) {
        self.categoryService = categoryService
    }
    
// MARK: - Helpers
    
    private func prepareTableData(_ categories: [CategoriesList]) {
        let displayData = categories.compactMap({ ChartCell.DisplayData(image: $0.image, title: $0.title, amount: String(abs($0.amount))) })
        input?.showData(displayData)
    }
    
    private func preparePieData(_ categories: [CategoriesList]) {
        var entries: [PieChartDataEntry] = Array()
        categories.forEach({ entries.append(PieChartDataEntry(value: abs($0.amount))) })
        let dataSet = PieChartDataSet(entries: entries)
        dataSet.valueTextColor = .black
        dataSet.colors = [.cyan, .orange, .blue, .magenta, .purple]
        input?.showPieData(dataSet)
    }
}

// MARK: - ChartOutput

extension ChartPresenter: ChartOutput {
    func viewIsReady() {
        categoryService.fetchCategoriesAmount { [weak self] result in
            switch result {
            case .success(let categories):
                self?.prepareTableData(categories)
                self?.preparePieData(categories)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
