//
//  TransactionController.swift
//  PokerHomeGameTracker
//
//  Created by Aaron Wojnowski on 2019-11-30.
//  Copyright © 2019 Aaron Wojnowski. All rights reserved.
//

import UIKit

class TransactionController {
    // MARK: - Public Properties
    
    public var transactions: [Transaction] {
        get {
            return self.internalTransactions
        }
    }
    
    // MARK: - Private Properties
    
    private var internalTransactions: [Transaction] = []
    
    // MARK: - Transactions
    
    public func addTransaction(_ transaction: Transaction) {
        self.internalTransactions.append(transaction)
    }
    
    public func clearTransactions() {
        self.internalTransactions.removeAll()
    }
    
    public func deleteTransaction(index: Int) {
        if index < 0 || index >= self.internalTransactions.count {
            fatalError("Attempting to delete transaction out of bounds at index \(index)")
        }
        self.internalTransactions.remove(at: index)
    }
    
    // MARK: - Transaction Persistence
    
    public func loadPersistedTransactionsFromUserDefaults(key: String) {        
        let decoder = JSONDecoder()
        let encodedTransactions: [Data] = UserDefaults.standard.array(forKey: key) as? [Data] ?? []
        self.internalTransactions = encodedTransactions.map({ (data) -> Transaction in
            try! decoder.decode(Transaction.self, from: data)
        })
    }
    
    public func persistTransactionsToUserDefaults(key: String) {
        let encoder = JSONEncoder()
        let encodedTransactions = self.transactions.map({ (transaction) -> Data in
            try! encoder.encode(transaction)
        })
        UserDefaults.standard.set(encodedTransactions, forKey: key)
        UserDefaults.standard.synchronize()
    }
}
