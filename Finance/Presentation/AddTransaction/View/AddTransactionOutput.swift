//
//  AddTransactionOutput.swift
//  Finance
//
//  Created by Александр Меренков on 16.06.2023.
//

import Foundation

protocol AddTransactionOutput: AnyObject {
    func viewIsReady()
    func saveTransaction(_ transaction: LastTransaction)
}
