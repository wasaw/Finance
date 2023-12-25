//
//  ProgressPresenter.swift
//  Finance
//
//  Created by Александр Меренков on 13.11.2023.
//

import Foundation

enum ProgressSection: Hashable, CaseIterable {
    case section
}

struct ProgressItem: Hashable {
    let id = UUID()
    let title: String
    let isShow: Bool
    let expense: Double
    let currency: Currency
}

final class ProgressPresenter {
    
// MARK: - Properties
    
    weak var input: ProgressInput?
    private let output: ProfilePresenterOutput
    private let defaults = CustomUserDefaults.shared
    private let notification = NotificationCenter.default
    
// MARK: - Lifecycle
    
    init(output: ProfilePresenterOutput) {
        self.output = output
    }
}

// ProgressOutput

extension ProgressPresenter: ProgressOutput {
    func viewIsReady() {
        guard let isShow = defaults.get(for: .isProgress) as? Bool,
              let expense = defaults.get(for: .expenseLimit) as? Double,
              let currency = defaults.get(for: .currency) as? Int,
              let currentCurrency = Currency(rawValue: currency),
              let currencyRate = defaults.get(for: .currencyRate) as? Double else {
            input?.setProgressItem(ProgressItem(title: "Отображать прогресс",
                                                 isShow: false,
                                                 expense: 0,
                                                 currency: Currency.rub))
            return
        }
        input?.setProgressItem(ProgressItem(title: "Отображать прогресс",
                                             isShow: isShow,
                                             expense: expense / currencyRate,
                                             currency: currentCurrency))
    }
    
    func saveExpense(_ expense: String) {
        guard let expense = Double(expense),
              let currencyRate = defaults.get(for: .currencyRate) as? Double else { return }
        defaults.set(expense * currencyRate, key: .expenseLimit)
        notification.post(Notification(name: .updateProgress, object: nil))
    }
    
    func setProgress(_ isOn: Bool) {
        defaults.set(isOn, key: .isProgress)
        notification.post(Notification(name: .updateProgress, object: nil))
    }
}
