//
//  Currency.swift
//  Finance
//
//  Created by Александр Меренков on 21.10.2022.
//

class CurrencyRate {
    static var usd = 56.3
    static var eur = 65.2
    static var currentCurrency: Currency = .rub
    static var rate: Double {
        get {
            switch currentCurrency {
            case .rub:
                return 1
            case .dollar:
                return usd
            case .euro:
                return eur
            }
        }
    }
}
