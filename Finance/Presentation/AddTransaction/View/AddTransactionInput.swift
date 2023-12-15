//
//  AddTransactionInput.swift
//  Finance
//
//  Created by Александр Меренков on 16.06.2023.
//

import Foundation

protocol AddTransactionInput: AnyObject {
    func setAccount(_ account: [AccountCellModel])
    func setCategory(_ categories: [CategoryCellModel])
    func dismissView()
    func showAlert(with title: String, and text: String)
}
