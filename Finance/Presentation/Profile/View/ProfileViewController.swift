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
    private let coreData: CoreDataServiceProtocol
    
    private let imagePicker = UIImagePickerController()
    private lazy var imageView = ProfileImageView()
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.textAlignment = .center
        return label
    }()
    private let authController = AuthCoordinator(authAssembly: AuthAssembly(), authService: AuthService()).start()

    private lazy var currentCurrencyBtn = Utils().menuItemButton(image: "currencies.png", title: "Текущая валюта")
    private lazy var logOutBtn = Utils().menuItemButton(image: "logout.png", title: "Выход")
    
// MARK: - Lifecycle
    
    init(output: ProfileOutput, coreData: CoreDataServiceProtocol) {
        self.output = output
        self.coreData = coreData
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
//        authController.delegate = self
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
            storageImageRef.downloadURL { _, _ in
//                guard let profileImageUrl = url?.absoluteString else { return }
//                guard let uid = Auth.auth().currentUser?.uid else { return }
//                let values = ["profileImageUrl": profileImageUrl]
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
        do {
            let userManagedObject = try coreData.fetchUserInformation(uid: uid)
//            self.currentUser.setValue(user: user)
        } catch {
            self.alert(with: "Ошибка", massage: error.localizedDescription)
        }
//        self.deleteAuthController()
    }
}
