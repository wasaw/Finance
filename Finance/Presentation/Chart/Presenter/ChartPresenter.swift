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
    private weak var moduleOutput: ChartPresenterOutput?
    private let categoryService: CategoryServiceProtocol
    private var categories = [CategoriesList]()

// MARK: - Lifecycle

    init(moduleOutput: ChartPresenterOutput, categoryService: CategoryServiceProtocol) {
        self.moduleOutput = moduleOutput
        self.categoryService = categoryService
    }
    
// MARK: - Helpers
    
    private func prepareTableData(_ categories: [CategoriesList]) {
        let displayData = categories.compactMap({ ChartCell.DisplayData(image: $0.image, title: $0.title, amount: String(abs($0.amount))) })
        input?.setLoading(enable: false)
        input?.showData(displayData)
    }
    
    private func preparePieData(_ categories: [CategoriesList]) {
        var entries: [PieChartDataEntry] = Array()
        categories.forEach({ entries.append(PieChartDataEntry(value: abs($0.amount), label: $0.title)) })
        let dataSet = PieChartDataSet(entries: entries)
        dataSet.valueTextColor = .white
        dataSet.colors = [.brown, .orange, .purple]
        input?.setLoading(enable: false)
        input?.showPieData(dataSet)
    }
}

// MARK: - ChartOutput

extension ChartPresenter: ChartOutput {
    func viewIsReady() {
        input?.setLoading(enable: true)
        categoryService.fetchCategoriesAmount { [weak self] result in
            switch result {
            case .success(let categories):
                self?.categories = categories
                self?.prepareTableData(categories)
                self?.preparePieData(categories)
            case .failure(let error):
                self?.input?.showAlert(error.localizedDescription)
            }
        }
    }
    
    func didSelectItem(at index: Int) {
        guard categories.indices.contains(index) else { return }
        moduleOutput?.showAllTransactions(for: categories[index].id)
    }
}
