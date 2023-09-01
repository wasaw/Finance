//
//  FileStoreProtocolMock.swift
//  FinanceUnitTests
//
//  Created by Александр Меренков on 03.08.2023.
//

import Foundation
@testable import Finance

final class FileStoreProtocolMock: FileStoreProtocol {

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
    typealias T = Any
    var stubbedReadAppInformationCompletionResult: (Result<T, FileManagerError>, Void)?

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
    var stubbedSaveImageCompletionResult: (Result<Void, Error>, Void)?

    func saveImage(data: Data, with name: String, completion: @escaping ((Result<Void, Error>) -> Void)) {
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
    var stubbedGetImageCompletionResult: (Result<Data, Error>, Void)?

    func getImage(_ uid: String, completion: @escaping ((Result<Data, Error>) -> Void)) {
        invokedGetImage = true
        invokedGetImageCount += 1
        invokedGetImageParameters = (uid, ())
        invokedGetImageParametersList.append((uid, ()))
        if let result = stubbedGetImageCompletionResult {
            completion(result.0)
        }
    }
}
