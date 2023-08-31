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
    private let authService: AuthServiceProtocol
    
// MARK: - Lifecycle
    
    init(output: AuthPresenterOutput, authService: AuthServiceProtocol) {
        self.output = output
        self.authService = authService
    }
    
// MARK: - Helpers
    
    private func isValid(_ credentials: RegCredentials) -> Result<Void, ValidError> {
        let emailPattern = #"^\S+@\S+\.\S+$"#
        
        guard !credentials.login.isEmpty,
              !credentials.email.isEmpty,
              !credentials.password.isEmpty,
              !credentials.confirmPass.isEmpty else { return .failure(.notAllField)}
        guard credentials.email.range(of: emailPattern, options: .regularExpression) != nil else { return .failure(.invalidEmail)}
        guard credentials.password == credentials.confirmPass else { return .failure(.notMatchPassword)}
        guard credentials.password.count > 6 else { return .failure(.shortPass)}
        
        return .success(())
    }
}

// MARK: - AuthOutput

extension AuthPresenter: AuthOutput {
    func logIn(_ credentials: AuthCredentials) {
        if credentials.email == "" || credentials.password == "" {
            input?.showAlert(message: "Заполнены не все поля")
        } else {
            authService.logInUser(credentials: credentials) { [weak self] result in
                switch result {
                case .success:
                    self?.output.dismissView()
                case .failure(let error):
                    self?.input?.showAlert(message: error.localizedDescription)
                }
            }
        }
    }
    
    func signIn(_ credentials: RegCredentials) {
        let result = isValid(credentials)
        switch result {
        case .success:
            authService.signInUser(credentials: credentials) { result in
                switch result {
                case .success:
                    self.output.dismissView()
                case .failure:
                    self.input?.showAlert(message: "Ошибка. Попробуйте снова.")
                }
            }
        case .failure(let error):
            input?.showAlert(message: error.localizedDescription)
        }
    }
}
