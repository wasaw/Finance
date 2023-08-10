//
//  UserServiceProtocol.swift
//  Finance
//
//  Created by Александр Меренков on 09.08.2023.
//

import Foundation

protocol UserServiceProtocol: AnyObject {
    func getUser(_ uid: String) -> User?
}
