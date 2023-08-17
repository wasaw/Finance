//
//  HomeInput.swift
//  Finance
//
//  Created by Александр Меренков on 10.06.2023.
//

import Foundation

protocol HomeInput: AnyObject {
    func showData(total: Double,
                  currency: Currency,
                  rate: Double,
                  service: [ChoiceService],
                  lastTransaction: [LastTransaction])
    func showLastTransaction()
    func showAlert(message: String)
    func setUserName(_ name: String)
}
