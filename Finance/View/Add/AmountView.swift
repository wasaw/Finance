//
//  AmountView.swift
//  Finance
//
//  Created by Александр Меренков on 21.06.2022.
//

import UIKit

protocol HandleDoneDelegate: AnyObject {
    func saveInformation(amount: Int, comment: String)
}

class AmountView: UIView {
    
//    MARK: - Properties
    
    private let amountTitle = TitleView()
    private let amountTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Сумма"
        return tf
    }()
    
    private let dateTitle = TitleView()
    private let dateTextField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Дата"
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
        btn.addTarget(self, action: #selector(handleDoneButton), for: .touchUpInside)
        return btn
    }()
    
    weak var delegate: HandleDoneDelegate?
    
//    MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        amountTextField.addLine()
        commentTextField.addLine()
        dateTextField.addLine()
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
        addSubview(amountTitle)
        amountTitle.anchor(left: leftAnchor, top: topAnchor, right: rightAnchor, height: 20)
        amountTitle.setTitle(title: "Сумма")
        
        addSubview(amountTextField)
        amountTextField.anchor(left: leftAnchor, top: amountTitle.bottomAnchor, right: rightAnchor, paddingTop: 10, height: 40)
        
        addSubview(dateTitle)
        dateTitle.anchor(left: leftAnchor, top: amountTextField.bottomAnchor, right: rightAnchor, paddingTop: 25, height: 20)
        dateTitle.setTitle(title: "Дата")
        
        addSubview(dateTextField)
        dateTextField.anchor(left: leftAnchor, top: dateTitle.bottomAnchor, right: rightAnchor, paddingTop: 10, height: 40)
        
        addSubview(commentTitle)
        commentTitle.anchor(left: leftAnchor, top: dateTextField.bottomAnchor, right: rightAnchor, paddingTop: 25, height: 20)
        commentTitle.setTitle(title: "Комментарий")
        
        addSubview(commentTextField)
        commentTextField.anchor(left: leftAnchor, top: commentTitle.bottomAnchor, right: rightAnchor, paddingTop: 10, height: 40)
        
        addSubview(doneButton)
        doneButton.anchor(left: leftAnchor, top: commentTextField.bottomAnchor, right: rightAnchor, paddingTop: 20, height: 80)
    }
    
    func setDateConfiguration(datePicket: UIDatePicker, toolBar: UIToolbar) {
        dateTextField.inputView = datePicket
        dateTextField.inputAccessoryView = toolBar
    }
    
    func setDateInformation(date: String) {
        dateTextField.text = date
    }
    
    func refreshInformation() {
        amountTextField.text = ""
        dateTextField.text = ""
        commentTextField.text = ""
    }
    
//    MARK: - Selectors
    
    @objc private func handleDoneButton() {
        let amount = amountTextField.text ?? "0"
        delegate?.saveInformation(amount: Int(amount) ?? 0, comment: commentTextField.text ?? "")
    }
}
