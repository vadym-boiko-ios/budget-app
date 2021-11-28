//
//  TransactionViewController.swift
//  BudgetApp
//
//  Created by Vadym Boiko on 24.11.2021.
//

import UIKit
import DropDown
import CoreData

class TransactionViewController: UIViewController {
    
    var completion: ((Transaction) -> ())?
    
    //MARK: - Create Views
    let dropDown = DropDown()
    
    let accountDropDownButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitleColor(.systemGray3, for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0,
                                              left: 10,
                                              bottom: 0,
                                              right: 0)
        button.contentHorizontalAlignment = .left
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.black.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self,
                         action: #selector(tapDropDownButton(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    let categoryDropDownButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitleColor(.systemGray3, for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0,
                                              left: 10,
                                              bottom: 0,
                                              right: 0)
        button.contentHorizontalAlignment = .left
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.black.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self,
                         action: #selector(tapDropDownButton(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter amount"
        textField.leftView = UIView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: 10,
                                                  height: textField.frame.height))
        textField.leftViewMode = .always
        textField.layer.borderWidth = 1.0
        textField.keyboardType = .decimalPad
        textField.layer.borderColor = UIColor.black.cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var segmentedControl = UISegmentedControl()
    private var stackView = UIStackView()
    
    //MARK: - Default State
    
    let transactionTypes = TransactionTypes.allCases.map { $0.rawValue }
    let accountsTypes = ["Cash", "Credit Card", "Bank Account"]
    var categoriesTypes = [String]()
    
    func getCategoryType(for transactionType: TransactionTypes) {
        switch transactionType {
        case .income:
            categoriesTypes = ["Wages", "Dividends"]
        case .expence:
            categoriesTypes = ["Taxes", "Grocery", "Entertainment", "Gym", "Health"]
        }
    }
    
    //Default UI state for transaction fields
    //Purpose - reset after segmented control have switched
    func defaultTransactionFieldsState() {
        accountDropDownButton.setTitle("Select account", for: .normal)
        categoryDropDownButton.setTitle("Select category", for: .normal)
        
        accountDropDownButton.setTitleColor(.systemGray3, for: .normal)
        categoryDropDownButton.setTitleColor(.systemGray3, for: .normal)
        
        amountTextField.text = ""
    }
            
    //MARK: - Setup Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstrains()
        setupNavigationBar()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        defaultTransactionFieldsState()
        setupSegmentedControll()
        stackView = UIStackView(arrangedSubviews: [accountDropDownButton, categoryDropDownButton, amountTextField],
                                axis: .vertical,
                                spacing: 20,
                                distribution: .fillEqually)
        view.addSubview(stackView)
    }
    
    //MARK: - Set NavigationBar
    
    private func setupNavigationBar() {
        navigationItem.title = "Add transaction"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(dismissTransactionViewController))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(createTransaction))
    }
    
    @objc func dismissTransactionViewController() {
        self.dismiss(animated: true)
    }
    
    //MARK: - Set SegmentedConroll
    
    private func setupSegmentedControll() {
        //Set default transaction type - Income
        getCategoryType(for: .income)
        segmentedControl = UISegmentedControl(items: transactionTypes)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self,
                                   action: #selector(segmentAction(_:)),
                                   for: .valueChanged)
        view.addSubview(segmentedControl)
    }
    
    @objc private func segmentAction(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            getCategoryType(for: .income)
            sender.selectedSegmentIndex = 0
        default:
            getCategoryType(for: .expence)
            sender.selectedSegmentIndex = 1
        }
        defaultTransactionFieldsState()
    }
    
    //MARK: - Set DropDown feature
    
    @objc private func tapDropDownButton(_ sender: UIButton) {
        switch sender {
        case self.accountDropDownButton:
            dropDown.dataSource = accountsTypes
        case self.categoryDropDownButton:
            dropDown.dataSource = categoriesTypes
        default:
            dropDown.dataSource = [String]()
        }
        
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        dropDown.show()
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let _ = self else { return }
            sender.setTitle(item, for: .normal)
            sender.setTitleColor(.black, for: .normal)
        }
    }
    
    
    //MARK: - Creating transaction object and passing data back to ControllPanelViewController

    @objc func createTransaction()  {
        guard let account = accountDropDownButton.currentTitle,
              let category = categoryDropDownButton.currentTitle,
              let textAmount = amountTextField.text,
              !textAmount.isEmpty,
              account != "Select account",
              category != "Select category" else { return }
        
        var amount = textAmount.doubleValue
        let type = transactionTypes[segmentedControl.selectedSegmentIndex]
        
        //Expence type - negative numbers, Income type - positive
        if type == TransactionTypes.expence.rawValue {
             amount = -(amount)
        }
        let date = Date()
        
        //User's current locale to display the transaction currency
        //Can't save NumberFormatter to CoreDate. Chose string type.
        let currency = NumberFormatter.currencyFormatter.currencySymbol ?? ""

        createTransactionAndSave(type: type, account: account, category: category, amount: amount, date: date, currency: currency)
    }

    func passData(transaction: Transaction) {
        completion?(transaction)
        dismissTransactionViewController()
    }

    // MARK: - CoreData
    
    func createTransactionAndSave(type: String, account: String, category: String, amount: Double, date: Date, currency: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Transaction", in: context) else { return }
        
        let transaction = Transaction(entity: entity, insertInto: context)
        transaction.type = type
        transaction.account = account
        transaction.category = category
        transaction.date = date
        transaction.amount = amount
        transaction.currency = currency
        
        do {
            try context.save()
        } catch let error as NSError {
            print (error.localizedDescription)
        }
        passData(transaction: transaction)
    }
    
    //MARK: - Set Constrains
    
    private func setConstrains(){
        NSLayoutConstraint.activate([
            
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 35),
            segmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            
            stackView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            accountDropDownButton.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
}

