//
//  StocksViewController.swift
//  Finance
//
//  Created by Александр Меренков on 20.06.2023.
//

import UIKit

private enum Constants {
    static let loadAnimationViewPaddingTop: CGFloat = 15
}

final class StocksViewController: UIViewController {
    
// MARK: - Properties
    
    private let output: StocksPresenter
    
    private lazy var loadAnimationView = CircleAnimation()
    private var tableView: UITableView?
    private let stockAdapter = StockAdapter()
    
// MARK: - Lifecycle
    
    init(output: StocksPresenter) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAnimationView()
        configureTableView()
        output.viewIsReady()
        view.backgroundColor = .white
    }
    
// MARK: - Helpers
    
    private func configureAnimationView() {
        view.addSubview(loadAnimationView)
        loadAnimationView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadAnimationView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                 paddingTop: Constants.loadAnimationViewPaddingTop)
        loadAnimationView.configureAnimation()
    }
    
    private func configureTableView() {
        tableView = UITableView(frame: .zero)
        guard let tableView = tableView else { return }
        tableView.register(StockCell.self, forCellReuseIdentifier: StockCell.reuseIdentifite)
        tableView.backgroundColor = .white
        tableView.dataSource = stockAdapter
        view.addSubview(tableView)
        tableView.anchor(leading: view.leadingAnchor,
                         top: view.safeAreaLayoutGuide.topAnchor,
                         trailing: view.trailingAnchor,
                         bottom: view.bottomAnchor)
        tableView.isHidden = true
    }
}

// MARK: - StocksInput

extension StocksViewController: StocksInput {
    func setLoading(enable: Bool) {
        if enable {
            loadAnimationView.isHidden = false
        } else {
            loadAnimationView.isHidden = true
        }
    }
    
    func setData(_ stockList: [Stock], rate: Double) {
        stockAdapter.configure(stockList, rate: rate)
        tableView?.reloadData()
        tableView?.isHidden = false
    }
    
    func showAlert(with title: String, and text: String) {
        alert(with: title, message: text)
    }
}
