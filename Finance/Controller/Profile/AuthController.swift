 //
//  AuthController.swift
//  Finance
//
//  Created by Александр Меренков on 14.06.2022.
//

import UIKit

class AuthController: UIViewController {
    
//    MARK: - Properties
    
    private let authView = AuthView()
    
//    MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDelegate()
        configureUI()

        view.backgroundColor = .white
    }
    
//    MARK: - Helpers
    
    private func configureUI() {
        view.addSubview(authView)
        authView.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 30, paddingRight: -30, height: 510)
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

//  MARK: - Extensions

extension AuthController: AuthFormDelegate {
    func handleAuthButton(segment: Int, credentials: AuthCredentials) {
        switch segment {
        case 0:
            let email = credentials.email
            let password = credentials.password
            
            AuthService.shared.logInUser(email: email, password: password) { result, error in
                if let error = error {
                    print("Logging error is \(error.localizedDescription)")
                }
                
                self.dismiss(animated: true)
            }
        case 1:
            AuthService.shared.registerUser(credentials: credentials) { error, ref in
                if let error = error {
                    print("Save error is \(error.localizedDescription)")
                }
                
                self.dismiss(animated: true)
            }
        default:
            return
        }
    }
}

extension AuthController: UITextFieldDelegate {
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
