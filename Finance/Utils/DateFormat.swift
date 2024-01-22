//
//  DateFormat.swift
//  Finance
//
//  Created by Александр Меренков on 22.01.2024.
//

import Foundation

final class DateFormat {
    static let shared = DateFormat()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    func formatter(from date: Date) -> String {
        return dateFormatter.string(from: date)
    }
}
