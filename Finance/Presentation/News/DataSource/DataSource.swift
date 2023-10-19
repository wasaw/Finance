//
//  DataSource.swift
//  Finance
//
//  Created by Александр Меренков on 19.10.2023.
//

import UIKit

final class DataSource: UITableViewDiffableDataSource<Section, NewsItem> {
    init(_ tableView: UITableView) {
        super.init(tableView: tableView) { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.reuseIdentifire, for: indexPath) as? NewsCell else {
                return UITableViewCell()
            }
            cell.configure(with: itemIdentifier)
            return cell
        }
    }
}
