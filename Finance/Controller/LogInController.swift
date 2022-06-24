//
//  LogInController.swift
//  Finance
//
//  Created by Александр Меренков on 14.06.2022.
//

import UIKit

class LogInController: UIViewController {
    
//    MARK: - Properties
    
    private let logInView = LogInView()
    
//    MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()

        view.backgroundColor = .white
    }
    
//    MARK: - Helpers
    
    private func configureUI() {
        view.addSubview(logInView)
        logInView.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 30, paddingRight: -30, height: 510)
        logInView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
