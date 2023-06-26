//
//  FileStore.swift
//  Finance
//
//  Created by Александр Меренков on 23.06.2023.
//

import Foundation

final class FileStore {
    
// MARK: - Properties
    
    private let manager = FileManager.default
}

// MARK: - FileStoreProtocol

extension FileStore: FileStoreProtocol {
    func setAppInformation<T: Codable>(filename: String, file: T) {
        guard let directoryUrl = manager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = directoryUrl.appendingPathComponent(filename).appendingPathExtension("json")
        let jsonEncored = JSONEncoder()
        do {
            let data = try jsonEncored.encode(file)
            try data.write(to: fileUrl)
        } catch {
            print(error)
        }
    }
    
    func readAppInformation<T: Codable>(_ value: String, completion: @escaping(Result<T, FileManagerError>) -> Void) {
        guard let directoryUrl = manager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = directoryUrl.appendingPathComponent(value).appendingPathExtension("json")
        if manager.fileExists(atPath: fileUrl.path) {
            do {
                let fileData = try Data(contentsOf: fileUrl)
                let fileDecode = try JSONDecoder().decode(T.self, from: fileData)
                completion(.success(fileDecode))
            } catch {
                print(error)
            }
        } else {
            completion(.failure(FileManagerError.fileNotExists))
        }
    }
}
