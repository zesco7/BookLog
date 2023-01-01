//
//  BookSearchViewCell.swift
//  BookLine
//
//  Created by Mac Pro 15 on 2023/01/01.
//

import UIKit

class BookSearchViewCell: BaseTableViewCell {
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [bookImage, bookName, bookAuthor].forEach {
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
            make.centerY.equalTo(self).offset(-30)
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
    }
}
