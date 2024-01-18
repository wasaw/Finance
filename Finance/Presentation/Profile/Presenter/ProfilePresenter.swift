//
//  ProfilePresenter.swift
//  Finance
//
//  Created by Александр Меренков on 13.06.2023.
//

import UIKit

final class ProfilePresenter {
    
// MARK: - Properties
    
    weak var input: ProfileInput?
    private let output: ProfilePresenterOutput
    private let authService: AuthServiceProtocol
    private let userService: UserServiceProtocol
    private let exchangeRateService: ExchangeRateServiceProtocol
    private let transactionsService: TransactionsServiceProtocol
    private let notification = NotificationCenter.default
    private let defaults = CustomUserDefaults.shared
    
    private var currencyButtons = [CurrencyButton(title: "Рубль",
                                                    image: "ruble-currency.png",
                                                    displayCurrency: .rub, isSelected: true),
                                  CurrencyButton(title: "Доллар",
                                                 image: "dollar.png",
                                                 displayCurrency: .dollar,
                                                 isSelected: false),
                                  CurrencyButton(title: "Евро",
                                                 image: "euro.png",
                                                 displayCurrency: .euro,
                                                 isSelected: false)]
    
// MARK: - Lifecycle
    
    init(output: ProfilePresenterOutput,
         authService: AuthServiceProtocol,
         userService: UserServiceProtocol,
         exchangeRateService: ExchangeRateServiceProtocol,
         transactionsService: TransactionsServiceProtocol) {
        self.output = output
        self.authService = authService
        self.userService = userService
        self.exchangeRateService = exchangeRateService
        self.transactionsService = transactionsService
        notification.addObserver(self, selector: #selector(updateCredentiall(_:)), name: .updateCredential, object: nil)
    }
    
    deinit {
        notification.removeObserver(self)
    }
    
// MARK: - Helpers
    
    private func getUserInfo(_ uid: String) {
        userService.getUser(uid) { [weak self] result in
            switch result {
            case .success(let user):
                self?.updateUserInfo(user)
            case .failure(let error):
                switch error {
                case .isEmptyUser:
                    break
                case .somethingError:
                    self?.input?.showAlert(with: "Внимание", and: error.localizedDescription)
                }
            }
        }
    }
    
    private func updateUserInfo(_ user: User) {
        input?.showUserCredential(user)
        if let image = user.profileImage {
            input?.setUserImage(image)
        }
    }
    
    private func setMenu() {
        if let currencyRaw = defaults.get(for: .currency) as? Int {
            guard let currency = Currency(rawValue: currencyRaw) else { return }
            for (index, button) in currencyButtons.enumerated() {
                currencyButtons[index].isSelected = button.displayCurrency == currency
            }
            updateCurrency(currency)
        }
    }
    
    private func updateCurrency(_ currency: Currency) {
        input?.updateCurrencyMenu(currencyButtons)
        if currency != .rub {
            exchangeRateService.updateExchangeRate(for: currency) { [weak self] result in
                switch result {
                case .success:
                    self?.notification.post(Notification(name: .updateCurrency))
                case .failure(let error):
                    self?.input?.showAlert(with: "Внимание", and: error.localizedDescription)
                }
            }
        } else {
            defaults.set(0, key: .currency)
            defaults.set(1, key: .currencyRate)
            notification.post(Notification(name: .updateCurrency))
        }
    }
    
// MARK: - Selectors
    
    @objc private func updateCredentiall(_ notification: NSNotification) {
        if let uid = notification.userInfo?["uid"] as? String {
            userService.getUser(uid) { [weak self] result in
                switch result {
                case .success(let user):
                    self?.input?.showUserCredential(user)
                    guard let data = user.profileImage else { return }
                    self?.input?.setUserImage(data)
                case .failure(let error):
                    switch error {
                    case .isEmptyUser:
                        break
                    case .somethingError:
                        self?.input?.showAlert(with: "Внимание", and: error.localizedDescription)
                    }
                }
            }
        }
    }
}

// MARK: - Output

extension ProfilePresenter: ProfileOutput {
    func viewIsReady() {
        input?.showProfile()
        authService.authVerification { [weak self] result in
            switch result {
            case .success(let uid):
                self?.getUserInfo(uid)
                self?.setMenu()
            case .failure:
                self?.output.showAuth()
            }
        }
    }
    
    func logOut() {
        authService.logOut { [weak self] result in
            switch result {
            case .success:
                self?.defaults.set(nil, key: .uid)
                self?.transactionsService.delete()
                self?.output.showAuth()
                self?.notification.post(Notification(name: .updateCredential, object: nil))
            case .failure:
                self?.input?.showAlert(with: "Ошибка", and: "Не удалось разлогиниться")
            }
        }
    }
    
    func saveImage(_ imageData: Any?) {
        guard let image = imageData as? UIImage else { return }
        if let uid = defaults.get(for: .uid) as? String {
            userService.saveImage(image: image, for: uid) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.input?.setUserImage(data)
                case .failure:
                    DispatchQueue.main.async {
                        self?.input?.showAlert(with: "Внимание", and: "Не удалось сохранить фотографию, попобуйте еще раз.")
                    }
                }
            }
        }
    }
    
    func showProgressMenu() {
        output.showProgressMenu()
    }
}

// MARK: - ProfilePresenterInput

extension ProfilePresenter: ProfilePresenterInput {
    func showAuth() {
        output.showAuth()
    }
    
    func setCurrency(_ currencyButton: CurrencyButton) {
        for (index, button) in currencyButtons.enumerated() {
            currencyButtons[index].isSelected = button.title == currencyButton.title
        }
        defaults.set(currencyButton.displayCurrency.rawValue, key: .currency)
        updateCurrency(currencyButton.displayCurrency)
    }
}
