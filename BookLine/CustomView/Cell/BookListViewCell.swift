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
        view.font = .systemFont(ofSize: 15, weight: .bold)
        return view
    }()
    
    let bookAuthor: UILabelFontAttribute = {
       let view = UILabelFontAttribute()
        view.font = .systemFont(ofSize: 13)
        return view
    }()
    
    let bookReview: UILabelFontAttribute = {
       let view = UILabelFontAttribute()
        view.font = .systemFont(ofSize: 14)
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 3
        return view
    }()
    
    let star1 : StarImageAttribute = {
        let view = StarImageAttribute(frame: .zero)
        view.tag = 1
        return view
    }()
    
    let star2 : StarImageAttribute = {
        let view = StarImageAttribute(frame: .zero)
        view.tag = 2
        return view
    }()
    
    let star3 : StarImageAttribute = {
        let view = StarImageAttribute(frame: .zero)
        view.tag = 3
        return view
    }()
    
    let star4 : StarImageAttribute = {
        let view = StarImageAttribute(frame: .zero)
        view.tag = 4
        return view
    }()
    
    let star5 : StarImageAttribute = {
        let view = StarImageAttribute(frame: .zero)
        view.tag = 5
        return view
    }()
    
    let bookRating: UILabelFontAttribute = {
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
        [bookImage, bookName, bookAuthor, star1, star2, star3, star4, star5, bookReview].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        bookImage.snp.makeConstraints { make in
            make.topMargin.equalTo(0)
            make.height.equalTo(self).multipliedBy(0.8)
            make.leadingMargin.equalTo(10)
            make.width.equalTo(self).multipliedBy(0.18)
        }
        
        bookName.snp.makeConstraints { make in
            make.topMargin.equalTo(5)
            make.height.equalTo(self).multipliedBy(0.15)
            make.leadingMargin.equalTo(bookImage.snp.trailing).offset(15)
            make.width.equalTo(self).multipliedBy(0.7)
        }
        
        bookAuthor.snp.makeConstraints { make in
            make.topMargin.equalTo(bookName.snp.bottom).offset(12)
            make.height.equalTo(self).multipliedBy(0.1)
            make.leadingMargin.equalTo(bookImage.snp.trailing).offset(15)
            make.trailingMargin.equalTo(10)
        }
        
        bookReview.snp.makeConstraints { make in
            make.topMargin.equalTo(bookAuthor.snp.bottom).offset(15)
            make.width.equalTo(self).multipliedBy(0.7)
            make.leadingMargin.equalTo(bookImage.snp.trailing).offset(15)
            make.bottomMargin.equalTo(-5)
        }
        
        star1.snp.makeConstraints { make in
            make.width.equalTo(15)
            make.height.equalTo(15)
            make.leadingMargin.equalTo(15)
            make.bottomMargin.equalTo(0)
        }
        
        star2.snp.makeConstraints { make in
            make.width.equalTo(15)
            make.height.equalTo(15)
            make.leadingMargin.equalTo(star1.snp.trailing).offset(5)
            make.bottomMargin.equalTo(0)
        }
        
        star3.snp.makeConstraints { make in
            make.width.equalTo(15)
            make.height.equalTo(15)
            make.leadingMargin.equalTo(star2.snp.trailing).offset(5)
            make.bottomMargin.equalTo(0)
        }
        
        star4.snp.makeConstraints { make in
            make.width.equalTo(15)
            make.height.equalTo(15)
            make.leadingMargin.equalTo(star3.snp.trailing).offset(5)
            make.bottomMargin.equalTo(0)
        }
        
        star5.snp.makeConstraints { make in
            make.width.equalTo(15)
            make.height.equalTo(15)
            make.leadingMargin.equalTo(star4.snp.trailing).offset(5)
            make.bottomMargin.equalTo(0)
        }
    }
}
