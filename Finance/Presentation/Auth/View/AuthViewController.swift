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

private enum Constants {
    static let horizontalPadding: CGFloat = 20
    static let paddingTop: CGFloat = 25
    static let titleHeight: CGFloat = 25
    static let authViewHorizontalPadding: CGFloat = 30
    static let textFieldHeight: CGFloat = 50
    static let segmentedControllerHeight: CGFloat = 45
    static let segmentedControllerWidth: CGFloat = 270
    static let logInButtonPaddingBottom: CGFloat = 20
}

final class AuthViewController: UIViewController {
    
// MARK: - Properties
    
    private let output: AuthOutput
    
    private let authView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 4
        view.layer.masksToBounds = false
        view.clipsToBounds = false
        view.backgroundColor = .logInBackgroundColor
        return view
    }()
    var heightConstraint: NSLayoutConstraint?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Вход"
        label.font = UIFont.boldSystemFont(ofSize: 27)
        label.textColor = .totalTintColor
        return label
    }()
    private lazy var loginTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Имя пользователя"
        tf.font = UIFont.systemFont(ofSize: 19)
        tf.textColor = .black
        tf.delegate = self
        return tf
    }()
    private lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Почта"
        tf.keyboardType = .emailAddress
        tf.font = UIFont.systemFont(ofSize: 19)
        tf.textColor = .black
        tf.delegate = self
        return tf
    }()
    private lazy var emailRegTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Почта"
        tf.keyboardType = .emailAddress
        tf.font = UIFont.systemFont(ofSize: 19)
        tf.textColor = .black
        tf.delegate = self
        return tf
    }()
    private lazy var passTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Пароль"
        tf.isSecureTextEntry = true
        tf.font = UIFont.systemFont(ofSize: 19)
        tf.textColor = .black
        tf.delegate = self
        return tf
    }()
    private lazy var passRegTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Пароль"
        tf.isSecureTextEntry = true
        tf.font = UIFont.systemFont(ofSize: 19)
        tf.textColor = .black
        tf.delegate = self
        return tf
    }()
    private lazy var confirmPassTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Подтверждение пароля"
        tf.isSecureTextEntry = true
        tf.font = UIFont.systemFont(ofSize: 19)
        tf.textColor = .black
        tf.delegate = self
        return tf
    }()
    private lazy var logInButton: UIButton = {
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
    
    private lazy var segmentedController = UISegmentedControl(items: ["Вход", "Регистрация"])
    
// MARK: - Lifecycle
    
    init(output: AuthOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loginTextField.addLine()
        emailTextField.addLine()
        emailRegTextField.addLine()
        passTextField.addLine()
        passRegTextField.addLine()
        confirmPassTextField.addLine()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        view.backgroundColor = .white
    }
    
// MARK: - Helpers
    
    private func configureUI() {
        configureAuthView()
        configureTitle()
        configureSegmentedControl()
        configureLogInField()
        configureRegField()
        configureButton()
    }
    
    private func configureAuthView() {
        view.addSubview(authView)
        authView.anchor(leading: view.leadingAnchor,
                        trailing: view.trailingAnchor,
                        paddingLeading: Constants.authViewHorizontalPadding,
                        paddingTrailing: -Constants.authViewHorizontalPadding)
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
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGuesture)
    }
    
    private func configureTitle() {
        authView.addSubview(titleLabel)
        titleLabel.anchor(leading: authView.leadingAnchor,
                          top: authView.topAnchor,
                          trailing: authView.trailingAnchor,
                          paddingLeading: Constants.horizontalPadding,
                          paddingTop: Constants.paddingTop,
                          paddingTrailing: Constants.horizontalPadding,
                          height: Constants.titleHeight)
    }
    
    private func configureSegmentedControl() {
        authView.addSubview(segmentedController)
        segmentedController.anchor(top: titleLabel.bottomAnchor,
                                   paddingTop: Constants.paddingTop,
                                   width: Constants.segmentedControllerWidth,
                                   height: Constants.segmentedControllerHeight)
        segmentedController.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
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
        authView.addSubview(emailTextField)
        emailTextField.anchor(leading: authView.leadingAnchor,
                              top: segmentedController.bottomAnchor,
                              trailing: authView.trailingAnchor,
                              paddingLeading: Constants.horizontalPadding,
                              paddingTop: Constants.paddingTop,
                              paddingTrailing: -Constants.horizontalPadding,
                              height: Constants.textFieldHeight)

        authView.addSubview(passTextField)
        passTextField.anchor(leading: authView.leadingAnchor,
                             top: emailTextField.bottomAnchor,
                             trailing: authView.trailingAnchor,
                             paddingLeading: Constants.horizontalPadding,
                             paddingTop: Constants.paddingTop,
                             paddingTrailing: -Constants.horizontalPadding,
                             height: Constants.textFieldHeight)
    }
    
    private func configureRegField() {
        authView.addSubview(loginTextField)
        loginTextField.anchor(leading: authView.leadingAnchor,
                              top: segmentedController.bottomAnchor,
                              trailing: authView.trailingAnchor,
                              paddingLeading: Constants.horizontalPadding,
                              paddingTop: Constants.paddingTop,
                              paddingTrailing: -Constants.horizontalPadding,
                              height: Constants.textFieldHeight)
        loginTextField.alpha = 0

        authView.addSubview(emailRegTextField)
        emailRegTextField.anchor(leading: authView.leadingAnchor,
                                 top: loginTextField.bottomAnchor,
                                 trailing: authView.trailingAnchor,
                                 paddingLeading: Constants.horizontalPadding,
                                 paddingTop: Constants.paddingTop,
                                 paddingTrailing: -Constants.horizontalPadding,
                                 height: Constants.textFieldHeight)
        emailRegTextField.alpha = 0

        authView.addSubview(passRegTextField)
        passRegTextField.anchor(leading: authView.leadingAnchor,
                                top: emailRegTextField.bottomAnchor,
                                trailing: authView.trailingAnchor,
                                paddingLeading: Constants.horizontalPadding,
                                paddingTop: Constants.paddingTop,
                                paddingTrailing: -Constants.horizontalPadding,
                                height: Constants.textFieldHeight)
        passRegTextField.alpha = 0

        authView.addSubview(confirmPassTextField)
        confirmPassTextField.anchor(leading: authView.leadingAnchor,
                                    top: passRegTextField.bottomAnchor,
                                    trailing: authView.trailingAnchor,
                                    paddingLeading: Constants.horizontalPadding,
                                    paddingTop: Constants.paddingTop,
                                    paddingTrailing: -Constants.horizontalPadding,
                                    height: Constants.textFieldHeight)
        confirmPassTextField.alpha = 0
    }
    
    private func configureButton() {
        authView.addSubview(logInButton)
        logInButton.anchor(leading: authView.leadingAnchor,
                           trailing: authView.trailingAnchor,
                           bottom: authView.bottomAnchor,
                           paddingLeading: Constants.horizontalPadding,
                           paddingTrailing: -Constants.horizontalPadding,
                           paddingBottom: -Constants.logInButtonPaddingBottom,
                           height: Constants.textFieldHeight)
    }
    
// MARK: - Selecters
    
    @objc private func handleSegment() {
        if segmentedController.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.4, delay: 0.2) {
                self.heightConstraint?.constant = AuthState.authorization.rawValue
                self.view.layoutIfNeeded()
            }
            titleLabel.text = "Вход"
            logInButton.setTitle("Войти", for: .normal)
            UIView.animate(withDuration: 0.3) {
                self.loginTextField.alpha = 0
                self.emailRegTextField.alpha = 0
                self.passRegTextField.alpha = 0
                self.confirmPassTextField.alpha = 0
                self.emailTextField.alpha = 1
                self.passTextField.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.4, delay: 0.2) {
                self.heightConstraint?.constant = AuthState.registration.rawValue
                self.view.layoutIfNeeded()
            }
            titleLabel.text = "Форма регистрации"
            logInButton.setTitle("Зарегистрироваться", for: .normal)
            UIView.animate(withDuration: 0.3) {
                self.emailTextField.alpha = 0
                self.passTextField.alpha = 0
                self.loginTextField.alpha = 1
                self.emailRegTextField.alpha = 1
                self.passRegTextField.alpha = 1
                self.confirmPassTextField.alpha = 1
            }
        }
    }
    
    @objc private func handleButton() {
        guard let email = emailTextField.text else { return }
        guard let password = passTextField.text else { return }
        if segmentedController.selectedSegmentIndex == 0 {
            let credentials = AuthCredentials(email: email, password: password)
            output.logIn(credentials)
        } else {
            guard let login = loginTextField.text else { return }
            guard let confirmPass = confirmPassTextField.text else { return }
            let credentials = RegCredentials(login: login, email: email, password: password, confirmPass: confirmPass)
            output.signIn(credentials)
        }
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - AuthInput

extension AuthViewController: AuthInput {
    func showAlert(message: String) {
        alert(with: "Внимание", massage: message)
    }
}

// MARK: - UITextFieldDelegate

extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passTextField.resignFirstResponder()
        loginTextField.resignFirstResponder()
        emailRegTextField.resignFirstResponder()
        passRegTextField.resignFirstResponder()
        confirmPassTextField.resignFirstResponder()
        return true
    }
}
