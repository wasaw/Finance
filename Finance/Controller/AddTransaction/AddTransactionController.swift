//
//  AddTransactionController.swift
//  Finance
//
//  Created by Александр Меренков on 17.06.2022.
//

import UIKit

final class AddTransactionController: UIViewController {
    
//    MARK: - Properties
    
    private var currentUser = CurrentUser()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let typeTitleView = TitleView()
    private var typeCollectionView: UICollectionView?
    
    private let categoryTitleView = TitleView()
    private var categoryCollectionView: UICollectionView?
   
    private let revenueView = RevenueView()
    private let amountView = AmountView()
    
    private var addTransaction = LastTransaction()

    private let databaseService = DatabaseService.shared
    private var revenue = [ChoiceTypeRevenue]() {
        didSet {
            typeCollectionView?.reloadData()
        }
    }
    private var category = [ChoiceCategoryExpense]() {
        didSet {
            categoryCollectionView?.reloadData()
        }
    }
    private var isRevenue = false
    private let datePicker = UIDatePicker()
    private var selectedType: Int? = nil {
        didSet {
            typeCollectionView?.reloadData()
        }
    }
    private var selectedCategory: Int? = nil {
        didSet {
            categoryCollectionView?.reloadData()
        }
    }

//    MARK: - Lifecycle
    
    init(_ currentUser: CurrentUser) {
        super.init(nibName: nil, bundle: nil)

        self.currentUser = currentUser
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        loadInformation()
        amountView.delegate = self
        configureUI()
        setDate()
        view.backgroundColor = .white
    }
    
//    MARK: - Helpers
    
    private func loadInformation() {
        DispatchQueue.main.async {
            self.databaseService.getCategoryInformation { result in
                switch result {
                case .success(let category):
                    self.category = category
                    self.databaseService.getTypeInformation { result in
                        switch result {
                        case .success(let revenue):
                            self.revenue = revenue
                        case .failure(let error):
                            self.alert(with: "Ошибка", massage: error.localizedDescription)
                        }
                    }
                case .failure(let error):
                    self.alert(with: "Ошибка", massage: error.localizedDescription)
                }
            }
        }
    }
    
    private func configureUI() {
        configureScrollView()
        configureTypeTitleView()
        configureTypeCollectionView()
        configureCategoryTitleView()
        configureCategoryCollectionView()
        configureRevenueView()
        configureAmountView()
    }
    
    func configureScrollView(){
        view.addSubview(scrollView)
        scrollView.anchor(left: view.leftAnchor, top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor)

        scrollView.addSubview(contentView)
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.anchor(left: scrollView.leftAnchor, top: scrollView.topAnchor, right: scrollView.rightAnchor, bottom: scrollView.bottomAnchor, height: 830)
    }

    private func configureTypeTitleView() {
        contentView.addSubview(typeTitleView)
        typeTitleView.anchor(left: contentView.leftAnchor, top: contentView.topAnchor, right: contentView.rightAnchor, paddingLeft: 10, paddingTop: 20, paddingRight: -10, height: 30)
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
        typeCollectionView.anchor(left: contentView.leftAnchor, top: typeTitleView.bottomAnchor, right: contentView.rightAnchor, paddingLeft: 10, paddingTop: 10, paddingRight: -10, height: 90)
    }
   
    private func configureCategoryTitleView() {
        contentView.addSubview(categoryTitleView)
        guard let typeCollectionView = typeCollectionView else { return }
        categoryTitleView.anchor(left: contentView.leftAnchor, top: typeCollectionView.bottomAnchor, right: contentView.rightAnchor, paddingLeft: 10, paddingTop: 10, paddingRight: -10, height: 30)
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
        categotyCollectionView.anchor(left: contentView.leftAnchor, top: categoryTitleView.bottomAnchor, right: contentView.rightAnchor, paddingLeft: 10, paddingTop: 10, paddingRight: -10, height: 135)
    }
    
    private func configureRevenueView() {
        contentView.addSubview(revenueView)
        revenueView.delegate = self
        guard let categoryCollectionView = categoryCollectionView else { return }
        revenueView.anchor(left: contentView.leftAnchor, top: categoryCollectionView.bottomAnchor, right: contentView.rightAnchor, paddingLeft: 20, paddingTop: 10, paddingRight: -20, height: 20)
    }
    
    private func configureAmountView() {
        contentView.addSubview(amountView)
        amountView.anchor(left: contentView.leftAnchor, top: revenueView.bottomAnchor, right: contentView.rightAnchor, bottom: contentView.safeAreaLayoutGuide.bottomAnchor, paddingLeft: 10, paddingTop: 20, paddingRight: -10)
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
    
//    MARK: - Selectors
    
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

//  MARK: - Extensions

extension AddTransactionController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.typeCollectionView {
            selectedType = indexPath.row
        }
        if collectionView == self.categoryCollectionView {
            selectedCategory = indexPath.row
        }
    }
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TypeCell.identifire, for: indexPath) as? TypeCell else { return UICollectionViewCell() }
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifire, for: indexPath) as? CategoryCell else { return UICollectionViewCell() }
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

extension AddTransactionController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.typeCollectionView {
            return CGSize(width: 90, height: 80)
        }
        return CGSize(width: 90, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
    }
}

extension AddTransactionController: HandleDoneDelegate {
    func saveInformation(amount: String, date: String, comment: String) {
        let isFillingCompleted = checkCompleted(amount, date)
        if isFillingCompleted.0 {
            let amountDouble = Double(amount) ?? 0
            addTransaction.amount = isRevenue ? amountDouble : -1 * amountDouble
            addTransaction.amount = addTransaction.amount * CurrencyRate.rate
            addTransaction.comment = comment
            databaseService.saveTransaction(transaction: addTransaction) { result in
                switch result {
                case .success(_):
                    self.dismiss(animated: true)
                case .failure(let error):
                    self.alert(with: "Ошибка", massage: error.localizedDescription)
                }
            }
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

extension AddTransactionController: SwitcherValueDelegate {
    func switchChanged(value: Bool) {
        isRevenue = value
    }
}

extension AddTransactionController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        amountView.commentTextField.resignFirstResponder()
        return true
    }
}
