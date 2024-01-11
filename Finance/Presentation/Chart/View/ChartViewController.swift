//
//  ChartViewController.swift
//  Finance
//
//  Created by Александр Меренков on 11.01.2024.
//

import UIKit

final class ChartViewController: UIViewController {
    
// MARK: - Properties
    
    private let output: ChartOutput
    
// MARK: - Lifecycle
    
    init(output: ChartOutput) {
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

// MARK: - ChartInput

extension ChartViewController: ChartInput {
    
}
