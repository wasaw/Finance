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
    private let userDefaults = UserDefaults.standard
    private let notification = NotificationCenter.default
    
// MARK: - Lifecycle
    
    init(output: ProfilePresenterOutput) {
        self.output = output
    }
}

// ProgressOutput

extension ProgressPresenter: ProgressOutput {
    func viewIsReady() {
        guard let isShow = userDefaults.value(forKey: "isProgress") as? Bool,
              let expense = userDefaults.value(forKey: "expenseLimit") as? Double,
              let currency = userDefaults.value(forKey: "currency") as? Int,
              let currentCurrency = Currency(rawValue: currency),
              let currencyRate = userDefaults.value(forKey: "currencyRate") as? Double else {
            input?.setProgressItem([ProgressItem(title: "Отображать прогресс",
                                                 isShow: false,
                                                 expense: 0,
                                                 currency: Currency.rub)])
            return
        }
        input?.setProgressItem([ProgressItem(title: "Отображать прогресс",
                                             isShow: isShow,
                                             expense: expense / currencyRate,
                                             currency: currentCurrency)])
    }
    
    func saveExpense(_ expense: String) {
        guard let expense = Double(expense),
        let currencyRate = userDefaults.value(forKey: "currencyRate") as? Double else { return }
        userDefaults.set(expense * currencyRate, forKey: "expenseLimit")
        notification.post(Notification(name: .updateProgress, object: nil))
    }
    
    func setProgress(_ isOn: Bool) {
        userDefaults.set(isOn, forKey: "isProgress")
    }
}
