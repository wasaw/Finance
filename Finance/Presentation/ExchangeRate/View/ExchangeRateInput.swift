//
//  ExchangeRateInput.swift
//  Finance
//
//  Created by Александр Меренков on 20.06.2023.
//

import Foundation

protocol ExchangeRateInput: AnyObject {
    func setLoading(enable: Bool)
    func showData(_ exchangeRate: [CurrentExchangeRate], rate: Double)
    func setCurrency(currency: CurrentExchangeRate, requestCurrency: String, rate: Double)
    func showAlert(with title: String, and text: String)
}
