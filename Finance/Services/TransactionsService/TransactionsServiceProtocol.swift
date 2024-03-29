//
//  TransactionsServiceProtocol.swift
//  Finance
//
//  Created by Александр Меренков on 27.06.2023.
//

import Foundation

protocol TransactionsServiceProtocol: AnyObject {
    func fetchTransactions(limit: Int?) throws -> [Transaction]
    func fetchTransactionByMonth() throws -> [Transaction]
    func fetchTransactionsByCategory(for id: UUID) throws -> [Transaction]
    func saveTransaction(_ transaction: Transaction)
    func upload(_ transaction: [Transaction])
    func delete()
}
