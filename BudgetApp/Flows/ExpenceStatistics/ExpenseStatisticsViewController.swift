//
//  ExpenseStatisticsViewController.swift
//  BudgetApp
//
//  Created by Vadym Boiko on 24.11.2021.
//

import UIKit

class ExpenseStatisticsViewController: UITableViewController {
    
    var categories = [Category]()
    var total: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupTableView()
        getData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    private func setupNavigationBar() {
        navigationItem.title = "Expenses"
    }
    
    private func setupTableView() {
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: TransactionTableViewCell.reuseIdentifier)
        tableView.separatorInset = .zero
        tableView.sectionFooterHeight = 35
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = .zero
        }
    }
    
    func getData() {
        let vc = tabBarController?.viewControllers?.first as! UINavigationController
        let rc = vc.viewControllers.first as! ControlPanelViewController
        
        rc.completion = { [weak self] transactions in
            let groupedCategoriesDictionary = Dictionary(grouping: transactions.filter {$0.type == "Expence"}) { $0.category }
            self?.categories = groupedCategoriesDictionary.keys.map {
                Category(
                    name: $0 ?? "",
                    sum: groupedCategoriesDictionary[$0]?.map{$0.amount}.reduce(0,+) ?? 0,
                    currency: groupedCategoriesDictionary[$0]?.first?.currency ?? ""
                )
            }
        }
    }

}

//MARK: - Set TableViewDelegate and TableViewDataSource

extension ExpenseStatisticsViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.reuseIdentifier) as? TransactionTableViewCell else
        {
            let cell = TransactionTableViewCell(style: .default, reuseIdentifier: TransactionTableViewCell.reuseIdentifier)
            return cell
        }
        cell.setupCategoryCell(with: categories[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = SectionHeaderFooterView()
        total = categories.map{$0.sum}.reduce(0, +)
        let totalWithCurrencyString = "\(total) " + (categories.first?.currency ?? "")
        
        view.setupForFooter(with: totalWithCurrencyString)
        return view
    }
}



