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
    
    var userGuide: UILabelFontAttribute = {
       let view = UILabelFontAttribute()
        return view
    }()
    
    override func configureUI() {
        [tableView, userGuide].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.topMargin.equalTo(self.safeAreaLayoutGuide)
            make.bottomMargin.equalTo(self.safeAreaLayoutGuide)
            make.leadingMargin.equalTo(self.safeAreaLayoutGuide)
            make.trailingMargin.equalTo(self.safeAreaLayoutGuide)
        }
        
        //centerX constraints적용 안되는 이유?
        userGuide.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.9)
            make.centerY.equalTo(self)
            make.height.equalTo(44)
        }
    }
}
