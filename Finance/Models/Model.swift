//
//  Model.swift
//  Finance
//
//  Created by Александр Меренков on 16.06.2022.
//

import UIKit

struct ChoiceService {
    let name: String
    let img: String
}
struct ChoiceTypeRevenue: Codable {
    let name: String
    let img: String
    var amount: Double = 0
}
struct ChoiceCategoryExpense: Codable {
    let name: String
    let img: String
}
struct Transaction {
    var type: String
    var amount: Double
    var img: String
    var date: Date
    var comment: String
    var category: String
}

struct SaveTransaction {
    let amount: String?
    let date: Date
    let comment: String?
}

struct CurrentExchangeRate {
    let name: String
    let amount: Double
    let fullName: String
    let img: String
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
    let login: String
    let email: String
    var profileImage: UIImage?
    let uid: String
    
    init(uid: String, dictionary: [String: AnyObject]) {
        self.uid = uid
        self.login = dictionary["login"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.profileImage = nil
    }
    
    init(uid: String, login: String, email: String, profileImage: UIImage? = nil) {
        self.uid = uid
        self.login = login
        self.email = email
        self.profileImage = profileImage
    }
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
}

enum RequestType {
    case exchange
    case stock
}

struct CurrencyButton {
    let title: String
    let image: String
    let displayCurrency: Currency
    var isSelected: Bool
}
