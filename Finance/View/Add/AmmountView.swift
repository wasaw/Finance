//
//  AmmountView.swift
//  Finance
//
//  Created by Александр Меренков on 21.06.2022.
//

import UIKit

class AmmountView: UIView {
    
//    MARK: - Properties
    
    private let ammountTitle = TitleView()
    private let ammountTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Сумма"
        return tf
    }()
    
    private let commentTitle = TitleView()
    private let commentTextField: UITextField = {
        let tv = UITextField()
        tv.placeholder = "Комментарий"
        return tv
    }()
    
    private let doneButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Готово", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 27)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.layer.cornerRadius = 20
        btn.backgroundColor = .systemGreen
        return btn
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
        let stack = UIStackView(arrangedSubviews: [ammountTitle, ammountTextField, commentTitle, commentTextField, doneButton])
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .fillProportionally
        addSubview(stack)
        
        ammountTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        ammountTitle.setTitle(title: "Сумма")
        ammountTextField.layer.borderWidth = 1
        ammountTextField.layer.borderColor = UIColor.lightGray.cgColor
        commentTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        commentTitle.setTitle(title: "Комментарий")
        commentTextField.layer.borderWidth = 1
        commentTextField.layer.borderColor = UIColor.lightGray.cgColor
        doneButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
