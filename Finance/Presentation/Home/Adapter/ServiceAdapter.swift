//
//  ServiceAdapter.swift
//  Finance
//
//  Created by Александр Меренков on 31.08.2023.
//

import UIKit

final class ServiceAdapter: NSObject {
    
// MARK: - Properties
    
    private var service: [ChoiceService] = []
    
// MARK: - Helpers
    
    func configure(_ service: [ChoiceService]) {
        self.service = service
    }
}

// MARK: - UICollectionViewDataSource

extension ServiceAdapter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return service.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ServicesCell.identifire,
                                                            for: indexPath) as? ServicesCell else { return UICollectionViewCell() }
        cell.setInformation(service: service[indexPath.row])
        return cell
    }
}
