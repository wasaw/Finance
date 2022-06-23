//
//  AddTransactionController.swift
//  Finance
//
//  Created by Александр Меренков on 17.06.2022.
//

import UIKit

class AddTransactionController: UIViewController {
    
//    MARK: - Properties
    
    private let typeTitleView = TitleView()
    private var typeCollectionView: UICollectionView?
    
    private let categoryTitleView = TitleView()
    private var categoryCollectionView: UICollectionView?
    
    private let revenueView = RevenueView()
    private let ammountView = AmmountView()
    
//    MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        view.backgroundColor = .white
    }
    
//    MARK: - Helpers
    
    private func configureUI() {
        configureTypeTitleView()
        configureTypeCollectionView()
        configureCategoryTitleView()
        configureCategoryCollectionView()
        configureRevenueView()
        configureAmmountView()
    }
    
    private func configureTypeTitleView() {
        view.addSubview(typeTitleView)
        
        typeTitleView.translatesAutoresizingMaskIntoConstraints = false
        typeTitleView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        typeTitleView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        typeTitleView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        typeTitleView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        typeTitleView.setTitle(title: "Выбрать тип")
    }
    
    private func configureTypeCollectionView() {
        let typeLayout = UICollectionViewFlowLayout()
        typeLayout.scrollDirection = .horizontal
        typeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: typeLayout)
        guard let typeCollectionView = typeCollectionView else { return }
        typeCollectionView.register(AddCell.self, forCellWithReuseIdentifier: AddCell.identifire)
        typeCollectionView.delegate = self
        typeCollectionView.dataSource = self
        typeCollectionView.showsHorizontalScrollIndicator = false
        view.addSubview(typeCollectionView)
        
        typeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        typeCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        typeCollectionView.topAnchor.constraint(equalTo: typeTitleView.bottomAnchor, constant: 10).isActive = true
        typeCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        typeCollectionView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    private func configureCategoryTitleView() {
        view.addSubview(categoryTitleView)
        
        categoryTitleView.translatesAutoresizingMaskIntoConstraints = false
        categoryTitleView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        categoryTitleView.topAnchor.constraint(equalTo: typeCollectionView!.bottomAnchor, constant: 15).isActive = true
        categoryTitleView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        categoryTitleView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        categoryTitleView.setTitle(title: "Выбрать категорию")
    }
    
    private func configureCategoryCollectionView() {
        let categoryLayout = UICollectionViewFlowLayout()
        categoryLayout.scrollDirection = .horizontal
        categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: categoryLayout)
        guard let categotyCollectionView = categoryCollectionView else { return }
        categotyCollectionView.register(AddCell.self, forCellWithReuseIdentifier: AddCell.identifire)
        categotyCollectionView.delegate = self
        categotyCollectionView.dataSource = self
        categotyCollectionView.showsHorizontalScrollIndicator = false
        view.addSubview(categotyCollectionView)
        
        categotyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        categotyCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        categotyCollectionView.topAnchor.constraint(equalTo: categoryTitleView.bottomAnchor, constant: 10).isActive = true
        categotyCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        categotyCollectionView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    private func configureRevenueView() {
        view.addSubview(revenueView)
        
        revenueView.translatesAutoresizingMaskIntoConstraints = false
        revenueView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        revenueView.topAnchor.constraint(equalTo: categoryCollectionView!.bottomAnchor).isActive = true
        revenueView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        revenueView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func configureAmmountView() {
        view.addSubview(ammountView)
        
        ammountView.translatesAutoresizingMaskIntoConstraints = false
        ammountView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        ammountView.topAnchor.constraint(equalTo: revenueView.bottomAnchor, constant: 10).isActive = true
        ammountView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        ammountView.heightAnchor.constraint(equalToConstant: 270).isActive = true
    }
}

//  MARK: - Extensions

extension AddTransactionController: UICollectionViewDelegate {
    
}

extension AddTransactionController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.typeCollectionView {
            return revenue.count
        }
        if collectionView == self.categoryCollectionView {
            return category.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.typeCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddCell.identifire, for: indexPath) as? AddCell else { return UICollectionViewCell() }
            cell.setTitle(revenue[indexPath.row].name)
            cell.setImage(img: revenue[indexPath.row].img)
            return cell
        }
        if collectionView == self.categoryCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddCell.identifire, for: indexPath) as? AddCell else { return UICollectionViewCell() }
            cell.setTitle(category[indexPath.row].name)
            cell.setImage(img: category[indexPath.row].img)
            cell.hideCost(true)
            return cell
        }
        return UICollectionViewCell()
    }
}

extension AddTransactionController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 95)
    }
}
