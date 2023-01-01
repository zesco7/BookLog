//
//  EntireBookListViewCell.swift
//  BookLine
//
//  Created by Mac Pro 15 on 2022/12/28.
//

import UIKit
import SnapKit

class EntireBookListViewCell: BaseTableViewCell {
    let bookImage: UIImageView = {
       let view = UIImageView()
        view.image = UIImage(systemName: "star")
        return view
    }()
    
    let bookName: UILabelFontAttribute = {
       let view = UILabelFontAttribute()
        return view
    }()
    
    let bookAuthor: UILabelFontAttribute = {
       let view = UILabelFontAttribute()
        return view
    }()
    
    let bookRating: UILabelFontAttribute = {
       let view = UILabelFontAttribute()
        return view
    }()
    
    let bookReview: UILabelFontAttribute = {
       let view = UILabelFontAttribute()
        view.numberOfLines = 0
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
    
    override func configureUI() {
        [bookImage, bookName, bookAuthor, bookRating, bookReview].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        bookImage.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.height.equalTo(self)
            make.leadingMargin.equalTo(0)
            make.width.equalTo(self).multipliedBy(0.2)
        }
        
        bookName.snp.makeConstraints { make in
            make.topMargin.equalTo(10)
            make.height.equalTo(self).multipliedBy(0.15)
            make.leadingMargin.equalTo(bookImage.snp.trailing).offset(10)
            make.width.equalTo(self).multipliedBy(0.7)
        }
        
        bookAuthor.snp.makeConstraints { make in
            make.topMargin.equalTo(bookName.snp.bottom).offset(10)
            make.height.equalTo(self).multipliedBy(0.15)
            make.leadingMargin.equalTo(bookImage.snp.trailing).offset(10)
            make.width.equalTo(self).multipliedBy(0.7)
        }

        bookRating.snp.makeConstraints { make in
            make.topMargin.equalTo(bookAuthor.snp.bottom).offset(10)
            make.height.equalTo(self).multipliedBy(0.15)
            make.leadingMargin.equalTo(bookImage.snp.trailing).offset(10)
            make.width.equalTo(self).multipliedBy(0.7)
        }

        bookReview.snp.makeConstraints { make in
            make.topMargin.equalTo(bookRating.snp.bottom).offset(10)
            make.height.equalTo(self).multipliedBy(0.15)
            make.leadingMargin.equalTo(bookImage.snp.trailing).offset(10)
            make.width.equalTo(self).multipliedBy(0.7)
        }
    }
}
