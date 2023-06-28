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
    func logInUser(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void)
    func registerUser(credentials: AuthCredentials, completion: @escaping (Error?, DatabaseReference) -> Void)
}
