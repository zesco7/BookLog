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
        self.addSubview(tableView)
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.topMargin.equalTo(safeAreaLayoutGuide.snp.top)
            make.bottomMargin.equalTo(safeAreaLayoutGuide.snp.bottom)
            make.leadingMargin.equalTo(safeAreaLayoutGuide.snp.leading)
            make.trailingMargin.equalTo(safeAreaLayoutGuide.snp.trailing)
        }
    }
}

