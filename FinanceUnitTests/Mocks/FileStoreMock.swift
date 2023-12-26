//
//  FileStoreMock.swift
//  FinanceUnitTests
//
//  Created by Александр Меренков on 03.08.2023.
//

import Foundation
@testable import Finance

final class FileStoreMock: FileStoreProtocol {

    var invokedSetAppInformation = false
    var invokedSetAppInformationCount = 0
    var invokedSetAppInformationParameters: (filename: String, file: Any)?
    var invokedSetAppInformationParametersList = [(filename: String, file: Any)]()

    func setAppInformation<T: Codable>(filename: String, file: T) {
        invokedSetAppInformation = true
        invokedSetAppInformationCount += 1
        invokedSetAppInformationParameters = (filename, file)
        invokedSetAppInformationParametersList.append((filename, file))
    }

    var invokedReadAppInformation = false
    var invokedReadAppInformationCount = 0
    var invokedReadAppInformationParameters: (value: String, Void)?
    var invokedReadAppInformationParametersList = [(value: String, Void)]()
    var stubbedReadAppInformationCompletionResult: (Result<T, FileManagerError>, Void)?
    typealias T = Any

    func readAppInformation<T: Codable>(_ value: String, completion: @escaping(Result<T, FileManagerError>) -> Void) {
        invokedReadAppInformation = true
        invokedReadAppInformationCount += 1
        invokedReadAppInformationParameters = (value, ())
        invokedReadAppInformationParametersList.append((value, ()))
        if let result = stubbedReadAppInformationCompletionResult {
            completion(result.0 as! Result<T, FileManagerError>)
        }
    }

    var invokedSaveImage = false
    var invokedSaveImageCount = 0
    var invokedSaveImageParameters: (data: Data, name: String)?
    var invokedSaveImageParametersList = [(data: Data, name: String)]()
    var stubbedSaveImageCompletionResult: (Result<Data, Error>, Void)?

    func saveImage(data: Data, with name: String, completion: @escaping ((Result<Data, Error>) -> Void)) {
        invokedSaveImage = true
        invokedSaveImageCount += 1
        invokedSaveImageParameters = (data, name)
        invokedSaveImageParametersList.append((data, name))
        if let result = stubbedSaveImageCompletionResult {
            completion(result.0)
        }
    }

    var invokedGetImage = false
    var invokedGetImageCount = 0
    var invokedGetImageParameters: (uid: String, Void)?
    var invokedGetImageParametersList = [(uid: String, Void)]()
    var stubbedGetImageError: Error?
    var stubbedGetImageResult: Data!

    func getImage(_ uid: String) throws -> Data {
        invokedGetImage = true
        invokedGetImageCount += 1
        invokedGetImageParameters = (uid, ())
        invokedGetImageParametersList.append((uid, ()))
        if let error = stubbedGetImageError {
            throw error
        }
        return stubbedGetImageResult
    }
}
