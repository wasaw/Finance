//
//  AuthPresenter.swift
//  Finance
//
//  Created by Александр Меренков on 22.06.2023.
//

import Foundation

final class AuthPresenter {
    
// MARK: - Properties
    
    weak var input: AuthInput?
    private let output: AuthPresenterOutput
    
// MARK: - Lifecycle
    
    init(output: AuthPresenterOutput) {
        self.output = output
    }
}

// MARK: - AuthOutput

extension AuthPresenter: AuthOutput {
    func validation(segment: Int, credentials: AuthCredentials) {
        let emailPattern = #"^\S+@\S+\.\S+$"#
        let resultEmailPattern = credentials.email.range(of: emailPattern, options: .regularExpression)
        
        switch segment {
        case 0:
            if credentials.email == "" || credentials.password == "" {
                input?.showAlert(message: "Заполнены не все поля")
            } else {
                let email = credentials.email
                let password = credentials.password
                output.entrance(email: email, password: password)
            }
        case 1:
            var isReady = true
            if resultEmailPattern == nil {
                input?.showAlert(message: "Неправильно введен email")
                isReady = false
            }
            if credentials.password == "" || credentials.confirmPass == "" {
                input?.showAlert(message: "Заполнены не все поля")
                isReady = false
            }
            if credentials.password != credentials.confirmPass {
                input?.showAlert(message: "Пароли не совпадают")
                isReady = false
            }
            if credentials.password.count < 6 {
                input?.showAlert(message: "Длина пароля минимум 6 символов")
                isReady = false
            }
            if isReady {
                output.registration(credentials: credentials)
            }
        default:
            break
        }
    }
}
