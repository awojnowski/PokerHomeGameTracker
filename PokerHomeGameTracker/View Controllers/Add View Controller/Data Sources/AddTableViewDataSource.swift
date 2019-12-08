//
//  AddTableViewDataSource.swift
//  PokerHomeGameTracker
//
//  Created by Aaron Wojnowski on 2019-11-30.
//  Copyright © 2019 Aaron Wojnowski. All rights reserved.
//

import UIKit

protocol AddTableViewDataSourceDelegate: class {
    func addTableViewDataSourceDidChangeData()
}

class AddTableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    // MARK: - Public Properties
    
    public let delegate: AddTableViewDataSourceDelegate
    
    public var name: String? {
        get {
            guard let text = self.nameCell.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                return nil
            }
            if text.count == 0 {
                return nil
            }
            return text
        }
    }
    
    public var total: Int {
        get {
            return Int(self.totalString) ?? 0
        }
    }
    
    public var type: TransactionType {
        get {
            let index = self.typeCell.segmentedControl.selectedSegmentIndex
            if index == 0 {
                return .buyin
            } else if index == 1 {
                return .cashout
            } else {
                fatalError("AddTableViewDataSource segmented index \(index) is not a valid transaction type")
            }
        }
    }
    
    // MARK: - Private Properties
    
    private var totalString: String = ""
    
    private lazy var nameCell: TextFieldTableViewCell = {
        let cell = TextFieldTableViewCell(style: .default, reuseIdentifier: nil)
        cell.textField.autocapitalizationType = .words
        cell.textField.autocorrectionType = .no
        cell.textField.delegate = self
        cell.textField.placeholder = "John Doe"
        cell.textField.returnKeyType = .next
        cell.textLabel?.text = "Name"
        return cell
    }()
    
    private lazy var totalCell: TextFieldTableViewCell = {
        let cell = TextFieldTableViewCell(style: .default, reuseIdentifier: nil)
        cell.textField.delegate = self
        cell.textField.placeholder = "$1000"
        cell.textField.keyboardType = .numberPad
        cell.textLabel?.text = "Total"
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 44.0))
        toolbar.items = [
            UIBarButtonItem(title: "+1000", style: .plain, target: self, action: #selector(addTotal)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "+500", style: .plain, target: self, action: #selector(addTotal)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "+100", style: .plain, target: self, action: #selector(addTotal)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "+25", style: .plain, target: self, action: #selector(addTotal)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "+5", style: .plain, target: self, action: #selector(addTotal)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "+1", style: .plain, target: self, action: #selector(addTotal))
        ]
        cell.textField.inputAccessoryView = toolbar
        
        return cell
    }()
    
    private lazy var typeCell: SegmentedControlTableViewCell = {
        let cell = SegmentedControlTableViewCell(style: .default, reuseIdentifier: nil)
        cell.segmentedControl.removeAllSegments()
        cell.segmentedControl.insertSegment(withTitle: "Buy In", at: 0, animated: false)
        cell.segmentedControl.insertSegment(withTitle: "Cash Out", at: 1, animated: false)
        cell.segmentedControl.selectedSegmentIndex = 0
        return cell
    }()
    
    // MARK: - Initializers
    
    init(delegate: AddTableViewDataSourceDelegate) {
        self.delegate = delegate
        
        super.init()
    }
    
    // MARK: - Actions
    
    @objc private func addTotal(sender: UIBarButtonItem) {
        let addAmount = Int(String(sender.title!.dropFirst())) ?? 0
        let total = (Int(String(self.totalCell.textField.text?.dropFirst() ?? "0")) ?? 0) + addAmount
        self.totalString = String(total)
        self.totalCell.textField.text = "$\(total)"
        
        self.delegate.addTableViewDataSourceDidChangeData()
    }
    
    // MARK: - Class Methods
    
    public static func initializeTableView(_ tableView: UITableView) {
        tableView.register(TextFieldTableViewCell.self, forCellReuseIdentifier: "NameCell")
        tableView.register(TextFieldTableViewCell.self, forCellReuseIdentifier: "TotalCell")
        tableView.register(SegmentedControlTableViewCell.self, forCellReuseIdentifier: "TypeCell")
    }
    
    // MARK: - First Responder
    
    public func focusInitialField() {
        self.nameCell.textField.becomeFirstResponder()
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 2
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return self.nameCell
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                return self.totalCell
            } else if indexPath.row == 1 {
                return self.typeCell
            }
        }
        fatalError("AddTableViewDataSource cellForRowAtIndexPath fell through")
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.totalCell.textField {
            // check to make sure the range does not include the $
            
            var characterRange = range
            if self.totalString.count > 0 {
                if characterRange.location == 0 {
                    characterRange = NSMakeRange(characterRange.location, max(0, characterRange.length - 1))
                } else {
                    characterRange = NSMakeRange(characterRange.location - 1, characterRange.length)
                }
            }
            
            // compose the new string and check if it is a valid number
            
            func updateTotalString(_ string: String) {
                self.totalString = string
                textField.text = "$" + string
                self.delegate.addTableViewDataSourceDidChangeData()
            }
            
            let newString = String(self.totalString.prefix(characterRange.location)) + string + self.totalString.dropFirst(characterRange.location + characterRange.length)
            if newString.count == 0 {
                updateTotalString(newString)
            } else {
                if Int(newString) != nil {
                    updateTotalString(newString)
                }
            }
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.nameCell.textField {
            self.totalCell.textField.becomeFirstResponder()
        }
        return false
    }

}
