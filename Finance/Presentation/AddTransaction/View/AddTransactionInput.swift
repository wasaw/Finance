//
//  AddTransactionInput.swift
//  Finance
//
//  Created by Александр Меренков on 16.06.2023.
//

import Foundation

protocol AddTransactionInput: AnyObject {
    func showData(category: [ChoiceCategoryExpense], revenue: [ChoiceTypeRevenue])
    func dismissView()
    func showAlert(with title: String, and text: String)
}
