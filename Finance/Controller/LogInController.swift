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
        
        logInView.translatesAutoresizingMaskIntoConstraints = false
        logInView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        logInView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        logInView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        logInView.heightAnchor.constraint(equalToConstant: 410).isActive = true
    }
}
