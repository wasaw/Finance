//
//  TransactionsServiceProtocol.swift
//  Finance
//
//  Created by Александр Меренков on 27.06.2023.
//

import Foundation

protocol TransactionsServiceProtocol: AnyObject {
    func fetchTransactions() throws -> [Transaction]
    func saveTransaction(_ transaction: Transaction)
}
