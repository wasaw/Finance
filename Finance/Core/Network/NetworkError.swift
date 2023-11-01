//
//  NetworkError.swift
//  Finance
//
//  Created by Александр Меренков on 01.11.2023.
//

import Foundation

enum NetworkError: Error {
    case cantBuildUrl
    case noConnection
    case timeout
}
