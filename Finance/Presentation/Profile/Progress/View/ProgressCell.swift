//
//  ProgressCell.swift
//  Finance
//
//  Created by Александр Меренков on 13.11.2023.
//

import UIKit

protocol ProgressCellDelegate: AnyObject {
    func showDetails(isShow: Bool)
}

private enum Constants {
    static let horizontalPadding: CGFloat = 10
}

final class ProgressCell: UITableViewCell {
    static let reuseIdentifire = "progressCell"
    
// MARK: - Properties
    
    weak var delegate: ProgressCellDelegate?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var selector: UISwitch = {
        let switcher = UISwitch()
        switcher.addTarget(self, action: #selector(handleSelector), for: .touchUpInside)
        return switcher
    }()
    
// MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Helpers
    
    private func configureUI() {
        contentView.addSubview(titleLabel)
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        titleLabel.anchor(leading: contentView.leadingAnchor,
                          paddingLeading: Constants.horizontalPadding)
        
        contentView.addSubview(selector)
        selector.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        selector.anchor(trailing: contentView.trailingAnchor,
                        paddingTrailing: -Constants.horizontalPadding)
    }
    
    func configure(with item: ProgressItem) {
        titleLabel.text = item.title
        selector.isOn = item.isShow
    }
    
// MARK: - Selectors
    
    @objc private func handleSelector() {
        delegate?.showDetails(isShow: selector.isOn)
    }
}
