//
//  TitleView.swift
//  Finance
//
//  Created by Александр Меренков on 09.06.2022.
//

import UIKit

private enum Constants {
    static let arrowImageDimensions: CGFloat = 20
}

final class TitleView: UIView {
    
// MARK: - Properties
        
    private let titleLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 21)
        label.textColor = .totalTintColor
        return label
    }()
    
// MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        addSubview(titleLable)
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        titleLable.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        titleLable.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Helpers
    
    func setTitle(title: String) {
        titleLable.text = title
    }
}
