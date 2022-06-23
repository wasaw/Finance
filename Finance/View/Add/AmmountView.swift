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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        ammountTextField.addLine()
        commentTextField.addLine()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - Helpers
    
    private func configureUI() {
        addSubview(ammountTitle)
        ammountTitle.translatesAutoresizingMaskIntoConstraints = false
        ammountTitle.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        ammountTitle.topAnchor.constraint(equalTo: topAnchor).isActive = true
        ammountTitle.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        ammountTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        ammountTitle.setTitle(title: "Сумма")
        
        addSubview(ammountTextField)
        ammountTextField.translatesAutoresizingMaskIntoConstraints = false
        ammountTextField.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        ammountTextField.topAnchor.constraint(equalTo: ammountTitle.bottomAnchor, constant: 10).isActive = true
        ammountTextField.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        ammountTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(commentTitle)
        commentTitle.translatesAutoresizingMaskIntoConstraints = false
        commentTitle.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        commentTitle.topAnchor.constraint(equalTo: ammountTextField.bottomAnchor, constant: 25).isActive = true
        commentTitle.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        commentTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        commentTitle.setTitle(title: "Комментарий")
        
        addSubview(commentTextField)
        commentTextField.translatesAutoresizingMaskIntoConstraints = false
        commentTextField.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        commentTextField.topAnchor.constraint(equalTo: commentTitle.bottomAnchor, constant: 10).isActive = true
        commentTextField.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        commentTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        doneButton.topAnchor.constraint(equalTo: commentTextField.bottomAnchor, constant: 20).isActive = true
        doneButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
}
