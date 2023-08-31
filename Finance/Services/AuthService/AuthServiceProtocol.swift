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
    func signInUser(credentials: RegCredentials, completion: @escaping (Result<Void, Error>) -> Void)
    func logInUser(credentials: AuthCredentials, completion: @escaping (Result<Void, AuthError>) -> Void)
}
