//
//  RateView.swift
//  Finance
//
//  Created by Александр Меренков on 08.07.2022.
//

import UIKit

class RateView: UIView {
    
//    MARK: - Properties
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "$27"
        label.textColor = .white
        return label
    }()
    
    private let segmentLabel: UILabel = {
        let label = UILabel()
        label.text = "/ 7d"
        label.textColor = .lightGray
        return label
    }()
    
//    MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - Helpers
    
    private func configureUI() {
        layer.opacity = 0.7
        layer.cornerRadius = 15
        backgroundColor = .gray
        
        let stackView = UIStackView(arrangedSubviews: [priceLabel, segmentLabel])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        addSubview(stackView)
        stackView.anchor(left: leftAnchor, top: topAnchor, right: rightAnchor, bottom: bottomAnchor, paddingLeft: 15, paddingTop: 20, paddingRight: -15, paddingBottom: -20)
    }
}
