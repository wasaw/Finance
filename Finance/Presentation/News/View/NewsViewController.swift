//
//  NewsViewController.swift
//  Finance
//
//  Created by Александр Меренков on 18.10.2023.
//

import UIKit

final class NewsViewController: UIViewController {
    
// MARK: - Properties
    
    private let output: NewsOutput
    
// MARK: - Lifecycle
    
    init(output: NewsOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - NewsInput

extension NewsViewController: NewsInput {
    
}
