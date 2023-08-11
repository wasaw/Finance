//
//  UserServiceProtocol.swift
//  Finance
//
//  Created by Александр Меренков on 09.08.2023.
//

import UIKit

protocol UserServiceProtocol: AnyObject {
    func getUser(_ uid: String) -> User?
    func saveImage(image: UIImage, for uid: String)
    func getImage(uid: String) -> UIImage?
}
