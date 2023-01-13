//
//  UITableViewAttribute.swift
//  BookLine
//
//  Created by Mac Pro 15 on 2023/01/13.
//

import UIKit

class UITableViewAttribute: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func attribute() {
        self.backgroundColor = .backgroundColorBeige
    }
}
