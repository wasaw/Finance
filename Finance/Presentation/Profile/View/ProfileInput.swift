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
    func setUserImage(_ image: UIImage)
}
