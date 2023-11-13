//
//  DataSource.swift
//  Finance
//
//  Created by Александр Меренков on 13.11.2023.
//

import UIKit

final class ProgressDataSource: UITableViewDiffableDataSource<ProgressSection, ProgressItem> {
    init(_ tableView: UITableView, delegate: ProgressCellDelegate) {
        super.init(tableView: tableView) { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProgressCell.reuseIdentifire, for: indexPath) as? ProgressCell else {
                return UITableViewCell()
            }
            cell.configure(with: itemIdentifier)
            cell.delegate = delegate
            return cell
        }
    }
}
