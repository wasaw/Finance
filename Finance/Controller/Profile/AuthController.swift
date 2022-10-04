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

class AuthController: UIViewController {
    
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
            let alert = UIAlertController(title: "Внимание", message: "Заполнены не все поля", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true)
            return false
        }
        if resultEmailPattern == nil {
            let alert = UIAlertController(title: "Внимание", message: "Неправильно введен email", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true)
            return false
        }
        switch segment {
        case 0:
            return true
        case 1:
            if credentials.password == "" || credentials.confirmPass == "" {
                let alert = UIAlertController(title: "Внимание", message: "Заполнены не все поля", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true)
                return false
            }
            if credentials.password != credentials.confirmPass {
                let alert = UIAlertController(title: "Внимание", message: "Пароли не совпадают", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true)
            }
            if credentials.password.count < 6 {
                let alert = UIAlertController(title: "Внимание", message: "Длина пароля минимум 6 символов", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true)
            }
            return true
        default:
            return false
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
                        print("Logging error is \(error.localizedDescription)")
                    }
                    if let uid = result?.user.uid {
                        self.delegate?.sendUid(uid: uid)
                    }
//                    self.dismiss(animated: true)
                    self.presentingViewController?.dismiss(animated: true)
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
//                        self.dismiss(animated: true)
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
