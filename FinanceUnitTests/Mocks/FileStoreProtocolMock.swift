//
//  FileStoreProtocolMock.swift
//  FinanceUnitTests
//
//  Created by Александр Меренков on 03.08.2023.
//

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
 // swiftlint:disable type_name
    typealias T = Any
 // swiftlint:enable type_name
    
    var stubbedReadAppInformationCompletionResult: (Result<T, FileManagerError>, Void)?

    func readAppInformation<T: Codable>(_ value: String, completion: @escaping(Result<T, FileManagerError>) -> Void) {
        invokedReadAppInformation = true
        invokedReadAppInformationCount += 1
        invokedReadAppInformationParameters = (value, ())
        invokedReadAppInformationParametersList.append((value, ()))
        if let result = stubbedReadAppInformationCompletionResult {
 // swiftlint:disable force_cast
            completion(result.0 as! Result<T, FileManagerError>)
 // swiftlint:enable force_cast
        }
    }
}
