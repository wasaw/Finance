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
        ammountTitle.anchor(left: leftAnchor, top: topAnchor, right: rightAnchor, height: 20)
        ammountTitle.setTitle(title: "Сумма")
        
        addSubview(ammountTextField)
        ammountTextField.anchor(left: leftAnchor, top: ammountTitle.bottomAnchor, right: rightAnchor, paddingTop: 10, height: 40)
        
        addSubview(commentTitle)
        commentTitle.anchor(left: leftAnchor, top: ammountTextField.bottomAnchor, right: rightAnchor, paddingTop: 25, height: 20)
        commentTitle.setTitle(title: "Комментарий")
        
        addSubview(commentTextField)
        commentTextField.anchor(left: leftAnchor, top: commentTitle.bottomAnchor, right: rightAnchor, paddingTop: 10, height: 40)
        
        addSubview(doneButton)
        doneButton.anchor(left: leftAnchor, top: commentTextField.bottomAnchor, right: rightAnchor, paddingTop: 20, height: 80)
    }
}
