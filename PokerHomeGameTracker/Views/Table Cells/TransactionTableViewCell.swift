//
//  TransactionTableViewCell.swift
//  PokerHomeGameTracker
//
//  Created by Aaron Wojnowski on 2019-11-30.
//  Copyright © 2019 Aaron Wojnowski. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.alpha = 0.25
        return label
    }()
    
    lazy var totalLabel: UILabel = {
        let label = UILabel(frame: .zero)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        // setup the view hierarchy
        
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.dateLabel)
        self.contentView.addSubview(self.totalLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.nameLabel.frame = .zero
        self.nameLabel.sizeToFit()
        self.nameLabel.frame = CGRect(x: self.layoutMargins.left, y: 0.0, width: self.nameLabel.bounds.width, height: self.contentView.bounds.height)
        
        self.dateLabel.frame = .zero
        self.dateLabel.sizeToFit()
        self.dateLabel.frame = CGRect(x: self.nameLabel.frame.maxX + self.layoutMargins.left / 2.0, y: 0.0, width: self.dateLabel.bounds.width, height: self.contentView.bounds.height)
        
        self.totalLabel.frame = .zero
        self.totalLabel.sizeToFit()
        self.totalLabel.frame = CGRect(x: self.contentView.bounds.width - self.layoutMargins.right - self.totalLabel.bounds.width, y: 0.0, width: self.totalLabel.bounds.width, height: self.contentView.bounds.height)
    }

}
