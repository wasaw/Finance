//
//  Model.swift
//  Finance
//
//  Created by Александр Меренков on 16.06.2022.
//

import UIKit

struct Account {
    let id: UUID
    let title: String
    let amount: Double
    let image: Data
}

struct ChoiceService {
    let name: String
    let img: String
    let type: TypeService
}

enum TypeService: Int {
    case exchange
    case stocks
    case atm
    case news
}

struct Transaction {
    let account: UUID
    let category: UUID
    let amount: Double
    let date: Date
    let comment: String
}

struct CurrentExchangeRate {
    let name: String
    let amount: Double
    let fullName: String
    let img: String
    
    var amountOutput: String {
        guard let currencyRate = UserDefaults.standard.value(forKey: "currencyRate") as? Double else {
            return String(format: "%.2f", amount)
        }
        return String(format: "%.2f", amount / currencyRate)
    }
}

struct AuthCredentials {
    let email: String
    let password: String
}

struct RegCredentials {
    let login: String
    let email: String
    let password: String
    var confirmPass: String
}

struct User {
    let uid: String
    let login: String
    let email: String
    var profileImage: Data?
    
//    init(uid: String, dictionary: [String: AnyObject]) {
//        self.uid = uid
//        self.login = dictionary["login"] as? String ?? ""
//        self.email = dictionary["email"] as? String ?? ""
//        self.profileImage = nil
//    }
}

enum Currency: Int {
    case rub
    case dollar
    case euro
    
    func getMark() -> String {
        switch self {
        case .rub:
            return " ₽"
        case .dollar:
            return " $"
        case .euro:
            return " €"
        }
    }
    
    func getDescription() -> String {
        switch self {
        case .rub:
            return "рубли"
        case .dollar:
            return "доллары"
        case .euro:
            return "евро"
        }
    }
    
    func forRequest() -> String {
        switch self {
        case .rub:
            return "RUB"
        case .dollar:
            return "USD"
        case .euro:
            return "EUR"
        }
    }
}

struct Stock: Codable {
    let symbol: String
    let company: String
    var value: Double
    
    init(symbol: String, company: String) {
        self.symbol = symbol
        self.company = company
        self.value = 0
    }
    
    var valueOutput: String {
        guard let currencyRate = UserDefaults.standard.value(forKey: "currencyRate") as? Double else {
            return String(format: "%.2f", value)
        }
        return String(format: "%.2f", value / currencyRate)
    }
}

struct CurrencyButton {
    let title: String
    let image: String
    let displayCurrency: Currency
    var isSelected: Bool
}

struct News {
    let title: String
    let descriptin: String
    let url: URL
    let imageUrl: URL
    let publishedAt: String
}

struct Progress {
    let amount: Double
    let purpose: Double
    let currentDay: Int
    let currency: Currency
    var ratio: Float {
        Float(amount / purpose)
    }
    let currencyRate: Double
    var amountOutput: String {
        return String(format: "%.2f", amount / currencyRate)
    }
    var purposeOutput: String {
        return String(format: "%.2f", purpose / currencyRate)
    }
}
