//
//  CategoryListView.swift
//  BookLine
//
//  Created by Mac Pro 15 on 2022/12/27.
//

import UIKit
import SnapKit

class CategoryListView: BaseView {
    let tableView: UITableViewAttribute = {
       let view = UITableViewAttribute()
        return view
    }()
    
    override func configureUI() {
        self.addSubview(tableView)
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.topMargin.equalTo(self.safeAreaLayoutGuide)
            make.bottomMargin.equalTo(self.safeAreaLayoutGuide)
            make.leadingMargin.equalTo(self.safeAreaLayoutGuide)
            make.trailingMargin.equalTo(self.safeAreaLayoutGuide)
        }
    }
}