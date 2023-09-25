//
//  NetworkProtocol.swift
//  Finance
//
//  Created by Александр Меренков on 22.06.2023.
//

import Foundation

protocol NetworkProtocol: AnyObject {
    func loadData<T: Decodable>(request: URLRequest, completion: @escaping(Result<T, Error>) -> Void)
    func loadImage(request: URLRequest, completion: @escaping(Result<Data, Error>) -> Void)
}
