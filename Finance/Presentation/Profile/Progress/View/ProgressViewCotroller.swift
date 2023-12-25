//
//  ProgressViewCotroller.swift
//  Finance
//
//  Created by Александр Меренков on 13.11.2023.
//

import UIKit

private enum Constants {
    static let tableHeight: CGFloat = 50
    static let horizontalPadding: CGFloat = 10
    static let textFieldWidth: CGFloat = 90
    static let amountViewPaddingTop: CGFloat = 25
    static let heightForRowAt: CGFloat = 44
}

final class ProgressViewController: UIViewController {
    
// MARK: - Properties
    
    private let output: ProgressOutput
    
    private lazy var tableView = UITableView(frame: .zero)
    private lazy var dataSource = ProgressDataSource(tableView, delegate: self)
    
    private lazy var expenseView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    private lazy var expenseLabel: UILabel = {
        let label = UILabel()
        label.text = "Планируемые траты:"
        label.font = UIFont.boldSystemFont(ofSize: 19)
        return label
    }()
    
    private lazy var expenseTextField: UITextField = {
        let tf = UITextField()
        tf.layer.borderWidth = 0.3
        tf.layer.borderColor = UIColor.lightGray.cgColor
        return tf
    }()
    
    private lazy var currencyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 19)
        return label
    }()
    
// MARK: - Lifecycle
    
    init(output: ProgressOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.viewIsReady()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        let expense = expenseTextField.text ?? ""
        output.saveExpense(expense)
    }

// MARK: - Helpers
    
    private func configureUI() {
        navigationItem.title = "Прогресс"
        tableView.register(ProgressCell.self, forCellReuseIdentifier: ProgressCell.reuseIdentifire)
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.anchor(leading: view.leadingAnchor,
                         top: view.safeAreaLayoutGuide.topAnchor,
                         trailing: view.trailingAnchor,
                         height: Constants.tableHeight)
        
        view.addSubview(expenseView)
        expenseView.anchor(leading: view.leadingAnchor,
                          top: tableView.bottomAnchor,
                          trailing: view.trailingAnchor,
                          paddingLeading: Constants.horizontalPadding,
                          paddingTop: Constants.amountViewPaddingTop)
        
        expenseView.addSubview(expenseLabel)
        expenseLabel.centerYAnchor.constraint(equalTo: expenseView.centerYAnchor).isActive = true
        expenseLabel.anchor(leading: expenseView.leadingAnchor)
        
        expenseView.addSubview(currencyLabel)
        currencyLabel.centerYAnchor.constraint(equalTo: expenseView.centerYAnchor).isActive = true
        currencyLabel.anchor(trailing: expenseView.trailingAnchor,
                             paddingTrailing: -Constants.horizontalPadding)
        
        expenseView.addSubview(expenseTextField)
        expenseTextField.centerYAnchor.constraint(equalTo: expenseView.centerYAnchor).isActive = true
        expenseTextField.anchor(trailing: currencyLabel.leadingAnchor,
                               paddingTrailing: -Constants.horizontalPadding,
                               width: Constants.textFieldWidth)
        
        view.backgroundColor = .white
        
        configureKeyboard()
    }
    
    private func configureKeyboard() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 50))
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBar.setItems([flexSpace, doneButton], animated: true)
        expenseTextField.inputAccessoryView = toolBar
    }
    
    private func setupDataSource(_ item: ProgressItem) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections(ProgressSection.allCases)
        snapshot.appendItems([item])
        dataSource.apply(snapshot)
    }
    
// MARK: - Selectors
    
    @objc private func doneAction() {
        view.endEditing(true)
    }
}

// ProgressInput

extension ProgressViewController: ProgressInput {
    func setProgressItem(_ item: ProgressItem) {
        expenseView.isHidden = !item.isShow
        if item.isShow {
            expenseTextField.becomeFirstResponder()
        }
        expenseTextField.text = String(format: "%0.2f", item.expense)
        currencyLabel.text = item.currency.symbol
        configureUI()
        setupDataSource(item)
    }
}

// UITableViewDelegate

extension ProgressViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.heightForRowAt
    }
}

// ProgressCellDelegate

extension ProgressViewController: ProgressCellDelegate {
    func showDetails(isShow: Bool) {
        if isShow {
            expenseTextField.becomeFirstResponder()
        }
        expenseView.isHidden = !isShow
        output.setProgress(isShow)
    }
}
