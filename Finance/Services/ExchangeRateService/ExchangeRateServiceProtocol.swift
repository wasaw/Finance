//
//  ExchangeRateServiceProtocol.swift
//  Finance
//
//  Created by Александр Меренков on 15.08.2023.
//

import Foundation

protocol ExchangeRateServiceProtocol: AnyObject {
    func fetchExchangeRate(_ requestCurrency: String, completion: @escaping (ResultStatus<[CurrentExchangeRate]>) -> Void)
}
