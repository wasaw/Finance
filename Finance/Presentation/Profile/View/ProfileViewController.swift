//
//  ProfileViewController.swift
//  Finance
//
//  Created by Александр Меренков on 13.06.2023.
//

import UIKit

private enum Constants {
    static let horizontalPadding: CGFloat = 10
    static let paddingTop: CGFloat = 10
    static let stackViewPaddingTop: CGFloat = 130
    static let stackViewSpacing: CGFloat = 15
    static let imageViewHeight: CGFloat = 150
    static let loginLabelHeight: CGFloat = 40
}

final class ProfileViewController: UIViewController {
    
// MARK: - Properties
    
    private let output: ProfileOutput
    
    private let imagePicker = UIImagePickerController()
    private lazy var imageView = ProfileImageView()
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.textAlignment = .center
        return label
    }()

    private lazy var currentCurrencyBtn = Utils().menuItemButton(image: "currencies.png", title: "Текущая валюта")
    private lazy var logOutBtn = Utils().menuItemButton(image: "logout.png", title: "Выход")
    
// MARK: - Lifecycle
    
    init(output: ProfileOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.viewIsReady()
        view.backgroundColor = .white
    }
    
// MARK: - Helpers
    
    private func configureUI() {
        imageView.delegate = self
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        view.addSubview(imageView)
        imageView.anchor(leading: view.leadingAnchor,
                         top: view.safeAreaLayoutGuide.topAnchor,
                         trailing: view.trailingAnchor,
                         paddingLeading: Constants.horizontalPadding,
                         paddingTop: Constants.paddingTop,
                         paddingTrailing: -Constants.horizontalPadding,
                         height: Constants.imageViewHeight)
        
        view.addSubview(loginLabel)
        loginLabel.anchor(leading: view.leadingAnchor,
                          top: imageView.bottomAnchor,
                          trailing: view.trailingAnchor,
                          paddingLeading: Constants.horizontalPadding,
                          paddingTop: Constants.paddingTop,
                          paddingTrailing: -Constants.horizontalPadding,
                          height: Constants.loginLabelHeight)
        
        let stack = UIStackView(arrangedSubviews: [currentCurrencyBtn, logOutBtn])
        stack.axis = .vertical
        stack.spacing = Constants.stackViewSpacing
        view.addSubview(stack)
        stack.anchor(leading: view.leadingAnchor,
                     top: loginLabel.bottomAnchor,
                     trailing: view.trailingAnchor,
                     paddingLeading: Constants.horizontalPadding,
                     paddingTop: Constants.stackViewPaddingTop,
                     paddingTrailing: -Constants.horizontalPadding)
        
        currentCurrencyBtn.showsMenuAsPrimaryAction = true
        logOutBtn.addTarget(self, action: #selector(handleLogOutBtn), for: .touchUpInside)
    }
    
    private func generationMenu(_ currencyButton: [CurrencyButton]) -> UIMenu {
        let first = createUIAction(currencyButton[0])
        let second = createUIAction(currencyButton[1])
        let third = createUIAction(currencyButton[2])
        let elements = [first, second, third]
        let menu = UIMenu(children: elements)
        return menu
    }
    
    private func createUIAction(_ currencyButton: CurrencyButton) -> UIAction {
        return UIAction(title: currencyButton.title,
                        image: UIImage(named: currencyButton.image),
                        state: currencyButton.isSelected ? .on : .off) { _ in
            self.output.setCurrency(currencyButton)
        }
    }
    
// MARK: - Selecters
    
    @objc private func handleLogOutBtn() {
        output.logOut()
    }
}

// MARK: - ProfileInput

extension ProfileViewController: ProfileInput {
    func showProfile() {
        configureUI()
    }
    
    func showUserCredential(_ user: User) {
        loginLabel.text = user.login
    }
    
    func setUserImage(_ image: UIImage) {
        imageView.setImage(image: image)
    }
    
    func updateCurrencyMenu(_ currencyButton: [CurrencyButton]) {
        currentCurrencyBtn.menu = generationMenu(currencyButton)
    }
    
    func showAlert(with title: String, and message: String) {
        alert(with: title, message: message)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        output.saveImage(info[.editedImage])
        dismiss(animated: true)
    }
}

// MARK: - ProfileImageSelectDelegate

extension ProfileViewController: ProfileImageSelectDelegate {
    func selectImage() {
        present(imagePicker, animated: true)
    }
}
