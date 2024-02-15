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
    private let userDefaults = CustomUserDefaults.shared
    private let notification = NotificationCenter.default

// MARK: - Lifecycle

    init(moduleOutput: ChartPresenterOutput, categoryService: CategoryServiceProtocol) {
        self.moduleOutput = moduleOutput
        self.categoryService = categoryService
        
        registerNotification()
    }
    
// MARK: - Helpers
    
    private func registerNotification() {
        notification.addObserver(self, selector: #selector(updateCurrency), name: .updateCurrency, object: nil)
    }
    
    private func prepareTableData(_ categories: [CategoriesList]) {
        guard let currency = userDefaults.get(for: .currency) as? Int,
              let currencyRate = userDefaults.get(for: .currencyRate) as? Double,
              let currentCurrency = Currency(rawValue: currency)?.symbol else { return }
       
        let displayData = categories.compactMap({ ChartCell.DisplayData(image: $0.image,
                                                                        title: $0.title,
                                                                        amount: String(Int(abs($0.amount / currencyRate))) + " \(currentCurrency)") })
        input?.setLoading(enable: false)
        input?.showData(displayData)
    }
    
    private func preparePieData(_ categories: [CategoriesList]) {
         guard let currencyRate = userDefaults.get(for: .currencyRate) as? Double else { return }
        var isEmptyValue = true
        var entries: [PieChartDataEntry] = Array()
        categories.forEach({
            entries.append(PieChartDataEntry(value: abs($0.amount / currencyRate), label: $0.title))
            if $0.amount != 0 {
                isEmptyValue = false
            }
        })
        let dataSet = PieChartDataSet(entries: entries)
        dataSet.valueTextColor = .white
        dataSet.colors = [.brown, .orange, .purple]
        input?.setLoading(enable: false)
        if isEmptyValue {
            input?.hideChart()
        } else {
            input?.showPieData(dataSet)
        }
    }
    
// MARK: - Selectors
    
    @objc private func updateCurrency() {
        viewIsReady()
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
