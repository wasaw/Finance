//
//  HomeController.swift
//  Finance
//
//  Created by Александр Меренков on 08.06.2022.
//

import UIKit

class HomeController: UIViewController {
    
//    MARK: - Properties
    
    private let profileHeaderView = ProfileHeaderView()
    private let totalAccountView = TotalAccountView()
    private let servicesTitleView = TitleView()
    private let transactionTitleView = TitleView()
    
    private var servicesCollectionView: UICollectionView?
    private var lastTransactionsCollectionView: UICollectionView?
    
//    MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        view.backgroundColor = .backgroundColor
    }
    
//    MARK: - Helpers
    
    private func configureUI() {
        configureProfileHeaderView()
        configureTotalAccountView()
        configureServicesTitleView()
        configureServicesCollectionView()
        configureTransactionTitleView()
        configureLastTransactionsCollectionView()
    }
    
    private func configureProfileHeaderView() {
        view.addSubview(profileHeaderView)
        
        profileHeaderView.translatesAutoresizingMaskIntoConstraints = false
        profileHeaderView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        profileHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        profileHeaderView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        profileHeaderView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func configureTotalAccountView() {
        view.addSubview(totalAccountView)
        
        totalAccountView.translatesAutoresizingMaskIntoConstraints = false
        totalAccountView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        totalAccountView.topAnchor.constraint(equalTo: profileHeaderView.bottomAnchor, constant: 20).isActive = true
        totalAccountView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        totalAccountView.heightAnchor.constraint(equalToConstant: 180).isActive = true
    }
    
    private func configureServicesTitleView() {
        view.addSubview(servicesTitleView)
        
        servicesTitleView.translatesAutoresizingMaskIntoConstraints = false
        servicesTitleView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        servicesTitleView.topAnchor.constraint(equalTo: totalAccountView.bottomAnchor, constant: 25).isActive = true
        servicesTitleView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        servicesTitleView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        servicesTitleView.setTitle(title: "Сервисы")
    }
    
    private func configureServicesCollectionView() {
        let servicesLayout = UICollectionViewFlowLayout()
        servicesLayout.scrollDirection = .horizontal
        servicesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: servicesLayout)
        guard let servicesCollectionView = servicesCollectionView else { return }
        servicesCollectionView.register(ServicesCell.self, forCellWithReuseIdentifier: ServicesCell.identifire)
        servicesCollectionView.delegate = self
        servicesCollectionView.dataSource = self
        servicesCollectionView.showsHorizontalScrollIndicator = false
        view.addSubview(servicesCollectionView)
        
        servicesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        servicesCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        servicesCollectionView.topAnchor.constraint(equalTo: servicesTitleView.bottomAnchor, constant: 10).isActive = true
        servicesCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        servicesCollectionView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        servicesCollectionView.backgroundColor = .backgroundColor
    }
    
    private func configureTransactionTitleView() {
        guard let servicesCollectionView = servicesCollectionView else { return }
        view.addSubview(transactionTitleView)
        transactionTitleView.translatesAutoresizingMaskIntoConstraints = false
        transactionTitleView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        transactionTitleView.topAnchor.constraint(equalTo: servicesCollectionView.bottomAnchor, constant: 15).isActive = true
        transactionTitleView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        transactionTitleView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        transactionTitleView.setTitle(title: "Последние транзакции")
    }
    
    private func configureLastTransactionsCollectionView() {
        let transactionsLayout = UICollectionViewFlowLayout()
        lastTransactionsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: transactionsLayout)
        guard let lastTransactionsCollectionView = lastTransactionsCollectionView else { return }
        lastTransactionsCollectionView.register(LastTransactionCell.self, forCellWithReuseIdentifier: LastTransactionCell.identifire)
        lastTransactionsCollectionView.delegate = self
        lastTransactionsCollectionView.dataSource = self
        view.addSubview(lastTransactionsCollectionView)
        
        lastTransactionsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        lastTransactionsCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        lastTransactionsCollectionView.topAnchor.constraint(equalTo: transactionTitleView.bottomAnchor, constant: 10).isActive = true
        lastTransactionsCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        lastTransactionsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5).isActive = true
        
        lastTransactionsCollectionView.backgroundColor = .backgroundColor
    }
}

//  MARK: - Extensions

extension HomeController: UICollectionViewDelegate {
    
}

extension HomeController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.servicesCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ServicesCell.identifire, for: indexPath) as? ServicesCell else { return UICollectionViewCell() }


            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LastTransactionCell.identifire, for: indexPath) as? LastTransactionCell else { return UICollectionViewCell() }
            
            return cell
        }
    }
}

extension HomeController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.servicesCollectionView {
            return CGSize(width: 80, height: 110)
        }
        guard let width = lastTransactionsCollectionView?.frame.width else { return CGSize(width: 0, height: 0) }
        return CGSize(width: width, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.servicesCollectionView {
            return 25
        }
        return 5
    }
}
