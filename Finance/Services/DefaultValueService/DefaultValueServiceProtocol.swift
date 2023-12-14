//
//  DefaultValueServiceProtocol.swift
//  Finance
//
//  Created by Александр Меренков on 28.06.2023.
//

import Foundation

protocol DefaultValueServiceProtocol: AnyObject {
    func saveValue()
    func fetchValue() throws -> ([ChoiceCategoryExpense], [ChoiceTypeRevenue])
    func fetchStocks() -> [Stock]
    func fetchExchangeValue() -> ([String], [String])
}
