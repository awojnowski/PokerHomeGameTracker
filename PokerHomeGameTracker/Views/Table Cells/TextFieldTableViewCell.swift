//
//  TextFieldTableViewCell.swift
//  PokerHomeGameTracker
//
//  Created by Aaron Wojnowski on 2019-11-30.
//  Copyright © 2019 Aaron Wojnowski. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {
    
    lazy var textField: UITextField = {
        let textField = UITextField(frame: .zero)
        return textField
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        // setup the view hierarchy
        
        self.contentView.addSubview(self.textField)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.textLabel?.frame = .zero
        self.textLabel?.sizeToFit()
        self.textLabel?.frame = CGRect(x: self.layoutMargins.left, y: 0, width: self.textLabel?.frame.width ?? 0.0, height: self.contentView.bounds.height)
        
        let textFieldX = (self.textLabel?.frame.maxX ?? 0.0) + self.layoutMargins.left
        let textFieldWidth = self.contentView.bounds.width - self.layoutMargins.right - textFieldX
        self.textField.frame = .zero
        self.textField.sizeToFit()
        self.textField.frame = CGRect(x: textFieldX, y: (self.contentView.bounds.height - self.textField.bounds.height) / 2.0, width: textFieldWidth, height: self.textField.bounds.height)
    }

}
