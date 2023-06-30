//
//  ErrorModel.swift
//  Finance
//
//  Created by Александр Меренков on 29.06.2023.
//

import Foundation

enum ConfigFileError: Error {
    case lostFile
}

extension ConfigFileError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .lostFile:
            return NSLocalizedString("Пожалуйста, добавьте конфигурационный файл.", comment: "")
        }
    }
}
