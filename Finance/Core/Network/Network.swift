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
    private let decoder: JSONDecoder
    private let urlCache: URLCache
    private let cachePolice: CachePolice
    private let userDefault: UserDefaults
    
// MARK: - Lifecycle
    
    init() {
        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        urlCache = URLCache()
        cachePolice = .cacheToDisk(.oneMinute)
        userDefault = UserDefaults.standard
    }
    
// MARK: - Helpers
    
    private func cacheLoadedData(urlRequest: URLRequest, cachedURLResponse: CachedURLResponse) {
        switch cachePolice {
        case .cacheToDisk(let cacheTime):
            guard let urlString = urlRequest.url?.absoluteString else { return }
            
            userDefault.set(cacheTime.rawValue + Date.timeIntervalSinceReferenceDate, forKey: urlString)
            urlCache.storeCachedResponse(cachedURLResponse, for: urlRequest)
        }
    }
    
    private func cachedData(urlRequest: URLRequest) -> Data? {
        guard let urlString = urlRequest.url?.absoluteString,
              let expirationTimestamp = userDefault.object(forKey: urlString) as? TimeInterval else {
            return nil
        }
        
        guard expirationTimestamp > Date.timeIntervalSinceReferenceDate else {
            userDefault.removeObject(forKey: urlString)
            return nil
        }
        
        return urlCache.cachedResponse(for: urlRequest)?.data
    }
}

// MARK: - NetworkProtocol

extension Network: NetworkProtocol {
    func loadData<T: Decodable>(request: URLRequest, completion: @escaping(Result<T, Error>) -> Void) {
        if let cachedData = cachedData(urlRequest: request) {
            guard let decodedData = try? decoder.decode(T.self, from: cachedData) else { return }
            completion(.success(decodedData))
        } else {
            let dataTask = session.dataTask(with: request) { [weak self] data, response, error in
                if let error = error {
                    completion(.failure(error))
                }
                
                guard let urlResponse = response as? HTTPURLResponse,
                      (200...299).contains(urlResponse.statusCode) else {
                    return
                }

                if let data = data {
                    do {
                        guard let decodeData = try self?.decoder.decode(T.self, from: data) else { return }
                        
                        self?.cacheLoadedData(urlRequest: request,
                                              cachedURLResponse: CachedURLResponse(response: urlResponse, data: data))
                        completion(.success(decodeData))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func loadImage(request: URLRequest, completion: @escaping(Result<Data, Error>) -> Void) {
        let dataTask = session.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }

            if let data = data {
                completion(.success(data))
            }
        }
        dataTask.resume()
    }
}
