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
    private weak var moduleOutput: AuthPresenterOutput?
    private let authService: AuthServiceProtocol
    private let transactionsService: TransactionsServiceProtocol
    private let notification = NotificationCenter.default
    
// MARK: - Lifecycle
    
    init(moduleOutput: AuthPresenterOutput,
         authService: AuthServiceProtocol,
         transactionsService: TransactionsServiceProtocol) {
        self.moduleOutput = moduleOutput
        self.authService = authService
        self.transactionsService = transactionsService
    }
    
    deinit {
        notification.removeObserver(self)
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
            input?.feedback(.warning)
        } else {
            do {
                let transactions = try transactionsService.fetchTransactions(limit: nil)
                authService.logInUser(credentials: credentials) { [weak self] result in
                    switch result {
                    case .success:
                        self?.input?.feedback(.success)
                        if transactions.isEmpty {
                            self?.moduleOutput?.dismissView()
                        } else {
                            self?.input?.showAsk()
                        }
                    case .failure(let error):
                        self?.input?.showAlert(message: error.localizedDescription)
                        self?.input?.feedback(.error)
                    }
                }
            } catch {
                self.input?.showAlert(message: "Не удается авторизоваться")
                self.input?.feedback(.error)
            }
        }
    }
    
    func signIn(_ credentials: RegCredentials) {
        let result = isValid(credentials)
        switch result {
        case .success:
            do {
                let transactions = try transactionsService.fetchTransactions(limit: nil)
                authService.signInUser(credentials: credentials) { [weak self] result in
                    switch result {
                    case .success:
                        self?.input?.feedback(.success)
                        if transactions.isEmpty {
                            self?.moduleOutput?.dismissView()
                        } else {
                            self?.input?.showAsk()
                        }
                    case .failure:
                        self?.input?.showAlert(message: "Ошибка. Попробуйте снова.")
                        self?.input?.feedback(.error)
                    }
                }
            } catch {
                self.input?.showAlert(message: "Не удается зарегистрироваться")
                self.input?.feedback(.error)
            }
        case .failure(let error):
            input?.showAlert(message: error.localizedDescription)
            input?.feedback(.error)
        }
    }
    
    func dismissView(with isSave: Bool) {
        if isSave {
            do {
                let transansaction = try transactionsService.fetchTransactions(limit: nil)
                transactionsService.upload(transansaction)
            } catch {
            }
        } else {
            transactionsService.delete()
            notification.post(Notification(name: .addTransactions, object: nil))
        }
        moduleOutput?.dismissView()
    }
}
