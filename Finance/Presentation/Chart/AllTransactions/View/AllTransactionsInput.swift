//
//  AllTransactionsInput.swift
//  Finance
//
//  Created by Александр Меренков on 16.01.2024.
//

import Foundation

protocol AllTransactionsInput: AnyObject {
    func setLoading(enable: Bool)
    func showData(_ displayData: [AllTransactionsCell.DisplayData])
    func showAlert(_ message: String)
}
