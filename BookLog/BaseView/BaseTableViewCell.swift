//
//  BaseTableViewCell.swift
//  BookLine
//
//  Created by Mac Pro 15 on 2022/12/28.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var identifier: String {
        String(describing: self)
    }
    
    func configureUI() { }
    
    func setConstraints() { }
}
