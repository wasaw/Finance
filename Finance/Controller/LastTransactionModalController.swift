//
//  LastTransactionModalController.swift
//  Finance
//
//  Created by Александр Меренков on 22.08.2022.
//

import UIKit

class LastTransactionModalController: UIViewController {
//    MARK: - Properties
    
    private let transaction: LastTransaction
    private let textView = LastTransactionModalView()
    
//    MARK: - Lifecycle
    
    init(transaction: LastTransaction) {
        self.transaction = transaction
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        view.backgroundColor = .white
    }
    
//    MARK: - Helpers
    
    private func configureUI() {
        view.addSubview(textView)
        textView.anchor(left: view.leftAnchor, top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor)
        textView.setInformation(transaction)
    }
}
