//
//  AuthPresenterOutput.swift
//  Finance
//
//  Created by Александр Меренков on 22.06.2023.
//

import Foundation

protocol AuthPresenterOutput: AnyObject {
    func entrance(email: String, password: String)
    func registration(credentials: AuthCredentials)
}
