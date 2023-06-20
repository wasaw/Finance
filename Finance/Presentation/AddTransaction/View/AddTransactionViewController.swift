//
//  AddTransactionViewController.swift
//  Finance
//
//  Created by Александр Меренков on 16.06.2023.
//

import UIKit

final class AddTransactionViewController: UIViewController {
    
// MARK: - Properties
    
    private let output = AddTransactionPresenter()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let typeTitleView = TitleView()
    private var typeCollectionView: UICollectionView?
    
    private let categoryTitleView = TitleView()
    private var categoryCollectionView: UICollectionView?
    
    private let revenueView = RevenueView()
    private let amountView = AmountView()
    
    private var addTransaction = LastTransaction()
    
    private var isRevenue = false
    private let datePicker = UIDatePicker()
        
    private var revenue = [ChoiceTypeRevenue]()
    private var category = [ChoiceCategoryExpense]()
    private var selectedType: Int? {
        didSet {
            typeCollectionView?.reloadData()
        }
    }
    private var selectedCategory: Int? {
        didSet {
            categoryCollectionView?.reloadData()
        }
    }
    
// MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.input = self
        configureUI()
        contentView.backgroundColor = .white
        view.backgroundColor = .white
        amountView.delegate = self
        setDate()
        output.viewIsReady()
    }
    
// MARK: - Helpers
    
    private func configureUI() {
        configureScrollView()
        configureTypeTitleView()
        configureTypeCollectionView()
        configureCategoryTitleView()
        configureCategoryCollectionView()
        configureRevenueView()
        configureAmountView()
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.anchor(leading: view.leadingAnchor,
                          top: view.topAnchor,
                          trailing: view.trailingAnchor,
                          bottom: view.bottomAnchor)

        scrollView.addSubview(contentView)
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.anchor(leading: scrollView.leadingAnchor,
                           top: scrollView.topAnchor,
                           trailing: scrollView.trailingAnchor,
                           bottom: scrollView.bottomAnchor,
                           height: 830)
    }
    
    private func configureTypeTitleView() {
        contentView.addSubview(typeTitleView)
        typeTitleView.anchor(leading: contentView.leadingAnchor,
                             top: contentView.topAnchor,
                             trailing: contentView.trailingAnchor,
                             paddingLeading: 10,
                             paddingTop: 20,
                             paddingTrailing: -10,
                             height: 30)
        typeTitleView.setTitle(title: "Выбрать тип дохода")
    }
    
    private func configureTypeCollectionView() {
        let typeLayout = UICollectionViewFlowLayout()
        typeLayout.scrollDirection = .horizontal
        typeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: typeLayout)
        guard let typeCollectionView = typeCollectionView else { return }
        typeCollectionView.register(TypeCell.self, forCellWithReuseIdentifier: TypeCell.identifire)
        typeCollectionView.delegate = self
        typeCollectionView.dataSource = self
        typeCollectionView.showsHorizontalScrollIndicator = false
        typeCollectionView.backgroundColor = .white
        contentView.addSubview(typeCollectionView)
        typeCollectionView.anchor(leading: contentView.leadingAnchor,
                                  top: typeTitleView.bottomAnchor,
                                  trailing: contentView.trailingAnchor,
                                  paddingLeading: 10,
                                  paddingTop: 10,
                                  paddingTrailing: -10,
                                  height: 90)
    }
    
    private func configureCategoryTitleView() {
        contentView.addSubview(categoryTitleView)
        guard let typeCollectionView = typeCollectionView else { return }
        categoryTitleView.anchor(leading: contentView.leadingAnchor,
                                 top: typeCollectionView.bottomAnchor,
                                 trailing: contentView.trailingAnchor,
                                 paddingLeading: 10,
                                 paddingTop: 10,
                                 paddingTrailing: -10,
                                 height: 30)
        categoryTitleView.setTitle(title: "Выбрать категорию трат")
    }
    
    private func configureCategoryCollectionView() {
        let categoryLayout = UICollectionViewFlowLayout()
        categoryLayout.scrollDirection = .horizontal
        categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: categoryLayout)
        guard let categotyCollectionView = categoryCollectionView else { return }
        categotyCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifire)
        categotyCollectionView.delegate = self
        categotyCollectionView.dataSource = self
        categotyCollectionView.showsHorizontalScrollIndicator = false
        categotyCollectionView.backgroundColor = .white
        contentView.addSubview(categotyCollectionView)
        categotyCollectionView.anchor(leading: contentView.leadingAnchor,
                                      top: categoryTitleView.bottomAnchor,
                                      trailing: contentView.trailingAnchor,
                                      paddingLeading: 10,
                                      paddingTop: 10,
                                      paddingTrailing: -10,
                                      height: 135)
    }
    
    private func configureRevenueView() {
        contentView.addSubview(revenueView)
        revenueView.delegate = self
        guard let categoryCollectionView = categoryCollectionView else { return }
        revenueView.anchor(leading: contentView.leadingAnchor,
                           top: categoryCollectionView.bottomAnchor,
                           trailing: contentView.trailingAnchor,
                           paddingLeading: 20,
                           paddingTop: 10,
                           paddingTrailing: -20,
                           height: 20)
    }
    
    private func configureAmountView() {
        contentView.addSubview(amountView)
        amountView.anchor(leading: contentView.leadingAnchor,
                          top: revenueView.bottomAnchor,
                          trailing: contentView.trailingAnchor,
                          bottom: contentView.safeAreaLayoutGuide.bottomAnchor,
                          paddingLeading: 10,
                          paddingTop: 20,
                          paddingTrailing: -10)
        configureKeyboard()
    }
    
    private func configureKeyboard() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(cancelAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBar.setItems([flexSpace, doneButton], animated: true)
        amountView.amountTextField.inputAccessoryView = toolBar
        amountView.commentTextField.delegate = self
    }
    
    private func checkCompleted(_ amount: String, _ date: String) -> (Bool, [String]) {
        var listForCompleted: [String] = []
        if selectedType == nil { listForCompleted.append("выберите тип дохода") }
        if selectedCategory == nil { listForCompleted.append("выберите категорию") }
        if amount == "" { listForCompleted.append("введите сумму")}
        if date == "" { listForCompleted.append("выберите дату")}
        if listForCompleted.isEmpty {
            return (true, [])
        } else {
            return (false, listForCompleted)
        }
    }
    
    private func setDate() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        toolBar.setItems([cancelButton, flexSpace, doneButton], animated: true)
        
        amountView.setDateConfiguration(datePicket: datePicker, toolBar: toolBar)
    }
    
// MARK: - Selectors
    
    @objc private func doneAction() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        amountView.setDateInformation(date: formatter.string(from: datePicker.date))
        addTransaction.date = datePicker.date
        view.endEditing(true)
    }
    
    @objc private func cancelAction() {
        view.endEditing(true)
    }
}

// MARK: - AddTransactionInput

extension AddTransactionViewController: AddTransactionInput {
    func showData(category: [ChoiceCategoryExpense], revenue: [ChoiceTypeRevenue]) {
        self.category = category
        self.revenue = revenue
        typeCollectionView?.reloadData()
        categoryCollectionView?.reloadData()
    }
    
    func dismissView() {
        self.dismiss(animated: true)
    }
    
    func showAlert(with title: String, and text: String) {
        self.alert(with: title, massage: text)
    }
}

// MARK: - UICollectionViewDelegate

extension AddTransactionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.typeCollectionView {
            selectedType = indexPath.row
        }
        if collectionView == self.categoryCollectionView {
            selectedCategory = indexPath.row
        }
    }
}

// MARK: - UICollectionViewDataSource

extension AddTransactionViewController: UICollectionViewDataSource {
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TypeCell.identifire,
                                                                for: indexPath) as? TypeCell else { return UICollectionViewCell() }
            let currentRevenue = revenue[indexPath.row]
            let amount = currentRevenue.amount / CurrencyRate.rate
            cell.setInfornation(title: currentRevenue.name, img: currentRevenue.img, amount: amount, currency: CurrencyRate.currentCurrency)
            cell.disableSelect()
            if selectedType == indexPath.row {
                cell.setSelect()
                addTransaction.type = revenue[indexPath.row].name
            }
            return cell
        }
        if collectionView == self.categoryCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifire,
                                                                for: indexPath) as? CategoryCell else { return UICollectionViewCell() }
            let currentCategory = category[indexPath.row]
            cell.setInfornation(title: currentCategory.name, img: currentCategory.img, currency: CurrencyRate.currentCurrency)
            cell.disableSelect()
            if selectedCategory == indexPath.row {
                cell.setSelect()
                addTransaction.category = category[indexPath.row].name
                addTransaction.img = category[indexPath.row].img
            }
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AddTransactionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.typeCollectionView {
            return CGSize(width: 90, height: 80)
        }
        return CGSize(width: 90, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
    }
}

extension AddTransactionViewController: HandleDoneDelegate {
    func saveInformation(amount: String, date: String, comment: String) {
        let isFillingCompleted = checkCompleted(amount, date)
        if isFillingCompleted.0 {
            let amountDouble = Double(amount) ?? 0
            addTransaction.amount = isRevenue ? amountDouble : -1 * amountDouble
            addTransaction.amount *= CurrencyRate.rate
            addTransaction.comment = comment
            output.saveTransaction(addTransaction)
        } else {
            var alertText = "Вы не выполнили следующие действия:\n"
            for alert in isFillingCompleted.1 {
                alertText += alert + "\n"
            }
            alertText.removeLast(1)
            let alert = UIAlertController(title: "Внимание", message: alertText, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension AddTransactionViewController: SwitcherValueDelegate {
    func switchChanged(value: Bool) {
        isRevenue = value
    }
}

extension AddTransactionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        amountView.commentTextField.resignFirstResponder()
        return true
    }
}
