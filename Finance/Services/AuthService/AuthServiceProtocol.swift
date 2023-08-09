//
//  AuthServiceProtocol.swift
//  Finance
//
//  Created by Александр Меренков on 28.06.2023.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

protocol AuthServiceProtocol: AnyObject {
    var profilePresenterInput: ProfilePresenterInput? { get set }
    
    func authVerification() -> Bool
    func logOut()
    func signInUser(credentials: AuthCredentials, completion: @escaping ((Bool) -> Void))
    func logInUser(email: String, password: String, completion: @escaping (Bool) -> Void)
}
