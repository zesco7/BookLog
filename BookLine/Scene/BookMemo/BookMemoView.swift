//
//  BookMemoView.swift
//  BookLine
//
//  Created by Mac Pro 15 on 2022/12/30.
//

import UIKit
import SnapKit

class BookMemoView: BaseView {
    let lastUpdateDateLabel : UILabelFontAttribute = {
        let view = UILabelFontAttribute()
        view.text = "최종 수정일"
        return view
    }()
    
    let lastUpdateDate : UILabelFontAttribute = {
        let view = UILabelFontAttribute()
        view.text = "\(Date())"
        return view
    }()
    
    let bookNameLabel : UILabelFontAttribute = {
        let view = UILabelFontAttribute()
        view.text = "제목"
        return view
    }()

    var bookName : UILabelFontAttribute = {
        let view = UILabelFontAttribute()
        return view
    }()
    
    let bookAuthorLabel : UILabelFontAttribute = {
        let view = UILabelFontAttribute()
        view.text = "저자"
        return view
    }()

    var bookAuthor : UILabelFontAttribute = {
        let view = UILabelFontAttribute()
        return view
    }()

    let starRatingLabel : UILabelFontAttribute = {
        let view = UILabelFontAttribute()
        view.text = "별점"
        return view
    }()

    let starRatingSlider : UISlider = {
        let view = UISlider()
        view.minimumValue = 0
        view.maximumValue = 5
        view.minimumTrackTintColor = .clear
        view.maximumTrackTintColor = .clear
        view.thumbTintColor = .clear
        
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
    
    lazy var starStackView : UIStackView = {
        let view = UIStackView(arrangedSubviews: [star1, star2, star3, star4, star5])
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .fill
        return view
    }()

    let commentLabel : UILabelFontAttribute = {
        let view = UILabelFontAttribute()
        view.text = "한줄평"
        return view
    }()

    let commentTextView : UITextView = {
        let view = UITextView()
        view.font = .systemFont(ofSize: 15)
        return view
    }()
    
    let divisionLine : UIView = {
       let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    let memoTextView: UITextView = {
        let view = UITextView()
        view.font = .systemFont(ofSize: 15)
        return view
    }()
    
    override func configureUI() {
        [lastUpdateDateLabel, lastUpdateDate, bookNameLabel, bookName, bookAuthorLabel, bookAuthor, starRatingLabel, starRatingSlider, commentLabel, commentTextView, divisionLine, memoTextView, star1, star2, star3, star4, star5].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        lastUpdateDateLabel.snp.makeConstraints { make in
            make.topMargin.equalTo(10)
            make.width.equalTo(self).multipliedBy(0.3)
            make.leadingMargin.equalTo(10)
            make.height.equalTo(20)
        }
        
        lastUpdateDate.snp.makeConstraints { make in
            make.topMargin.equalTo(10)
            make.leadingMargin.equalTo(lastUpdateDateLabel.snp.trailing).offset(10)
            make.trailingMargin.equalTo(self).offset(-10)
            make.height.equalTo(20)
        }
        
        bookNameLabel.snp.makeConstraints { make in
            make.topMargin.equalTo(lastUpdateDateLabel).offset(30)
            make.width.equalTo(self).multipliedBy(0.3)
            make.leadingMargin.equalTo(10)
            make.height.equalTo(20)
        }
        
        bookName.snp.makeConstraints { make in
            make.topMargin.equalTo(lastUpdateDateLabel).offset(30)
            make.leadingMargin.equalTo(bookNameLabel.snp.trailing).offset(10)
            make.trailingMargin.equalTo(self).offset(-10)
            make.height.equalTo(20)
        }

        bookAuthorLabel.snp.makeConstraints { make in
            make.topMargin.equalTo(bookNameLabel).offset(30)
            make.width.equalTo(self).multipliedBy(0.3)
            make.leadingMargin.equalTo(10)
            make.height.equalTo(20)
        }

        bookAuthor.snp.makeConstraints { make in
            make.topMargin.equalTo(bookNameLabel).offset(30)
            make.leadingMargin.equalTo(bookAuthorLabel.snp.trailing).offset(10)
            make.trailingMargin.equalTo(self).offset(-10)
            make.height.equalTo(20)
        }

        starRatingLabel.snp.makeConstraints { make in
            make.topMargin.equalTo(bookAuthorLabel).offset(30)
            make.width.equalTo(self).multipliedBy(0.3)
            make.leadingMargin.equalTo(10)
            make.height.equalTo(20)
        }

        starRatingSlider.snp.makeConstraints { make in
            make.topMargin.equalTo(bookAuthorLabel).offset(35)
            make.leadingMargin.equalTo(starRatingLabel.snp.trailing).offset(10)
            make.trailingMargin.equalTo(star5.snp.trailing).offset(0)
            make.height.equalTo(20)
        }
        
        star1.snp.makeConstraints { make in
            make.topMargin.equalTo(starRatingSlider.snp.top).offset(0)
            make.leadingMargin.equalTo(starRatingLabel.snp.trailing).offset(10)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        star2.snp.makeConstraints { make in
            make.topMargin.equalTo(starRatingSlider.snp.top).offset(0)
            make.leadingMargin.equalTo(star1.snp.trailing).offset(0)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        star3.snp.makeConstraints { make in
            make.topMargin.equalTo(starRatingSlider.snp.top).offset(0)
            make.leadingMargin.equalTo(star2.snp.trailing).offset(0)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        star4.snp.makeConstraints { make in
            make.topMargin.equalTo(starRatingSlider.snp.top).offset(0)
            make.leadingMargin.equalTo(star3.snp.trailing).offset(0)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        star5.snp.makeConstraints { make in
            make.topMargin.equalTo(starRatingSlider.snp.top).offset(0)
            make.leadingMargin.equalTo(star4.snp.trailing).offset(0)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
    
        commentLabel.snp.makeConstraints { make in
            make.topMargin.equalTo(starRatingLabel).offset(30)
            make.width.equalTo(self).multipliedBy(0.3)
            make.leadingMargin.equalTo(10)
            make.height.equalTo(20)
        }

        commentTextView.snp.makeConstraints { make in
            make.topMargin.equalTo(commentLabel).offset(30)
            make.leadingMargin.equalTo(self).offset(10)
            make.trailingMargin.equalTo(self).offset(-10)
            make.height.equalTo(80)
        }
        
        divisionLine.snp.makeConstraints { make in
            make.topMargin.equalTo(commentTextView.snp.bottom).offset(30)
            make.leadingMargin.equalTo(self).offset(10)
            make.trailingMargin.equalTo(self).offset(-10)
            make.height.equalTo(1)
        }
        
        memoTextView.snp.makeConstraints { make in
            make.topMargin.equalTo(divisionLine).offset(30)
            make.leadingMargin.equalTo(self).offset(10)
            make.trailingMargin.equalTo(self).offset(-10)
            make.height.equalTo(self)
        }
    }
}
