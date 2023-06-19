//
//  ProfileViewController.swift
//  Finance
//
//  Created by Александр Меренков on 13.06.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
// MARK: - Properties
    
    private let output = ProfilePresenter()
    
    private let imagePicker = UIImagePickerController()
    private lazy var imageView = ProfileImageView()
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.textAlignment = .center
        return label
    }()
    private let authController = AuthController()

    private lazy var currentCurrencyBtn = Utils().menuItemButton(image: "currencies.png", title: "Текущая валюта")
    private lazy var logOutBtn = Utils().menuItemButton(image: "logout.png", title: "Выход")
    
// MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.input = self
        output.viewIsReady()
        view.backgroundColor = .white
    }
    
// MARK: - Helpers
    
    private func configureUI() {
        imageView.delegate = self
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        view.addSubview(imageView)
        imageView.anchor(left: view.leftAnchor,
                         top: view.safeAreaLayoutGuide.topAnchor,
                         right: view.rightAnchor,
                         paddingLeft: 10,
                         paddingTop: 15,
                         paddingRight: -10,
                         height: 150)
        
        view.addSubview(loginLabel)
        loginLabel.anchor(left: view.leftAnchor,
                          top: imageView.bottomAnchor,
                          right: view.rightAnchor,
                          paddingLeft: 10,
                          paddingTop: 10,
                          paddingRight: -10,
                          height: 40)
        
        let stack = UIStackView(arrangedSubviews: [currentCurrencyBtn, logOutBtn])
        stack.axis = .vertical
        stack.spacing = 15
        view.addSubview(stack)
        stack.anchor(left: view.leftAnchor,
                     top: loginLabel.bottomAnchor,
                     right: view.rightAnchor,
                     paddingLeft: 20,
                     paddingTop: 130,
                     paddingRight: -20)

        currentCurrencyBtn.menu = generationMenu()
        currentCurrencyBtn.showsMenuAsPrimaryAction = true
        logOutBtn.addTarget(self, action: #selector(handleLogOutBtn), for: .touchUpInside)
    }
    
    private func generationMenu() -> UIMenu {
        let first = createUIAction(title: "Рубль", image: "ruble-currency.png", displayedCurrency: .rub)
        let second = createUIAction(title: "Доллар", image: "dollar.png", displayedCurrency: .dollar)
        let third = createUIAction(title: "Евро", image: "euro.png", displayedCurrency: .euro)
        let elements = [first, second, third]
        let menu = UIMenu(children: elements)
        return menu
    }
    
    private func createUIAction(title: String, image: String, displayedCurrency: Currency) -> UIAction {
        return UIAction(title: title, image: UIImage(named: image), state: checkCurrency(currency: displayedCurrency) ? .on : .off) { _ in
            CurrencyRate.currentCurrency = displayedCurrency
            self.currentCurrencyBtn.menu = self.generationMenu()
        }
    }
    
    private func checkCurrency(currency: Currency) -> Bool {
        return currency == CurrencyRate.currentCurrency ? true : false
    }
    
    private func deleteAuthController() {
        authController.willMove(toParent: nil)
        authController.removeFromParent()
        authController.view.removeFromSuperview()
    }
    
// MARK: - Selecters
    
    @objc private func handleLogOutBtn() {
        output.logOut()
    }
}

// MARK: - ProfileInput

extension ProfileViewController: ProfileInput {
    func showAuth() {
        authController.delegate = self
        self.view.addSubview(authController.view)
        self.addChild(authController)
        authController.didMove(toParent: self)
    }
    
    func showProfile() {
        configureUI()
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let profileImage = info[.editedImage] as? UIImage else { return }
        
        imageView.setImage(image: profileImage)
        dismiss(animated: true)
        
        guard let dataImage = profileImage.jpegData(compressionQuality: 0.3) else { return }
        let filename = UUID().uuidString
        let storageImageRef = REF_PROFILE_IMAGE.child(filename)

        storageImageRef.putData(dataImage) { _, _ in
            storageImageRef.downloadURL { url, _ in
                guard let profileImageUrl = url?.absoluteString else { return }
//                guard let uid = Auth.auth().currentUser?.uid else { return }
                let values = ["profileImageUrl": profileImageUrl]
//                REF_USERS.child(uid).updateChildValues(values)
            }
        }
    }
}

// MARK: - ProfileImageSelectDelegate

extension ProfileViewController: ProfileImageSelectDelegate {
    func selectImage() {
        present(imagePicker, animated: true)
    }
}

// MARK: - SendUidDelegate

extension ProfileViewController: SendUidDelegate {
    func sendUid(uid: String) {
        DatabaseService.shared.getUserInformation(uid: uid) { result in
            switch result {
            case .success(let user):
                break
//                self.currentUser.setValue(user: user)
            case .failure(let error):
                self.alert(with: "Ошибка", massage: error.localizedDescription)
            }
        }
//        self.deleteAuthController()
    }
}
