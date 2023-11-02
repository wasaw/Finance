//
//  NetworkRequestProtocol.swift
//  Finance
//
//  Created by Александр Меренков on 02.11.2023.
//

import Foundation

protocol NetworkRequestProtocol: AnyObject {
    var httpMethod: HTTPMethod { get }
    var host: String { get }
    var path: String { get }
    var requestValue: String { get set }
}

enum HTTPMethod: String {
    case get = "GET"
}
