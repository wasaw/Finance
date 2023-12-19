//
//  FileStoreProtocol.swift
//  Finance
//
//  Created by Александр Меренков on 23.06.2023.
//

import Foundation

protocol FileStoreProtocol: AnyObject {
    func setAppInformation<T: Codable>(filename: String, file: T)
    func readAppInformation<T: Codable>(_ value: String, completion: @escaping(Result<T, FileManagerError>) -> Void)
    func saveImage(data: Data, with name: String, completion: @escaping ((Result<Data, Error>) -> Void))
//    func getImage(_ uid: String, completion: @escaping ((Result<Data, Error>) -> Void))
    func getImage(_ uid: String) throws -> Data
}
