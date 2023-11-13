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
    
    private lazy var amountView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.text = "Планируемые траты:"
        label.font = UIFont.boldSystemFont(ofSize: 19)
        return label
    }()
    
    private lazy var amountTextField: UITextField = {
        let tf = UITextField()
        tf.becomeFirstResponder()
        tf.layer.borderWidth = 0.3
        tf.layer.borderColor = UIColor.lightGray.cgColor
        return tf
    }()
    
    private lazy var currencyLabel: UILabel = {
        let label = UILabel()
        label.text = "₽"
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
        
        view.addSubview(amountView)
        amountView.anchor(leading: view.leadingAnchor,
                          top: tableView.bottomAnchor,
                          trailing: view.trailingAnchor,
                          paddingLeading: Constants.horizontalPadding,
                          paddingTop: Constants.amountViewPaddingTop)
        
        amountView.addSubview(amountLabel)
        amountLabel.centerYAnchor.constraint(equalTo: amountView.centerYAnchor).isActive = true
        amountLabel.anchor(leading: amountView.leadingAnchor)
        
        amountView.addSubview(currencyLabel)
        currencyLabel.centerYAnchor.constraint(equalTo: amountView.centerYAnchor).isActive = true
        currencyLabel.anchor(trailing: amountView.trailingAnchor,
                             paddingTrailing: -Constants.horizontalPadding)
        
        amountView.addSubview(amountTextField)
        amountTextField.centerYAnchor.constraint(equalTo: amountView.centerYAnchor).isActive = true
        amountTextField.anchor(trailing: currencyLabel.leadingAnchor,
                               paddingTrailing: -Constants.horizontalPadding,
                               width: Constants.textFieldWidth)
        
        view.backgroundColor = .white
    }
    
    private func setupDataSource(_ items: [ProgressItem]) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections(ProgressSection.allCases)
        snapshot.appendItems(items)
        dataSource.apply(snapshot)
    }
}

// ProgressInput

extension ProgressViewController: ProgressInput {
    func setProgressItem(_ items: [ProgressItem]) {
        configureUI()
        setupDataSource(items)
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
        amountView.isHidden = !isShow
    }
}
