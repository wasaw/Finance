//
//  UserServiceProtocol.swift
//  Finance
//
//  Created by Александр Меренков on 09.08.2023.
//

import UIKit

protocol UserServiceProtocol: AnyObject {
    func getUser(_ uid: String, completion: @escaping (Result<User, UserLoadError>) -> Void)
    func saveImage(image: UIImage, for uid: String, completion: @escaping ((Result<Void, Error>) -> Void))
}
