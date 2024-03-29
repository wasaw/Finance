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

enum FileManagerError: Error {
    case fileNotExists
    case notRead
}

extension FileManagerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .fileNotExists:
            return NSLocalizedString("Информация отсутствует", comment: "")
        case .notRead:
            return NSLocalizedString("Информация недоступна", comment: "")
        }
    }
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

enum AuthError: Error {
    case invalidPassword
    case noIdentifier
    case emailBadlyFormatted
    case somethingError
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidPassword:
            return NSLocalizedString("Неверный пароль", comment: "")
        case .noIdentifier:
            return NSLocalizedString("Такой почты не существует", comment: "")
        case .emailBadlyFormatted:
            return NSLocalizedString("Неправильный формат почты", comment: "")
        case .somethingError:
            return NSLocalizedString("Ошибка. Попробуйте снова", comment: "")
        }
    }
}

enum ValidError: Error {
    case invalidEmail
    case notAllField
    case notMatchPassword
    case shortPass
}

extension ValidError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return NSLocalizedString("Неверный формат почты", comment: "")
        case .notAllField:
            return NSLocalizedString("Заполнены не все поля", comment: "")
        case .notMatchPassword:
            return NSLocalizedString("Пароли не совпадают", comment: "")
        case .shortPass:
            return NSLocalizedString("Длина пароля минимум 6 символов", comment: "")
        }
    }
}

enum UserLoadError: Error {
    case isEmptyUser
    case somethingError
}

enum TransactionError: Error {
    case notFound
}

enum SaveError: Error {
     case dontSave
}

extension SaveError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .dontSave:
            return NSLocalizedString("Не удалось сохранить", comment: "")
        }
    }
}
