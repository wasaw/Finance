//
//  TopView.swift
//  Finance
//
//  Created by Александр Меренков on 08.07.2022.
//

import UIKit

final class TopView: UIView {
    
// MARK: - Properties
    
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 38)
        label.textColor = .totalTintColor
        return label
    }()

// MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
        self.backgroundColor = .logInBackgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Helpers
    
    private func configureUI() {
        addSubview(rateLabel)
        rateLabel.translatesAutoresizingMaskIntoConstraints = false
        rateLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        rateLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func setCurrency(_ currency: CurrentExchangeRate, requestCurrency: String) {
        rateLabel.text = "Курс " + requestCurrency + " " + currency.amountOutput
    }
}
