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
    private let output: LastTransactionOutput
    
// MARK: - Lifecycle
    
    init(output: LastTransactionOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
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
    func showData(transaction: Transaction, currency: Currency, rate: Double) {
        textView.setInformation(transaction, currency: currency, rate: rate)
    }
}
