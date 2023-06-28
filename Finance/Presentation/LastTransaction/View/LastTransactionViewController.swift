//
//  LastTransactionViewController.swift
//  Finance
//
//  Created by Александр Меренков on 19.06.2023.
//

import UIKit

final class LastTransactionViewController: UIViewController {
    
// MARK: - Properties
    
    private let textView = LastTransactionModalView()
    private let output = LastTransactionPresenter()
    
// MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        output.input = self
        output.viewIsReady()
        view.backgroundColor = .white
    }
    
// MARK: - Helpers
    
    private func configureUI() {
        view.addSubview(textView)
        textView.anchor(leading: view.leadingAnchor,
                        top: view.topAnchor,
                        trailing: view.trailingAnchor,
                        bottom: view.bottomAnchor)
    }
}

// MARK: - LastTransactionInput

extension LastTransactionViewController: LastTransactionInput {
    func showData(transaction: LastTransaction, currency: Currency, rate: Double) {
        textView.setInformation(transaction, currency: currency, rate: rate)
    }
}
