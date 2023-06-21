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
    
    private let output = StocksPresenter()
    
    private let loadAnimationView = CircleAnimation()
    private var stockList = [Stock]()
    private var tableView: UITableView?
    
// MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.input = self
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
        tableView.delegate = self
        tableView.dataSource = self
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
    
    func setData(_ stockList: [Stock]) {
        self.stockList = stockList
        tableView?.reloadData()
        tableView?.isHidden = false
    }
    
    func showAlert(with title: String, and text: String) {
        alert(with: title, massage: text)
    }
}

// MARK: - UITableViewDelegate

extension StocksViewController: UITableViewDelegate {
   
}

// MARK: - UITableViewDataSource

extension StocksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockCell.reuseIdentifite,
                                                       for: indexPath) as? StockCell else { return UITableViewCell() }
        cell.setValue(stock: stockList[indexPath.row], index: indexPath.row)
        cell.selectionStyle = .none
        return cell
    }
}
