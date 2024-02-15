//
//  AuthInput.swift
//  Finance
//
//  Created by Александр Меренков on 22.06.2023.
//

import UIKit

protocol AuthInput: AnyObject {
    func showAlert(message: String)
    func showAsk()
    func feedback(_ type: UINotificationFeedbackGenerator.FeedbackType)
}
