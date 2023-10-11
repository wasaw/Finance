//
//  LastTransactionsAdapter.swift
//  Finance
//
//  Created by Александр Меренков on 31.08.2023.
//

import UIKit

final class LastTransactionsAdapter: NSObject {
    
// MARK: - Properties
    
    private var transaction: [Transaction] = []

// MARK: - Helpers
    
    func configure(transaction: [Transaction]) {
        self.transaction = transaction
    }
}

// MARK: - UICollectionViewDataSource

extension LastTransactionsAdapter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return transaction.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LastTransactionCell.identifire,
                                                            for: indexPath) as? LastTransactionCell else { return UICollectionViewCell() }
        cell.setInformation(lastTransaction: transaction[indexPath.row])
        return cell
    }
}
