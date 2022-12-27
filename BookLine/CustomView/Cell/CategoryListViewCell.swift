//
//  CategoryListViewCell.swift
//  BookLine
//
//  Created by Mac Pro 15 on 2022/12/27.
//

import UIKit
import SnapKit

class CategoryListViewCell: UITableViewCell {
    let categoryThumbnail: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "star.fill")
        return view
    }()
    
    let categoryName: UILabel = {
        let view = UILabel()
        view.text = "내가 읽은 책"
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        [categoryThumbnail, categoryName].forEach {
            self.addSubview($0)
        }
    }
    
    func setConstraints() {
        categoryThumbnail.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.topMargin.equalTo(10)
            make.bottomMargin.equalTo(10)
            make.leadingMargin.equalTo(10)
            make.width.equalTo(self).multipliedBy(0.2)
        }
        
        categoryName.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.topMargin.equalTo(10)
            make.bottomMargin.equalTo(10)
            make.leadingMargin.equalTo(categoryThumbnail.snp.trailing).offset(30)
            make.width.equalTo(self).multipliedBy(7)
        }
    }
}
