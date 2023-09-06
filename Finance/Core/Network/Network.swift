//
//  Network.swift
//  Finance
//
//  Created by Александр Меренков on 22.06.2023.
//

import Foundation

final class Network {
    
// MARK: - Properties
    
    private let session = URLSession(configuration: .default)
    private let decoder = JSONDecoder()
    
// MARK: - Lifecycle
    
    init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
}

// MARK: - NetworkProtocol

extension Network: NetworkProtocol {
    func loadData<T: Decodable>(request: URLRequest, completion: @escaping(Result<T, Error>) -> Void) {
        let dataTask = session.dataTask(with: request) { [weak self] data, _, error in
            if let error = error {
                completion(.failure(error))
            }

            if let data = data {
                do {
                    guard let decodeData = try self?.decoder.decode(T.self, from: data) else { return }
                    completion(.success(decodeData))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        dataTask.resume()
    }
}
