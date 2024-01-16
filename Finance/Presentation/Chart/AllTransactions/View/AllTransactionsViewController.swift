//
//  AllTransactionsViewController.swift
//  Finance
//
//  Created by Александр Меренков on 16.01.2024.
//

import UIKit

final class AllTransactionsViewController: UIViewController {
    
// MARK: - Properties
    
    private let output: AllTransactionsOutput
    
// MARK: - LifeCycle
    
    init(output: AllTransactionsOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

// MARK: - AllTransactionsInput

extension AllTransactionsViewController: AllTransactionsInput {
    
}
