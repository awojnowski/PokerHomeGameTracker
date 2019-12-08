//
//  TransactionsViewController.swift
//  PokerHomeGameTracker
//
//  Created by Aaron Wojnowski on 2019-11-30.
//  Copyright © 2019 Aaron Wojnowski. All rights reserved.
//

import UIKit

class TransactionsViewController: UIViewController, AddViewControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    private let transactionController = TransactionController()
    private static let dateFormatter = DateFormatter()
    private static let transactionsUserDefaultsKey = "cached_transactions"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: "TransactionCell")
        return tableView
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.title = "Poker Home Game"
        
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonTapped))
        self.navigationItem.rightBarButtonItem = addButton
        
        let optionsButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(optionsButtonTapped))
        self.navigationItem.leftBarButtonItem = optionsButton
        
        self.transactionController.loadPersistedTransactionsFromUserDefaults(key: TransactionsViewController.transactionsUserDefaultsKey)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup the view hierarchy
        
        self.view.addSubview(self.tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tableView.frame = self.view.bounds
    }

    // MARK: - Actions
    
    @objc private func addButtonTapped(sender: AnyObject) {
        let viewController = AddViewController(nibName: nil, bundle: nil)
        viewController.delegate = self
        let navigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @objc private func optionsButtonTapped(sender: AnyObject) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Player Statistics", style: .default, handler: { (action) in
            self.showPlayerStatistics()
        }))
        alertController.addAction(UIAlertAction(title: "Clear Transactions", style: .destructive, handler: { (action) in
            self.showClearTransactionsConfirmation()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showClearTransactionsConfirmation() {
        let alertController = UIAlertController(title: "Are you sure you wish to clear transactions?", message: "This operation cannot be undone.", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Clear Transactions", style: .destructive, handler: { (action) in
            self.transactionController.clearTransactions()
            self.transactionController.persistTransactionsToUserDefaults(key: TransactionsViewController.transactionsUserDefaultsKey)
            self.tableView.reloadData()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showPlayerStatistics() {
        // collect the statistics
        
        var totalBuyins = 0
        var totalCashouts = 0
        var playerResults: [String: Int] = [:]
        
        let transactions = self.transactionController.transactions
        transactions.forEach { (transaction) in
            if transaction.type == .buyin {
                playerResults[transaction.name] = (playerResults[transaction.name] ?? 0) - transaction.total
                totalBuyins += transaction.total
            } else if transaction.type == .cashout {
                playerResults[transaction.name] = (playerResults[transaction.name] ?? 0) + transaction.total
                totalCashouts += transaction.total
            }
        }
        
        var message = ""
        message += "Total buyins: $\(totalBuyins)\n"
        message += "Total cashouts: $\(totalCashouts)\n"
        message += "Money on table: $\(totalBuyins - totalCashouts)\n"
        playerResults.keys.sorted().forEach { (name) in
            message += "\n"
            message += "\(name): \(playerResults[name]! < 0 ? "-" : "+")$\(abs(playerResults[name]!))"
        }
        
        let alertController = UIAlertController(title: "Player Statistics", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - AddViewControllerDelegate
    
    func addViewControllerDidAddTransaction(transaction: Transaction) {
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [IndexPath(row: self.transactionController.transactions.count, section: 0)], with: .automatic)
        self.transactionController.addTransaction(transaction)
        self.tableView.endUpdates()
        
        self.transactionController.persistTransactionsToUserDefaults(key: TransactionsViewController.transactionsUserDefaultsKey)
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactionController.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let transaction = self.transactionController.transactions[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionTableViewCell
        cell.nameLabel.text = transaction.name
        
        TransactionsViewController.dateFormatter.dateFormat = "h:mm a"
        cell.dateLabel.text = TransactionsViewController.dateFormatter.string(from: transaction.date)
        
        let prefix = transaction.type == .buyin ? "-" : "+"
        cell.totalLabel.text = "\(prefix)$\(transaction.total)"
        cell.totalLabel.textColor = transaction.type == .buyin ? UIColor.red : UIColor.green
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.transactionController.deleteTransaction(index: indexPath.row)
            tableView.endUpdates()
            
            self.transactionController.persistTransactionsToUserDefaults(key: TransactionsViewController.transactionsUserDefaultsKey)
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

