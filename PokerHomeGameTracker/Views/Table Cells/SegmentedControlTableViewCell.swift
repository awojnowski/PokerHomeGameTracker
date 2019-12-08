//
//  SegmentedControlTableViewCell.swift
//  PokerHomeGameTracker
//
//  Created by Aaron Wojnowski on 2019-11-30.
//  Copyright © 2019 Aaron Wojnowski. All rights reserved.
//

import UIKit

class SegmentedControlTableViewCell: UITableViewCell {
    
    lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(frame: .zero)
        return segmentedControl
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        // setup the view hierarchy
        
        self.contentView.addSubview(self.segmentedControl)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.segmentedControl.frame = .zero
        self.segmentedControl.sizeToFit()
        self.segmentedControl.frame = CGRect(x: self.layoutMargins.left, y: (self.contentView.bounds.height - self.segmentedControl.bounds.height) / 2.0, width: self.contentView.bounds.width - self.layoutMargins.left - self.layoutMargins.right, height: self.segmentedControl.bounds.height)
    }

}
