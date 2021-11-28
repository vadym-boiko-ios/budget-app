//
//  SectionHeaderView.swift
//  BudgetApp
//
//  Created by Vadym Boiko on 25.11.2021.
//

import UIKit

class SectionHeaderFooterView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Total"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemGray5
        self.addSubview(titleLabel)
        self.addSubview(amountLabel)
        setConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Setup header for sections in ControlPanelViewController
    func setupForHeader(with account: Account) {
        titleLabel.text = account.name
        amountLabel.text = "\(account.sum) " + (account.list.first?.currency ?? "")
    }
    
    //Setup footer for tableview in ExpenseStatisticsController
    func setupForFooter(with categoriesTotal: String) {
        if !categoriesTotal.isEmpty {
            amountLabel.text = categoriesTotal
        }
    }
    
    private func setConstrains() {
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            amountLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            amountLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
