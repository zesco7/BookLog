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
        self.backgroundColor = .tableViewColor
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
