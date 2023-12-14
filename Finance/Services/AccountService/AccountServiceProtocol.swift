//
//  AccountServiceProtocol.swift
//  Finance
//
//  Created by Александр Меренков on 14.12.2023.
//

import Foundation

protocol AccountServiceProtocol: AnyObject {
    func fetchAccounts(completion: @escaping (Result<[Account], Error>) -> Void)
}
