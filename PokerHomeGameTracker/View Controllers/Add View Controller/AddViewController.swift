//
//  AddViewController.swift
//  PokerHomeGameTracker
//
//  Created by Aaron Wojnowski on 2019-11-30.
//  Copyright © 2019 Aaron Wojnowski. All rights reserved.
//

import UIKit

protocol AddViewControllerDelegate: class {
    func addViewControllerDidAddTransaction(transaction: Transaction)
}

class AddViewController: UIViewController, AddTableViewDataSourceDelegate {
    
    public var delegate: AddViewControllerDelegate?
    
    private lazy var dataSource: AddTableViewDataSource = {
        let dataSource = AddTableViewDataSource(delegate: self)
        return dataSource
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self.dataSource
        tableView.delegate = self.dataSource
        AddTableViewDataSource.initializeTableView(tableView)
        return tableView
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.title = "Add Transaction"
        
        let addButton = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addButtonTapped))
        self.navigationItem.rightBarButtonItem = addButton
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup the view hierarchy
        
        self.view.addSubview(self.tableView)
        
        // all done!
        
        self.dataSource.focusInitialField()
        self.refreshAddBarButtonItem()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tableView.frame = self.view.bounds
    }

    // MARK: - Actions
    
    @objc private func addButtonTapped(sender: AnyObject) {
        let dataSource = self.dataSource
        guard let name = dataSource.name else {
            return
        }
        let total = dataSource.total
        let type = dataSource.type
        
        let transaction = Transaction(name: name, date: Date(), total: total, type: type)
        self.delegate?.addViewControllerDidAddTransaction(transaction: transaction)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func cancelButtonTapped(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Bar Button Items
    
    func refreshAddBarButtonItem() {
        let dataSource = self.dataSource
        self.navigationItem.rightBarButtonItem?.isEnabled = dataSource.name != nil && dataSource.total > 0
    }

    // MARK: - AddTableViewDataSourceDelegate
    
    func addTableViewDataSourceDidChangeData() {
        self.refreshAddBarButtonItem()
    }
    
}
