//
//  TransactionsServiceProtocol.swift
//  Finance
//
//  Created by Александр Меренков on 27.06.2023.
//

import Foundation

protocol TransactionsServiceProtocol: AnyObject {
    func fetchTransactions() throws -> [Transaction]
    func fetchAmountBy(_ predicate: String) throws -> Double
    func saveTransaction(_ transaction: Transaction)
    func upload(_ transaction: [Transaction])
    func delete()
}
