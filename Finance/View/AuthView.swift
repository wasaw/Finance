//
//  AuthView.swift
//  Finance
//
//  Created by Александр Меренков on 14.06.2022.
//

import UIKit

protocol AuthFormDelegate: AnyObject {
    func handleAuthButton(segment: Int, credentials: AuthCredentials)
}

class AuthView: UIView {
    
//    MARK: - Properties
    
    weak var delegate: AuthFormDelegate?
        
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Вход"
        label.font = UIFont.boldSystemFont(ofSize: 27)
        return label
    }()
    
    let loginTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Имя пользователя"
        tf.font = UIFont.systemFont(ofSize: 19)
        return tf
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Почта"
        tf.keyboardType = .emailAddress
        tf.font = UIFont.systemFont(ofSize: 19)
        return tf
    }()
    
    let emailRegTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Почта"
        tf.keyboardType = .emailAddress
        tf.font = UIFont.systemFont(ofSize: 19)
        return tf
    }()
    
    let passTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Пароль"
        tf.isSecureTextEntry = true
        tf.font = UIFont.systemFont(ofSize: 19)
        return tf
    }()
    
    let passRegTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Пароль"
        tf.isSecureTextEntry = true
        tf.font = UIFont.systemFont(ofSize: 19)
        return tf
    }()
    
    let confirmPassTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Подтверждение пароля"
        tf.isSecureTextEntry = true
        tf.font = UIFont.systemFont(ofSize: 19)
        return tf
    }()
            
    private let logInButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Войти", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 27)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.layer.cornerRadius = 10
        btn.backgroundColor = .logInButtonBackground
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowRadius = 4
        btn.layer.shadowOffset = CGSize(width: 0, height: 1)
        btn.layer.shadowOpacity = 0.3
        btn.layer.masksToBounds = false
        btn.clipsToBounds = false
        btn.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
        return btn
    }()
    
    private let segmentedController = UISegmentedControl(items: ["Вход", "Регистрация"])
    
//    MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()

        loginTextField.addLine()
        emailTextField.addLine()
        emailRegTextField.addLine()
        passTextField.addLine()
        passRegTextField.addLine()
        confirmPassTextField.addLine()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureUI()
        
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 4
        layer.masksToBounds = false
        clipsToBounds = false
        
        backgroundColor = .logInBackgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - Helpers
    
    private func configureUI() {
        configureTitle()
        configureSegmentedControl()
        configureLogInField()
        configureRegField()
        configureButton()
    }
    
    private func configureTitle() {
        addSubview(titleLabel)
        titleLabel.anchor(left: leftAnchor, top: topAnchor, right: rightAnchor, paddingLeft: 20, paddingTop: 20, paddingRight: 20, height: 30)
    }
    
    private func configureSegmentedControl() {
        addSubview(segmentedController)
        segmentedController.anchor(top: titleLabel.bottomAnchor, paddingTop: 30, width: 270, height: 45)
        segmentedController.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        segmentedController.selectedSegmentIndex = 0
        segmentedController.layer.borderWidth = 1
        segmentedController.layer.borderColor = UIColor.lightGray.cgColor
        segmentedController.selectedSegmentTintColor = .logInButtonBackground
        segmentedController.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], for: .normal)
        segmentedController.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentedController.backgroundColor = .logInBackgroundColor
        
        segmentedController.addTarget(self, action: #selector(handleSegment), for: .valueChanged)
    }
    
    private func configureLogInField() {

        addSubview(emailTextField)
        emailTextField.anchor(left: leftAnchor, top: segmentedController.bottomAnchor, right: rightAnchor, paddingLeft: 20, paddingTop: 50, paddingRight: -20, height: 50)

        addSubview(passTextField)
        passTextField.anchor(left: leftAnchor, top: emailTextField.bottomAnchor, right: rightAnchor, paddingLeft: 20, paddingTop: 40, paddingRight: -20, height: 50)
    }
    
    private func configureRegField() {
        
        addSubview(loginTextField)
        loginTextField.anchor(left: leftAnchor, top: segmentedController.bottomAnchor, right: rightAnchor, paddingLeft: 20, paddingTop: 20, paddingRight: -20, height: 50)
        loginTextField.alpha = 0
        
        addSubview(emailRegTextField)
        emailRegTextField.anchor(left: leftAnchor, top: loginTextField.bottomAnchor, right: rightAnchor, paddingLeft: 20, paddingTop: 20, paddingRight: -20, height: 50)
        emailRegTextField.alpha = 0
        
        addSubview(passRegTextField)
        passRegTextField.anchor(left: leftAnchor, top: emailRegTextField.bottomAnchor, right: rightAnchor, paddingLeft: 20, paddingTop: 20, paddingRight: -20, height: 50)
        passRegTextField.alpha = 0
        
        addSubview(confirmPassTextField)
        confirmPassTextField.anchor(left: leftAnchor, top: passRegTextField.bottomAnchor, right: rightAnchor, paddingLeft: 20, paddingTop: 20, paddingRight: -20, height: 50)
        confirmPassTextField.alpha = 0
    }
        
    private func configureButton() {
        addSubview(logInButton)
        logInButton.anchor(left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingLeft: 10, paddingRight: -10, paddingBottom: -30, height: 55)
    }
    
//    MARK: - Helpers
    
    @objc private func handleSegment() {
        if segmentedController.selectedSegmentIndex == 0 {
            titleLabel.text = "Вход"
            logInButton.setTitle("Войти", for: .normal)
            UIView.animate(withDuration: 0.3) {
                self.loginTextField.alpha = 0
                self.emailRegTextField.alpha = 0
                self.passRegTextField.alpha = 0
                self.confirmPassTextField.alpha = 0
            }
            UIView.animate(withDuration: 0.4) {
                self.emailTextField.alpha = 1
                self.passTextField.alpha = 1
            }
        } else {
            titleLabel.text = "Форма регистрации"
            logInButton.setTitle("Зарегистрироваться", for: .normal)
            UIView.animate(withDuration: 0.3) {
                self.emailTextField.alpha = 0
                self.passTextField.alpha = 0
            }
            UIView.animate(withDuration: 0.4) {
                self.loginTextField.alpha = 1
                self.emailRegTextField.alpha = 1
                self.passRegTextField.alpha = 1
                self.confirmPassTextField.alpha = 1
            }
        }
    }
    
    @objc private func handleButton() {
        if segmentedController.selectedSegmentIndex == 0 {
            guard let email = emailTextField.text else { return }
            guard let password = passTextField.text else { return }
            let credentials = AuthCredentials(username: "", email: email, password: password)
            delegate?.handleAuthButton(segment: 0, credentials: credentials)
        } else {
            guard let login = loginTextField.text else { return }
            guard let email = emailRegTextField.text else { return }
            guard let password = passRegTextField.text else { return }
            guard let confirmPass = confirmPassTextField.text else { return }
            let credentials = AuthCredentials(username: login, email: email, password: password, confirmPass: confirmPass)
            delegate?.handleAuthButton(segment: segmentedController.selectedSegmentIndex, credentials: credentials)
        }

    }
}
