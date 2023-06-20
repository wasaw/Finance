//
//  ExchangeRateInput.swift
//  Finance
//
//  Created by Александр Меренков on 20.06.2023.
//

import Foundation

protocol ExchangeRateInput: AnyObject {
    func setLoading(enable: Bool)
    func showData(_ exchangeRate: [CurrentExchangeRate])
    func setTotalAccount(_ total: Double)
    func setCurrency(currency: CurrentExchangeRate, requestCurrency: String)
    func showAlert(with title: String, and text: String)
}
