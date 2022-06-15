//
//  LogInView.swift
//  Finance
//
//  Created by Александр Меренков on 14.06.2022.
//

import UIKit

class LogInView: UIView {
    
//    MARK: - Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Вход"
        label.font = UIFont.boldSystemFont(ofSize: 27)
        return label
    }()
    
    private let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = " Почта"
        tf.keyboardType = .emailAddress
        tf.font = UIFont.systemFont(ofSize: 19)
        return tf
    }()
    
    private let passTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = " Пароль"
        tf.isSecureTextEntry = true
        tf.font = UIFont.systemFont(ofSize: 19)
        return tf
    }()
            
    private let logInButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Вход", for: .normal)
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
        return btn
    }()
    
    private let segmentedController = UISegmentedControl(items: ["Вход", "Регистрация"])
    
//    MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()

        emailTextField.addLine()
        passTextField.addLine()
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
        configureTextField()
        configureButton()
    }
    
    private func configureTitle() {
        addSubview(titleLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 20).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    private func configureSegmentedControl() {
        addSubview(segmentedController)
        
        segmentedController.translatesAutoresizingMaskIntoConstraints = false
        segmentedController.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        segmentedController.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
        segmentedController.heightAnchor.constraint(equalToConstant: 45).isActive = true
        segmentedController.widthAnchor.constraint(equalToConstant: 270).isActive = true
        
        segmentedController.selectedSegmentIndex = 0
        segmentedController.layer.borderWidth = 1
        segmentedController.layer.borderColor = UIColor.lightGray.cgColor
        segmentedController.selectedSegmentTintColor = .logInButtonBackground
        segmentedController.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], for: .normal)
        segmentedController.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentedController.backgroundColor = .logInBackgroundColor
        
        segmentedController.addTarget(self, action: #selector(handleSegment), for: .valueChanged)
    }

    
    private func configureTextField() {
        addSubview(emailTextField)

        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        emailTextField.topAnchor.constraint(equalTo: segmentedController.bottomAnchor, constant: 20).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        addSubview(passTextField)
        
        passTextField.translatesAutoresizingMaskIntoConstraints = false
        passTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        passTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20).isActive = true
        passTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        passTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func configureButton() {
        addSubview(logInButton)

        logInButton.translatesAutoresizingMaskIntoConstraints = false
        logInButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        logInButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40).isActive = true
        logInButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        logInButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
    }
    
//    MARK: - Helpers
    
    @objc private func handleSegment() {

    }
}
