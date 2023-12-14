//
//  AccountAdapter.swift
//  Finance
//
//  Created by Александр Меренков on 28.08.2023.
//

import UIKit

final class AccountAdaper: NSObject {
    
// MARK: - Properties
    
    private var account = [AccountCellModel]()
    private var isSelected = 0

// MARK: - Helpers
    
    func configure(_ typeCellValues: [AccountCellModel]) {
        self.account = typeCellValues
    }
    
    func setSelected(at index: Int) {
        isSelected = index
    }
}

// MARK: - UICollectionViewDataSource

extension AccountAdaper: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return account.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountCell.identifire,
                                                            for: indexPath) as? AccountCell else { return UICollectionViewCell() }
        let currentRevenue = account[indexPath.row]
//        let amount = currentRevenue.amount / currencyRate
        cell.setInfornation(account: account[indexPath.row])
        cell.disableSelect()
        if isSelected == indexPath.row {
            cell.setSelect()
        }
        return cell
    }
}
