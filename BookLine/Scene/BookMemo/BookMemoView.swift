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
        view.text = "최종 수정"
        return view
    }()
    
    let lastUpdateDate : UILabelFontAttribute = {
        let view = UILabelFontAttribute()
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
    
    let bookInfoUrlButton : UIButton = {
        let view = UIButton()
        view.setTitle("책정보 보기", for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 11, weight: .bold)
        view.setTitleColor(.navigationBar, for: .normal)
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
        view.backgroundColor = .white
        view.layer.cornerRadius = 3
        view.clipsToBounds = true
        return view
    }()
    
    let divisionLine : UIView = {
       let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    let divisionLine2 : UIView = {
       let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    let memoLabel : UILabelFontAttribute = {
        let view = UILabelFontAttribute()
        view.text = "메모"
        return view
    }()
    
    let memoTextView: UITextView = {
        let view = UITextView()
        view.font = .systemFont(ofSize: 15)
        view.backgroundColor = .white
        view.layer.cornerRadius = 3
        view.clipsToBounds = true
        return view
    }()
    
    override func configureUI() {
        [lastUpdateDateLabel, lastUpdateDate, bookNameLabel, bookName, bookAuthorLabel, bookAuthor, bookInfoUrlButton, starRatingLabel, starRatingSlider, commentLabel, commentTextView, divisionLine, divisionLine2, memoLabel, memoTextView, star1, star2, star3, star4, star5].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        lastUpdateDateLabel.snp.makeConstraints { make in
            make.topMargin.equalTo(10)
            make.width.equalTo(self).multipliedBy(0.18)
            make.leadingMargin.equalTo(10)
            make.height.equalTo(20)
        }
        
        lastUpdateDate.snp.makeConstraints { make in
            make.centerY.equalTo(lastUpdateDateLabel.snp.centerY)
            make.leadingMargin.equalTo(lastUpdateDateLabel.snp.trailing).offset(10)
            make.trailingMargin.equalTo(self).offset(-10)
            make.height.equalTo(20)
        }
        
        bookNameLabel.snp.makeConstraints { make in
            make.topMargin.equalTo(lastUpdateDateLabel).offset(25)
            make.width.equalTo(self).multipliedBy(0.18)
            make.leadingMargin.equalTo(10)
            make.height.equalTo(20)
        }
        
        bookName.snp.makeConstraints { make in
            make.centerY.equalTo(bookNameLabel.snp.centerY)
            make.leadingMargin.equalTo(bookNameLabel.snp.trailing).offset(10)
            make.trailingMargin.equalTo(self).offset(-10)
            make.height.equalTo(20)
        }

        bookAuthorLabel.snp.makeConstraints { make in
            make.topMargin.equalTo(bookNameLabel).offset(25)
            make.width.equalTo(self).multipliedBy(0.18)
            make.leadingMargin.equalTo(10)
            make.height.equalTo(20)
        }

        bookAuthor.snp.makeConstraints { make in
            make.centerY.equalTo(bookAuthorLabel.snp.centerY)
            make.leadingMargin.equalTo(bookAuthorLabel.snp.trailing).offset(10)
            make.trailingMargin.equalTo(self).offset(-10)
            make.height.equalTo(20)
        }
        
        bookInfoUrlButton.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(20)
            make.trailingMargin.equalTo(self).offset(-10)
            make.bottomMargin.equalTo(divisionLine.snp.top).offset(-15)
        }
        
        divisionLine.snp.makeConstraints { make in
            make.topMargin.equalTo(bookAuthor.snp.bottom).offset(25)
            make.leadingMargin.equalTo(self).offset(10)
            make.trailingMargin.equalTo(self).offset(-10)
            make.height.equalTo(1)
        }

        starRatingLabel.snp.makeConstraints { make in
            make.topMargin.equalTo(divisionLine).offset(20)
            make.width.equalTo(self).multipliedBy(0.18)
            make.leadingMargin.equalTo(10)
            make.height.equalTo(15)
        }

        starRatingSlider.snp.makeConstraints { make in
            make.topMargin.equalTo(divisionLine).offset(20)
            make.leadingMargin.equalTo(starRatingLabel.snp.trailing).offset(10)
            make.trailingMargin.equalTo(star5.snp.trailing).offset(0)
            make.height.equalTo(20)
        }

        star1.snp.makeConstraints { make in
            make.topMargin.equalTo(starRatingSlider.snp.top).offset(0)
            make.leadingMargin.equalTo(starRatingLabel.snp.trailing).offset(10)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }

        star2.snp.makeConstraints { make in
            make.topMargin.equalTo(starRatingSlider.snp.top).offset(0)
            make.leadingMargin.equalTo(star1.snp.trailing).offset(4)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }

        star3.snp.makeConstraints { make in
            make.topMargin.equalTo(starRatingSlider.snp.top).offset(0)
            make.leadingMargin.equalTo(star2.snp.trailing).offset(4)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }

        star4.snp.makeConstraints { make in
            make.topMargin.equalTo(starRatingSlider.snp.top).offset(0)
            make.leadingMargin.equalTo(star3.snp.trailing).offset(4)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }

        star5.snp.makeConstraints { make in
            make.topMargin.equalTo(starRatingSlider.snp.top).offset(0)
            make.leadingMargin.equalTo(star4.snp.trailing).offset(4)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.topMargin.equalTo(starRatingLabel.snp.bottom).offset(25)
            make.width.equalTo(self).multipliedBy(0.18)
            make.leadingMargin.equalTo(10)
            make.height.equalTo(20)
        }
        
        commentTextView.snp.makeConstraints { make in
            make.topMargin.equalTo(starRatingLabel.snp.bottom).offset(25)
            make.width.equalTo(self).multipliedBy(0.71)
            make.trailingMargin.equalTo(self).offset(-10)
            make.height.equalTo(80)
        }
        
        divisionLine2.snp.makeConstraints { make in
            make.topMargin.equalTo(commentTextView.snp.bottom).offset(20)
            make.leadingMargin.equalTo(self).offset(10)
            make.trailingMargin.equalTo(self).offset(-10)
            make.height.equalTo(1)
        }
        memoLabel.snp.makeConstraints { make in
            make.topMargin.equalTo(divisionLine2.snp.bottom).offset(20)
            make.width.equalTo(self).multipliedBy(0.18)
            make.leadingMargin.equalTo(10)
            make.height.equalTo(20)
        }

        memoTextView.snp.makeConstraints { make in
            make.topMargin.equalTo(memoLabel.snp.bottom).offset(20)
            make.leadingMargin.equalTo(self).offset(10)
            make.trailingMargin.equalTo(self).offset(-10)
            make.height.equalTo(self)
        }
    }
}
