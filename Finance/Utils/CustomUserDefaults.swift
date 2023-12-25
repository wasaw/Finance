//
//  CustomUserDefaults.swift
//  Finance
//
//  Created by Александр Меренков on 25.12.2023.
//

import Foundation

final class CustomUserDefaults {
    static let shared = CustomUserDefaults()
    
// MARK: - Properties
    
    private let defaults = UserDefaults.standard
    
    enum DefaultsKey: String {
        case isFirstLaunce
        case uid
        case currencyRate
        case currency
        case isProgress
        case expenseLimit
        case urlString
    }
    
// MARK: - Helpers
    
    func set(_ value: Any?, key: DefaultsKey) {
        defaults.set(value, forKey: key.rawValue)
    }
    
    func get(for key: DefaultsKey) -> Any? {
        return defaults.value(forKey: key.rawValue)
    }
}
