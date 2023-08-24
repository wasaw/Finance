//
//  AuthServiceProtocol.swift
//  Finance
//
//  Created by Александр Меренков on 28.06.2023.
//

import Foundation

protocol AuthServiceProtocol: AnyObject {    
    func authVerification() -> String?
    func logOut(completion: @escaping (Result<Void, Error>) -> Void)
    func signInUser(credentials: AuthCredentials, completion: @escaping ((Bool) -> Void))
    func logInUser(email: String, password: String, completion: @escaping (Bool) -> Void)
}
