//
//  EntireBookListViewCell.swift
//  BookLine
//
//  Created by Mac Pro 15 on 2022/12/28.
//

import UIKit
import SnapKit

class BookListViewCell: BaseTableViewCell {
    let bookImage: UIImageView = {
       let view = UIImageView()
        view.image = UIImage(systemName: "star")
        return view
    }()
    
    let bookName: UILabelFontAttribute = {
       let view = UILabelFontAttribute()
        return view
    }()
    
    let divisionLine: UILabel = {
       let view = UILabel()
        view.text = "/"
        return view
    }()
    
    let bookAuthor: UILabelFontAttribute = {
       let view = UILabelFontAttribute()
        return view
    }()
    
    let star1 : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "star")
        view.tag = 1
        return view
    }()
    
    let star2 : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "star")
        view.tag = 2
        return view
    }()
    
    let star3 : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "star")
        view.tag = 3
        return view
    }()
    
    let star4 : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "star")
        view.tag = 4
        return view
    }()
    
    let star5 : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "star")
        view.tag = 5
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
        [bookImage, bookName, divisionLine, bookAuthor, star1, star2, star3, star4, star5, bookReview].forEach {
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
            make.width.lessThanOrEqualTo(self).multipliedBy(0.5)
        }
        
        divisionLine.snp.makeConstraints { make in
            make.topMargin.equalTo(10)
            make.height.equalTo(self).multipliedBy(0.15)
            make.leadingMargin.equalTo(bookName.snp.trailing).offset(10)
            make.width.equalTo(10)
        }
        
        bookAuthor.snp.makeConstraints { make in
            make.topMargin.equalTo(10)
            make.height.equalTo(self).multipliedBy(0.15)
            make.leadingMargin.equalTo(divisionLine.snp.trailing).offset(10)
            make.trailingMargin.equalTo(10)
        }

//        bookRating.snp.makeConstraints { make in
//            make.topMargin.equalTo(bookAuthor.snp.bottom).offset(10)
//            make.height.equalTo(self).multipliedBy(0.15)
//            make.leadingMargin.equalTo(bookImage.snp.trailing).offset(10)
//            make.width.equalTo(self).multipliedBy(0.7)
//        }
        
        star1.snp.makeConstraints { make in
            make.topMargin.equalTo(bookAuthor.snp.bottom).offset(20)
            make.leadingMargin.equalTo(bookImage.snp.trailing).offset(10)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        star2.snp.makeConstraints { make in
            make.topMargin.equalTo(bookAuthor.snp.bottom).offset(20)
            make.leadingMargin.equalTo(star1.snp.trailing).offset(0)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        star3.snp.makeConstraints { make in
            make.topMargin.equalTo(bookAuthor.snp.bottom).offset(20)
            make.leadingMargin.equalTo(star2.snp.trailing).offset(0)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        star4.snp.makeConstraints { make in
            make.topMargin.equalTo(bookAuthor.snp.bottom).offset(20)
            make.leadingMargin.equalTo(star3.snp.trailing).offset(0)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        star5.snp.makeConstraints { make in
            make.topMargin.equalTo(bookAuthor.snp.bottom).offset(20)
            make.leadingMargin.equalTo(star4.snp.trailing).offset(0)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }

        bookReview.snp.makeConstraints { make in
            make.topMargin.equalTo(star1.snp.bottom).offset(20)
            make.height.equalTo(self).multipliedBy(0.15)
            make.leadingMargin.equalTo(bookImage.snp.trailing).offset(10)
            make.width.equalTo(self).multipliedBy(0.7)
        }
    }
}
