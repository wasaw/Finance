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
    private let transactionsService: TransactionsServiceProtocol
    private let notification = NotificationCenter.default
    
// MARK: - Lifecycle
    
    init(output: AuthPresenterOutput,
         authService: AuthServiceProtocol,
         transactionsService: TransactionsServiceProtocol) {
        self.output = output
        self.authService = authService
        self.transactionsService = transactionsService
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
        guard credentials.password.count > 5 else { return .failure(.shortPass)}
        
        return .success(())
    }
}

// MARK: - AuthOutput

extension AuthPresenter: AuthOutput {
    func logIn(_ credentials: AuthCredentials) {
        if credentials.email == "" || credentials.password == "" {
            input?.showAlert(message: "Заполнены не все поля")
        } else {
            do {
                let transactions = try transactionsService.fetchTransactions()
                authService.logInUser(credentials: credentials) { [weak self] result in
                    switch result {
                    case .success:
                        if transactions.isEmpty {
                            self?.output.dismissView()
                        } else {
                            self?.input?.showAsk()
                        }
                    case .failure(let error):
                        self?.input?.showAlert(message: error.localizedDescription)
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func signIn(_ credentials: RegCredentials) {
        let result = isValid(credentials)
        switch result {
        case .success:
            do {
                let transactions = try transactionsService.fetchTransactions()
                authService.signInUser(credentials: credentials) { [weak self] result in
                    switch result {
                    case .success:
                        if transactions.isEmpty {
                            self?.output.dismissView()
                        } else {
                            self?.input?.showAsk()
                        }
                    case .failure:
                        self?.input?.showAlert(message: "Ошибка. Попробуйте снова.")
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        case .failure(let error):
            input?.showAlert(message: error.localizedDescription)
        }
    }
    
    func dismissView(with isSave: Bool) {
        if isSave {
            output.dismissView()
        } else {
            transactionsService.delete()
            output.dismissView()
            notification.post(Notification(name: Notification.Name("AddTransaction"), object: nil))
        }
    }
}
