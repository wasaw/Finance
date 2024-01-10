//
//  NetworkConfiguration.swift
//  Finance
//
//  Created by Александр Меренков on 31.01.2023.
//

import Foundation

protocol RequestBuilderProtocol: AnyObject {
    func build(request: NetworkRequestProtocol) throws -> URLRequest
}

final class RequestBuilder: RequestBuilderProtocol {
    static let shared = RequestBuilder()
    
    func build(request: NetworkRequestProtocol) throws -> URLRequest {
        guard let url = URL(string: "https://\(request.host)\(request.path)") else {
            throw NetworkError.cantBuildUrl
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod.rawValue
        return urlRequest
    }
}
