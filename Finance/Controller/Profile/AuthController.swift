 //
//  AuthController.swift
//  Finance
//
//  Created by Александр Меренков on 14.06.2022.
//

import UIKit

protocol SendUidDelegate: AnyObject {
    func sendUid(uid: String)
}

final class AuthController: UIViewController {
    
//    MARK: - Properties
        
    private let authView = AuthView()
    var delegate: SendUidDelegate?
    
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
    
    private func checkCompleted(segment: Int, credentials: AuthCredentials) -> Bool {
        let emailPattern = #"^\S+@\S+\.\S+$"#
        let resultEmailPattern = credentials.email.range(of: emailPattern, options: .regularExpression)
        if credentials.email == "" || credentials.password == "" {
            alert(with: "Внимание", massage: "Заполнены не все поля")
            return false
        }
        if resultEmailPattern == nil {
            alert(with: "Внимание", massage: "Неправильно введен email")
            return false
        }
        switch segment {
        case 1:
            if credentials.password == "" || credentials.confirmPass == "" {
                alert(with: "Внимание", massage: "Заполнены не все поля")
                return false
            }
            if credentials.password != credentials.confirmPass {
                alert(with: "Внимание", massage: "Пароли не совпадают")
            }
            if credentials.password.count < 6 {
                alert(with: "Внимание", massage: "Длина пароля минимум 6 символов")
            }
            return true
        default:
            return true
        }
    }
}

//  MARK: - Extensions

extension AuthController: AuthFormDelegate {
    func handleAuthButton(segment: Int, credentials: AuthCredentials) {
        if checkCompleted(segment: segment, credentials: credentials) {
            switch segment {
            case 0:
                let email = credentials.email
                let password = credentials.password
                
                AuthService.shared.logInUser(email: email, password: password) { result, error in
                    if let error = error {
                        if error.localizedDescription.contains("The password is invalid") {
                            self.alert(with: "Внимание", massage: "Введен неверный пароль")
                        }
                        print("Logging error is \(error.localizedDescription)")
                    }

                    if let uid = result?.user.uid {
                        self.delegate?.sendUid(uid: uid)
                    }
                }
            case 1:
                AuthService.shared.registerUser(credentials: credentials) { error, ref in
                    if let error = error {
                        print("Save error is \(error.localizedDescription)")
                    } else {
                        let uid = ref.url.suffix(28)
                        let user = User(uid: String(uid), login: credentials.login, email: credentials.email, profileImageUrl: "", authorized: true)
                        DatabaseService.shared.saveUser(user: user)
                        self.delegate?.sendUid(uid: String(uid))
                        self.presentingViewController?.dismiss(animated: true)
                    }
                }
            default:
                return
            }
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
