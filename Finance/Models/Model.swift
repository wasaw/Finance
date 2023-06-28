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
//    let vc: UIViewController
}
struct ChoiceTypeRevenue: Codable {
    let name: String
    let img: String
    var amount: Double = 0
    var isChecked = false
}
struct ChoiceCategoryExpense: Codable {
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
    let company: String
    var value: Double
    
    init(symbol: String, company: String) {
        self.symbol = symbol
        self.company = company
        self.value = 0
    }
}

// MARK: - Error

enum FileManagerError: Error {
    case fileNotExists
}

extension FileManagerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .fileNotExists:
            return NSLocalizedString("Информация отсутствует", comment: "")
        }
    }
}

enum ResultStatus<T> {
    case success(T)
    case failure(Error)
}

enum RequestError: Error {
    case somethingError
}

extension RequestError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .somethingError:
            return NSLocalizedString("Ошибка. Попробуйте снова.", comment: "")
        }
    }
}

enum CoreDataError: Error {
    case somethingError
}

extension CoreDataError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .somethingError:
            return NSLocalizedString("Ошибка. Попробуйте снова.", comment: "")
        }
    }
}

enum RequestType {
    case exchange
    case stock
}
