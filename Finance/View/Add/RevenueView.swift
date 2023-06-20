//
//  RevenueView.swift
//  Finance
//
//  Created by Александр Меренков on 21.06.2022.
//

import UIKit

protocol SwitcherValueDelegate: AnyObject {
    func switchChanged(value: Bool)
}

final class RevenueView: UIView {
    
// MARK: - Properties
    
    private lazy var switcher: UISwitch = {
        let sw = UISwitch()
        sw.isOn = false
        sw.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        sw.addTarget(self, action: #selector(tapSwitcher), for: .valueChanged)
        return sw
    }()
    private let textLabel: UILabel = {
        let label = UILabel()
        label.text = "Доход"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    
    weak var delegate: SwitcherValueDelegate?
    
// MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Helpers
    
    private func configureUI() {
        addSubview(switcher)
        switcher.anchor(leading: leadingAnchor)
        switcher.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(textLabel)
        textLabel.anchor(leading: switcher.trailingAnchor, trailing: trailingAnchor, paddingLeading: 10)
        textLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func turnOffSwitcher() {
        switcher.isOn = false
    }
    
// MARK: - Selectors
    
    @objc private func tapSwitcher(sender: UISwitch) {
        delegate?.switchChanged(value: switcher.isOn)
    }
}
