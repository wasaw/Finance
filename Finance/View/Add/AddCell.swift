//
//  AddCell.swift
//  Finance
//
//  Created by Александр Меренков on 18.06.2022.
//

import UIKit

class AddCell: UICollectionViewCell {
    
//    MARK: - Properties
    
    static let identifire = "AddCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Наличка"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let circleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        view.backgroundColor = .cyan
        return view
    }()
    
    private let costLabel: UILabel = {
        let label = UILabel()
        label.text = "0 руб."
        return label
    }()
    
//    MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        addSubview(circleView)
        
        circleView.translatesAutoresizingMaskIntoConstraints = false
        circleView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        circleView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        circleView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        circleView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        addSubview(costLabel)
        
        costLabel.translatesAutoresizingMaskIntoConstraints = false
        costLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        costLabel.topAnchor.constraint(equalTo: circleView.bottomAnchor).isActive = true
        costLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
}
