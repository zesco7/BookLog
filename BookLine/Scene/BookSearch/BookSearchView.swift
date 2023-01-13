//
//  BookSearchView.swift
//  BookLine
//
//  Created by Mac Pro 15 on 2023/01/01.
//

import UIKit
import SnapKit

class BookSearchView: BaseView {
    let tableView: UITableViewAttribute = {
       let view = UITableViewAttribute()
        return view
    }()
    
    override func configureUI() {
        [tableView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.topMargin.equalTo(0)
            make.bottomMargin.equalTo(0)
            make.leadingMargin.equalTo(0)
            make.trailingMargin.equalTo(0)
        }
    }
}

