//
//  AllTransactionsDataSource.swift
//  Finance
//
//  Created by Александр Меренков on 16.01.2024.
//

import UIKit

final class AllTransactionsDataSource: UITableViewDiffableDataSource<Int, AllTransactionsCell.DisplayData> {
    init(_ tableView: UITableView) {
        super.init(tableView: tableView) { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AllTransactionsCell.reuseIdentifire, for: indexPath) as? AllTransactionsCell else {
                return UITableViewCell()
            }
            cell.configure(itemIdentifier)
            return cell
        }
    }
}
