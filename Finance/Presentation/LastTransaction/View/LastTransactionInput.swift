//
//  LastTransactionInput.swift
//  Finance
//
//  Created by Александр Меренков on 19.06.2023.
//

import Foundation

protocol LastTransactionInput: AnyObject {
    func showData(transaction: LastTransaction, currency: Currency, rate: Double)
}
