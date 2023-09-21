//
//  AuthOutput.swift
//  Finance
//
//  Created by Александр Меренков on 22.06.2023.
//

import Foundation

protocol AuthOutput: AnyObject {
    func logIn(_ credentials: AuthCredentials)
    func signIn(_ credentials: RegCredentials)
    func dismissView(with isSave: Bool)
}
