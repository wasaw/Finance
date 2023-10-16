//
//  ATMViewController.swift
//  Finance
//
//  Created by Александр Меренков on 16.10.2023.
//

import UIKit

final class ATMViewController: UIViewController {

// MARK: - Properties
    
    private let output: ATMOutput
    
// MARK: - Lifecycle
    
    init(output: ATMOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.viewIsReady()
    }
    
}

// MARK: - ATMInput

extension ATMViewController: ATMInput {
    
}
