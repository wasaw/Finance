//
//  AuthViewController.swift
//  Finance
//
//  Created by Александр Меренков on 22.06.2023.
//

import UIKit

enum AuthState: CGFloat {
    case authorization = 390
    case registration = 510
}

final class AuthViewController: UIViewController {
    
// MARK: - Properties
    
    private let output: AuthOutput
    
    private let authView = AuthView()
    var heightConstraint: NSLayoutConstraint?
    
// MARK: - Lifecycle
    
    init(output: AuthOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDelegate()
        configureUI()
        view.backgroundColor = .white
    }
    
// MARK: - Helpers
    
    private func configureUI() {
        view.addSubview(authView)
        authView.anchor(leading: view.leadingAnchor,
                        trailing: view.trailingAnchor,
                        paddingLeading: 30,
                        paddingTrailing: -30)
        heightConstraint = NSLayoutConstraint(item: authView,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1,
                                              constant: AuthState.authorization.rawValue)
        guard let heightConstraint = heightConstraint else { return }
        authView.addConstraint(heightConstraint)
        authView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func configureDelegate() {
        authView.delegate = self
        authView.emailTextField.delegate = self
        authView.passTextField.delegate = self
        authView.loginTextField.delegate = self
        authView.emailRegTextField.delegate = self
        authView.passRegTextField.delegate = self
        authView.confirmPassTextField.delegate = self
    }
}

// MARK: - AuthInput

extension AuthViewController: AuthInput {
    func clearForm() {
        authView.clearForm()
    }
    
    func showAlert(message: String) {
        alert(with: "Внимание", massage: message)
    }
}

// MARK: - AuthFormDelegate

extension AuthViewController: AuthFormDelegate {
    func updateHeight(state: AuthState) {
        UIView.animate(withDuration: 0.4, delay: 0.2) {
            self.heightConstraint?.constant = state.rawValue
            self.view.layoutIfNeeded()
        }
    }
    
    func handleAuthButton(segment: Int, credentials: AuthCredentials) {
        output.validation(segment: segment, credentials: credentials)
    }
}

// MARK: - UITextFieldDelegate

extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        authView.emailTextField.resignFirstResponder()
        authView.passTextField.resignFirstResponder()
        authView.loginTextField.resignFirstResponder()
        authView.emailRegTextField.resignFirstResponder()
        authView.passRegTextField.resignFirstResponder()
        authView.confirmPassTextField.resignFirstResponder()
        return true
    }
}
