//
//  StocksController.swift
//  Finance
//
//  Created by Александр Меренков on 22.09.2022.
//

import UIKit

final class StocksController: UIViewController {
    
//    MARK: - Properties
    
    private var tableView: UITableView?
    private let loadAnimationView = CircleAnimation()
    private var stockList: [Stock] = [Stock(symbol: "APLE"), Stock(symbol: "AMZN"), Stock(symbol: "GOOG"), Stock(symbol: "MCD"), Stock(symbol: "NKE"), Stock(symbol: "SNAP"), Stock(symbol: "UBER")]
    private let dayInSeconds = 86400.0
    
//    MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getInformation()
        configureAnimationView()
        configureTableView()
        view.backgroundColor = .white
    }
    
//    MARK: - Helpers

    private func getInformation() {
        let currentDate = Date() - dayInSeconds
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let stringDate = formatter.string(from: currentDate)
        DispatchQueue.main.async {
            NetworkService.shared.loadStockRate(date: stringDate) { results in
                switch results {
                case .success(let results):
                    for i in 0..<self.stockList.count {
                        if let answer = results.first(where: { $0.symbol == self.stockList[i].symbol }) {
                            self.stockList[i].value = answer.value
                        }
                    }
                    self.tableView?.reloadData()
                    self.loadAnimationView.isHidden = true
                    self.tableView?.isHidden = false
                case .failure(let error):
                    self.alert(with: "Ошибка", massage: error.localizedDescription) { result in
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
        }
    }
    
    private func configureAnimationView() {
        view.addSubview(loadAnimationView)
        loadAnimationView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadAnimationView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 15)
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
        tableView.anchor(left: view.leftAnchor, top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor)
        tableView.isHidden = true
    }
}

//  MARK: - UITableViewDelegate

extension StocksController: UITableViewDelegate {
    
}

//  MARK: - UITableViewDataSource

extension StocksController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockCell.reuseIdentifite, for: indexPath) as? StockCell else { return UITableViewCell() }
        cell.setValue(stock: stockList[indexPath.row], index: indexPath.row)
        return cell
    }
}
