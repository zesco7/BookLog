//
//  EntireBookListView.swift
//  BookLine
//
//  Created by Mac Pro 15 on 2022/12/28.
//

import UIKit
import SnapKit

class BookListView: BaseView {
    let tableView: UITableViewAttribute = {
       let view = UITableViewAttribute()
        return view
    }()
    
    override func configureUI() {
        self.addSubview(tableView)
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
