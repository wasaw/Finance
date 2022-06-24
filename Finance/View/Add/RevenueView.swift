//
//  RevenueView.swift
//  Finance
//
//  Created by Александр Меренков on 21.06.2022.
//

import UIKit

class RevenueView: UIView {
    
//    MARK: - Properties
    
    private let switcher: UISwitch = {
        let sw = UISwitch()
        sw.isOn = false
        sw.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        return sw
    }()
    private let textLabel: UILabel = {
        let label = UILabel()
        label.text = "Доход"
        label.font = UIFont.systemFont(ofSize: 15)
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
        addSubview(switcher)
        switcher.anchor(left: leftAnchor)
        switcher.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(textLabel)
        textLabel.anchor(left: switcher.rightAnchor, right: rightAnchor, paddingLeft: 10)
        textLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
