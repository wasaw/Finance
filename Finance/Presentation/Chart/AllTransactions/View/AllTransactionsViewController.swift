//
//  AllTransactionsViewController.swift
//  Finance
//
//  Created by Александр Меренков on 16.01.2024.
//

import UIKit

private enum Constants {
    static let rowHeight: CGFloat = 50
}

final class AllTransactionsViewController: UIViewController {
    
// MARK: - Properties
    
    private let output: AllTransactionsOutput
    private lazy var loadAnimateView = CircleAnimation()
    private lazy var tableView = UITableView(frame: .zero)
    private lazy var dataSource = AllTransactionsDataSource(tableView)
    
// MARK: - LifeCycle
    
    init(output: AllTransactionsOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        output.viewIsReady()
    }
    
// MARK: - Helpers
    
    private func configureUI() {
        navigationItem.title = "Все траты"
        
        tableView.register(AllTransactionsCell.self, forCellReuseIdentifier: AllTransactionsCell.reuseIdentifire)
        tableView.delegate = self
        tableView.dataSource = dataSource
        view.addSubview(tableView)
        tableView.anchor(leading: view.leadingAnchor,
                         top: view.safeAreaLayoutGuide.topAnchor,
                         trailing: view.trailingAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor)
        
        tableView.addSubview(loadAnimateView)
        loadAnimateView.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        loadAnimateView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadAnimateView.configureAnimation()
        view.backgroundColor = .white
    }
    
    private func setupDataSource(_ displayData: [AllTransactionsCell.DisplayData]) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([0])
        snapshot.appendItems(displayData)
        dataSource.apply(snapshot)
    }
}

// MARK: - AllTransactionsInput

extension AllTransactionsViewController: AllTransactionsInput {
    func setLoading(enable: Bool) {
        loadAnimateView.isHidden = enable ? false : true
    }
    
    func showData(_ displayData: [AllTransactionsCell.DisplayData]) {
        setupDataSource(displayData)
    }
    
    func showAlert(_ message: String) {
        alert(with: "Внимание", message: message)
    }
}

// MARK: - UITableViewDelegate

extension AllTransactionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.rowHeight
    }
}
