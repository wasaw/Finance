//
//  TopView.swift
//  Finance
//
//  Created by Александр Меренков on 08.07.2022.
//

import UIKit

class TopView: UIView {
    
//    MARK: - Properties
    
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.text = "$54.3"
        label.font = UIFont.boldSystemFont(ofSize: 38)
        label.textColor = .totalAccountTintColor
        return label
    }()
    
    private let dayRateView = RateView()
    private let weekRateViewNew = RateView()
    private let monthRateViewNew = RateView()

//    MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
        self.backgroundColor = .logInBackgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - Helpers
    
    private func configureUI() {
        addSubview(rateLabel)
        rateLabel.translatesAutoresizingMaskIntoConstraints = false
        rateLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        rateLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
                
        dayRateView.anchor(width: 115, height: 90)
        weekRateViewNew.anchor(width: 115, height: 90)
        monthRateViewNew.anchor(width: 115, height: 90)

        let viewStackView = UIStackView(arrangedSubviews: [dayRateView, weekRateViewNew, monthRateViewNew])
        viewStackView.axis = .horizontal
        viewStackView.distribution = .equalSpacing
        viewStackView.spacing = 10
        addSubview(viewStackView)
        viewStackView.anchor(left: leftAnchor, top: rateLabel.bottomAnchor, right: rightAnchor, bottom: bottomAnchor, paddingLeft: 25, paddingTop: 25, paddingRight: -25, paddingBottom: -35)
    }
}
