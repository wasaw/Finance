//
//  TopView.swift
//  Finance
//
//  Created by Александр Меренков on 08.07.2022.
//

import UIKit

private enum Constants {
    static let totalAccountViewDimensions: CGFloat = 25
    static let paddingTopTen: CGFloat = 10
    static let titleLableHeight: CGFloat = 20
    static let totalAccountLabelHeight: CGFloat = 30
}

final class TopView: UIView {
    
// MARK: - Properties
    
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 38)
        label.textColor = .totalTintColor
        return label
    }()
    
    private let totalAccountView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = .gray.withAlphaComponent(0.3)
        return view
    }()
    
    private let titleLable: UILabel = {
        let label = UILabel()
        label.text = "Общий счет равен"
        return label
    }()

    private let totalAccountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
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

        addSubview(totalAccountView)
        totalAccountView.anchor(leading: leadingAnchor,
                                top: rateLabel.bottomAnchor,
                                trailing: trailingAnchor,
                                bottom: bottomAnchor,
                                paddingLeading: Constants.totalAccountViewDimensions,
                                paddingTop: Constants.totalAccountViewDimensions,
                                paddingTrailing: -Constants.totalAccountViewDimensions,
                                paddingBottom: -Constants.totalAccountViewDimensions)
        
        totalAccountView.addSubview(titleLable)
        titleLable.centerXAnchor.constraint(equalTo: totalAccountView.centerXAnchor).isActive = true
        titleLable.anchor(top: totalAccountView.topAnchor,
                          paddingTop: Constants.paddingTopTen,
                          height: Constants.titleLableHeight)
        
        totalAccountView.addSubview(totalAccountLabel)
        totalAccountLabel.centerXAnchor.constraint(equalTo: totalAccountView.centerXAnchor).isActive = true
        totalAccountLabel.anchor(top: titleLable.bottomAnchor,
                                 paddingTop: Constants.paddingTopTen,
                                 height: Constants.totalAccountLabelHeight)
    }
    
    func setCurrency(_ currency: CurrentExchangeRate, requestCurrency: String) {
        rateLabel.text = "Курс " + requestCurrency + " " + String(format: "%.2f", currency.amount)
    }
    
    func setTotalAccount(_ total: Double) {
        totalAccountLabel.text = String(format: "%.2f", total)
    }
}
