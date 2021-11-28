//
//  TransactionTableViewCell.swift
//  BudgetApp
//
//  Created by Vadym Boiko on 25.11.2021.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "TransactionTableViewCell"
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(amountLabel)
        setConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTransactionCell(with transaction: Transaction) {
        self.textLabel?.text = transaction.category
        self.detailTextLabel?.text = transaction.date?.formatDate()
        self.amountLabel.text = String(transaction.amount) + " " + (transaction.currency ?? "")
        
        //For expences - red color, income - green color.
        if transaction.type == TransactionTypes.expence.rawValue {
            self.amountLabel.textColor = .red
        } else {
            self.amountLabel.textColor = .green
        }
    }
    
    func setupCategoryCell(with category: Category){
        self.textLabel?.text = category.name
        self.amountLabel.text = "\(category.sum) " + (category.currency)
        self.amountLabel.textColor = .red
    }
    
    private func setConstrains() {
        NSLayoutConstraint.activate([
            amountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
}
