//
//  StockAdapter.swift
//  Finance
//
//  Created by Александр Меренков on 31.08.2023.
//

import UIKit

final class StockAdapter: NSObject {
    
    // MARK: - Properties
    
    private var stockList = [Stock]()
    private var currencyRate: Double = 1
    
    // MARK: - Helpers
    
    func configure(_ stockList: [Stock], rate: Double) {
        self.stockList = stockList
        self.currencyRate = rate
    }
}

// MARK: - UITableViewDataSource

extension StockAdapter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockCell.reuseIdentifite,
                                                       for: indexPath) as? StockCell else { return UITableViewCell() }
        cell.setValue(stock: stockList[indexPath.row], index: indexPath.row, rate: currencyRate)
        cell.selectionStyle = .none
        return cell
    }
}
