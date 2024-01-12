//
//  ChartDataSource.swift
//  Finance
//
//  Created by Александр Меренков on 11.01.2024.
//

import UIKit

final class ChartDataSource: UITableViewDiffableDataSource<Int, ChartCell.DisplayData> {
    init(_ tableView: UITableView) {
        super.init(tableView: tableView) { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChartCell.reuseIdentifire, for: indexPath) as? ChartCell else {
                return UITableViewCell()
            }
            cell.configure(itemIdentifier)
            return cell
        }
    }
}
