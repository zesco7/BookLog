//
//  BookMemoView.swift
//  BookLine
//
//  Created by Mac Pro 15 on 2022/12/30.
//

import UIKit
import SnapKit

class BookMemoView: BaseView {
    let lastUpdateDateLabel : UILabel = {
        let view = UILabel()
        view.text = "최종 수정일"
        return view
    }()
    
    let lastUpdateDate : UILabel = {
        let view = UILabel()
        view.text = "\(Date())"
        return view
    }()
    
    let bookNameLabel : UILabel = {
        let view = UILabel()
        view.text = "제목"
        return view
    }()

    let bookName : UILabel = {
        let view = UILabel()
        view.text = "책이름~~~~~~~~~~~~~~~~~~~~~~~~~"
        return view
    }()
    
    let bookAuthorLabel : UILabel = {
        let view = UILabel()
        view.text = "저자"
        return view
    }()

    let bookAuthor : UILabel = {
        let view = UILabel()
        view.text = "저자이름~~~~~~~~~~~~~~~~~~~~~~~~~"
        return view
    }()

    let starRatingLabel : UILabel = {
        let view = UILabel()
        view.text = "별점"
        return view
    }()

    let starRatingSlider : UISlider = {
        let view = UISlider()
        return view
    }()

    let commentLabel : UILabel = {
        let view = UILabel()
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
        [lastUpdateDateLabel, lastUpdateDate, bookNameLabel, bookName, bookAuthorLabel, bookAuthor, starRatingLabel, starRatingSlider, commentLabel, commentTextView, divisionLine, memoTextView].forEach {
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
            make.topMargin.equalTo(bookAuthorLabel).offset(30)
            make.leadingMargin.equalTo(starRatingLabel.snp.trailing).offset(10)
            make.trailingMargin.equalTo(self).offset(-10)
            make.height.equalTo(20)
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
