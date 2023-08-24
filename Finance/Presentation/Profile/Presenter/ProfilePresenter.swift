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
    private let notification = NotificationCenter.default
    
    private var currencyButtonArr = [CurrencyButton(title: "Рубль",
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
         exchangeRateService: ExchangeRateServiceProtocol) {
        self.output = output
        self.authService = authService
        self.userService = userService
        self.exchangeRateService = exchangeRateService
        self.authService.profilePresenterInput = self
        notification.addObserver(self, selector: #selector(updateCredentiall(_:)), name: Notification.Name("updateCredential"), object: nil)
    }
    
// MARK: - Selectors
    
    @objc private func updateCredentiall(_ notification: NSNotification) {
        if let uid = notification.userInfo?["uid"] as? String {
            if let user = userService.getUser(uid) {
                input?.showUserCredential(user)
                if let image = user.profileImage {
                    input?.setUserImage(image)
                } else {
                    guard let image = UIImage(named: "add-photo.png") else { return }
                    input?.setUserImage(image)
                }
            }
        }
    }
}

// MARK: - Output

extension ProfilePresenter: ProfileOutput {
    func viewIsReady() {
        input?.showProfile()
        if let uid = authService.authVerification() {
            if let user = userService.getUser(uid) {
                input?.showUserCredential(user)
                if let image = user.profileImage {
                    input?.setUserImage(image)
                }
                if let currencyRaw = UserDefaults.standard.value(forKey: "currency") as? Int {
                    guard let currency = Currency(rawValue: currencyRaw) else { return }
                    for index in 0..<currencyButtonArr.count {
                        if currencyButtonArr[index].displayCurrency == currency {
                            currencyButtonArr[index].isSelected = true
                        } else {
                            currencyButtonArr[index].isSelected = false
                        }
                    }
                    input?.updateCurrencyMenu(currencyButtonArr)
                }
            }
        } else {
            output.showAuth()
        }
    }
    
    func logOut() {
        authService.logOut()
    }
    
    func saveImage(_ imageData: Any?) {
        guard let image = imageData as? UIImage else { return }
        input?.setUserImage(image)
        if let uid = UserDefaults.standard.value(forKey: "uid") as? String {
            userService.saveImage(image: image, for: uid)
        }
    }
}

// MARK: - ProfilePresenterInput

extension ProfilePresenter: ProfilePresenterInput {
    func showAuth() {
        output.showAuth()
    }
    
    func setCurrency(_ currencyButton: CurrencyButton) {
        for index in 0..<currencyButtonArr.count {
            if currencyButtonArr[index].title == currencyButton.title {
                currencyButtonArr[index].isSelected = true
                UserDefaults.standard.set(currencyButtonArr[index].displayCurrency.rawValue, forKey: "currency")
            } else {
                currencyButtonArr[index].isSelected = false
            }
        }
        notification.post(Notification(name: Notification.Name("updateCurrency")))
        input?.updateCurrencyMenu(currencyButtonArr)
        if currencyButton.displayCurrency != .rub {
            exchangeRateService.updateExchangeRate(for: currencyButton.displayCurrency)
        } else {
            UserDefaults.standard.set(0, forKey: "currency")
            UserDefaults.standard.set(1, forKey: "currencyRate")
        }
    }
}
