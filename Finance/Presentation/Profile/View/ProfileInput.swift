//
//  ProfileInput.swift
//  Finance
//
//  Created by Александр Меренков on 13.06.2023.
//

import UIKit

protocol ProfileInput: AnyObject {
    func showProfile()
    func showUserCredential(_ user: User)
    func setUserImage(_ image: Data)
    func updateCurrencyMenu(_ currencyButton: [CurrencyButton])
    func showAlert(with title: String, and message: String)
    func feedback(_ type: UINotificationFeedbackGenerator.FeedbackType)
}
