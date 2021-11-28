//
//  ViewController.swift
//  BudgetApp
//
//  Created by Vadym Boiko on 24.11.2021.
//

import UIKit
import CoreData

class ControlPanelViewController: UITableViewController {
    
    var completion: (([Transaction]) -> ())?
    var transactions = [Transaction]()
    var accounts = [Account]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
        fetchData()
        createDataSourse()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        passData()
    }
        
    private func setupTableView() {
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: TransactionTableViewCell.reuseIdentifier)
        tableView.separatorInset = .zero
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = .zero
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Dashboard"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(presentTransactionViewController))
    }
    
    @objc func presentTransactionViewController() {
        let vs = UINavigationController(rootViewController: TransactionViewController())
        let rs = vs.viewControllers.first as! TransactionViewController
        
        //Present controller and wait until the callback ends and return Transaction object
        //Then create accounts array datasourse for tableview
        rs.completion = { [weak self] transaction in
            self?.transactions.insert(transaction, at: 0)
            self?.createDataSourse()
        }
        
        vs.modalPresentationStyle = .fullScreen
        present(vs, animated: true)
    }
    
    func createDataSourse() {
        let groupedAccountsDictionary = Dictionary(grouping: transactions) { $0.account }
        let keys = groupedAccountsDictionary.keys
        accounts = keys.map {
            Account(
                name: $0 ?? "",
                list: groupedAccountsDictionary[$0] ?? []
            )
        }
    }
    
    //Pass recieved data from callback to ExpenseStatisticsViewController
    func passData() {
        completion?(transactions)
    }
    
    func fetchData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()

        do {
            transactions = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print (error.localizedDescription)
        }
    }
}

//MARK: - Set TableViewDelegate and TableViewDataSource

extension ControlPanelViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.reuseIdentifier) as? TransactionTableViewCell else
        {
            let cell = TransactionTableViewCell(style: .default, reuseIdentifier: TransactionTableViewCell.reuseIdentifier)
            return cell
        }
        let transaction = accounts[indexPath.section].list[indexPath.row]
        cell.setupTransactionCell(with: transaction)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //view up to 10 recent transactions for each account
        if accounts[section].list.count >= 10 {
            return 10
        } else {
            return accounts[section].list.count
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        accounts.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            accounts[indexPath.section].list.remove(at: indexPath.row)
            //consequences of a bad decision of duplicating transaction array to accounts
            transactions.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
     
// MARK: - STACKPOINT
//Stack with display of cells after deleting and updating database
//Guess this is the consequences of a bad decision of duplicating transaction array to accounts array
            
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            let context = appDelegate.persistentContainer.viewContext
//
//            let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
//            if let transactions = try? context.fetch(fetchRequest) {
//                    context.delete(transactions[indexPath.row])
//                do {
//                    try context.save()
//                } catch let error as NSError {
//                    print (error.localizedDescription)
//                }
//            }
        }
        
        if self.accounts[indexPath.section].list.isEmpty {
            self.accounts.remove(at: indexPath.section)
            self.tableView.deleteSections(IndexSet(arrayLiteral: indexPath.section), with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = SectionHeaderFooterView()
        let account = accounts[section]
        
        if transactions.isEmpty {
            view.isHidden = true
            return view
        }
        view.setupForHeader(with: account)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        35
    }
}


