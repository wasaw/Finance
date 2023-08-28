//
//  AuthServiceProtocol.swift
//  Finance
//
//  Created by Александр Меренков on 28.06.2023.
//

import Foundation

protocol AuthServiceProtocol: AnyObject {    
    func authVerification(completion: @escaping (Result<String, Error>) -> Void)
    func logOut(completion: @escaping (Result<Void, AuthError>) -> Void)
    func signInUser(credentials: AuthCredentials, completion: @escaping (Result<Void, Error>) -> Void)
    func logInUser(email: String, password: String, completion: @escaping (Result<Void, AuthError>) -> Void)
}
