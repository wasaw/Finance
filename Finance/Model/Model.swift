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
    let vc: UIViewController
}
struct ChoiceTypeRevenue {
    let name: String
    let img: String
    var amount: Double = 0
    var isChecked = false
}
struct ChoiceCategoryExpense {
    let name: String
    let img: String
    var isChecked = false
}
struct LastTransaction {
    var type: String = "Зарплата"
    var amount: Double = 0
    var img: String = "other.png"
    var date: Date = Date(timeIntervalSinceNow: 0)
    var comment: String = ""
    var category: String = "Прочее"
}

struct CurrentExchangeRate {
    let name: String
    let amount: Double
    let fullName: String
    let img: String
}


struct AuthCredentials {
    let login: String
    let email: String
    let password: String
    var confirmPass: String = ""
}

struct User {
    let login: String
    let email: String
    var profileImageUrl: URL?
    let uid: String
    var authorized: Bool = true
    
    init(uid: String, dictionary: [String: AnyObject]) {
        self.uid = uid
        self.login = dictionary["login"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        if let profileImageString = dictionary["profileImageUrl"] as? String {
            guard let url = URL(string: profileImageString) else { return }
            self.profileImageUrl = url
        }
    }
    
    init(uid: String, login: String, email: String, profileImageUrl: String, authorized: Bool) {
        self.uid = uid
        self.login = login
        self.email = email
        self.authorized = authorized
        if profileImageUrl != "" {
            self.profileImageUrl = URL(string: profileImageUrl)
        }
    }
}

enum Currency: String {
    case rub = "рубли"
    case dollar = "доллары"
    case euro = "евро"
    
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
}

struct Stock {
    let symbol: String
    var value: Double
    
    init(symbol: String) {
        self.symbol = symbol
        self.value = 0
    }
}

//  MARK: - Decodable

struct ConversionRates: Decodable {
    let result: String
    let conversion_rates: CurrencyJson
}

struct CurrencyJson: Decodable, Sequence {
    let BGN: Double
    let CZK: Double
    let EUR: Double
    let GBP: Double
    let KZT: Double
    let NZD: Double
    let RUB: Double
    let USD: Double
 
    func makeIterator() -> CurrencyJsonIterator {
        return CurrencyJsonIterator(currency: self)
    }
}

struct CurrencyJsonIterator: IteratorProtocol {
    typealias Element = (String, Double)
    private var index = 0
    private var amountArray = [Double]()
    private var nameArray = [String]()

    init(currency: CurrencyJson) {
        self.amountArray.append(currency.BGN)
        self.amountArray.append(currency.CZK)
        self.amountArray.append(currency.EUR)
        self.amountArray.append(currency.GBP)
        self.amountArray.append(currency.KZT)
        self.amountArray.append(currency.NZD)
        self.amountArray.append(currency.RUB)
        self.amountArray.append(currency.USD)
        
        self.nameArray.append("BGN")
        self.nameArray.append("CZK")
        self.nameArray.append("EUR")
        self.nameArray.append("GBP")
        self.nameArray.append("KZT")
        self.nameArray.append("NZD")
        self.nameArray.append("RUB")
        self.nameArray.append("USD")
    }

    mutating func next() -> CurrencyJsonIterator.Element? {
        if index < amountArray.count {
            let answer = (nameArray[index], amountArray[index])
            index += 1
            return answer
        }
        return nil
    }
}


struct StockRate: Decodable {
    let queryCount: Int
    let results: [StockItem]
}

struct StockItem: Decodable {
    let symbol: String
    let value: Double
    
    enum CodingKeys: String, CodingKey {
        case symbol = "T"
        case value = "c"
    }
}
