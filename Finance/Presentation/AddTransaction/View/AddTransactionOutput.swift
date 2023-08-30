//
//  AddTransactionOutput.swift
//  Finance
//
//  Created by Александр Меренков on 16.06.2023.
//

import Foundation

protocol AddTransactionOutput: AnyObject {
    func viewIsReady()
    func selectedRevenue(_ index: Int)
    func selectedCategory(_ index: Int)
    func isRevenue(_ value: Bool)
    func saveTransaction(_ transaction: SaveTransaction)
}
