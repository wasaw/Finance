//
//  ProfileAssembly.swift
//  Finance
//
//  Created by Александр Меренков on 22.06.2023.
//

import UIKit

final class ProfileAssembly {
    func makeProfileModule() -> UIViewController {
        let presenter = ProfilePresenter()
        let vc = ProfileViewController(output: presenter)
        presenter.input = vc
        return vc
    }
}
