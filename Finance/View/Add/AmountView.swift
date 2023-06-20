//
//  AmountView.swift
//  Finance
//
//  Created by Александр Меренков on 21.06.2022.
//

import UIKit

protocol HandleDoneDelegate: AnyObject {
    func saveInformation(amount: String, date: String, comment: String)
}

final class AmountView: UIView {
    
// MARK: - Properties
    
    private let amountTitle = TitleView()
    let amountTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Сумма"
        tf.keyboardType = .asciiCapableNumberPad
        tf.textColor = .black
        return tf
    }()
    
    private let dateTitle = TitleView()
    private let dateTextField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Дата"
        tf.textColor = .black
        return tf
    }()
    
    private let commentTitle = TitleView()
    let commentTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Комментарий"
        tf.textColor = .black
        tf.returnKeyType = .done
        return tf
    }()
    
    private lazy var doneButton: UIButton = {
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
    
// MARK: - Lifecycle
    
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
    
// MARK: - Helpers
    
    private func configureUI() {
        addSubview(amountTitle)
        amountTitle.anchor(leading: leadingAnchor,
                           top: topAnchor,
                           trailing: trailingAnchor,
                           height: 20)
        amountTitle.setTitle(title: "Сумма")
        
        addSubview(amountTextField)
        amountTextField.anchor(leading: leadingAnchor,
                               top: amountTitle.bottomAnchor,
                               trailing: trailingAnchor,
                               paddingTop: 10,
                               height: 40)
        
        addSubview(dateTitle)
        dateTitle.anchor(leading: leadingAnchor,
                         top: amountTextField.bottomAnchor,
                         trailing: trailingAnchor,
                         paddingTop: 25,
                         height: 20)
        dateTitle.setTitle(title: "Дата")
        
        addSubview(dateTextField)
        dateTextField.anchor(leading: leadingAnchor,
                             top: dateTitle.bottomAnchor,
                             trailing: trailingAnchor,
                             paddingTop: 10,
                             height: 40)
        
        addSubview(commentTitle)
        commentTitle.anchor(leading: leadingAnchor,
                            top: dateTextField.bottomAnchor,
                            trailing: trailingAnchor,
                            paddingTop: 25,
                            height: 20)
        commentTitle.setTitle(title: "Комментарий")
        
        addSubview(commentTextField)
        commentTextField.anchor(leading: leadingAnchor,
                                top: commentTitle.bottomAnchor,
                                trailing: trailingAnchor,
                                paddingTop: 10,
                                height: 40)
        
        addSubview(doneButton)
        doneButton.anchor(leading: leadingAnchor,
                          top: commentTextField.bottomAnchor,
                          trailing: trailingAnchor,
                          paddingTop: 20,
                          height: 80)
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
    
// MARK: - Selectors
    
    @objc private func handleDoneButton() {
        delegate?.saveInformation(amount: amountTextField.text ?? "", date: dateTextField.text ?? "", comment: commentTextField.text ?? "")
    }
}
