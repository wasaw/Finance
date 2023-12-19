//
//  HomeInput.swift
//  Finance
//
//  Created by Александр Меренков on 10.06.2023.
//

import Foundation

protocol HomeInput: AnyObject {
    func showLastTransactions(_ transactions: [TransactionCellModel])
    func showAlert(message: String)
    func setUserName(_ name: String)
    func showService(_ service: [ChoiceService])
    func showTotal(_ total: String)
    func showProgress(_ progress: Progress)
}
