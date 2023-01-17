//
//  CategoryListViewCell.swift
//  BookLine
//
//  Created by Mac Pro 15 on 2022/12/27.
//

import UIKit
import SnapKit

//protocol CellDelegate: NSObject {
//
//    var value: Date { get }
//}

class CategoryListViewCell: BaseTableViewCell {
    let categoryThumbnail: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    let categoryName: UILabelFontAttribute = {
        let view = UILabelFontAttribute()
        view.font = .systemFont(ofSize: 17, weight: .bold)
        return view
    }()
    
    let bookCount: UILabelFontAttribute = {
        let view = UILabelFontAttribute()
        return view
    }()
    
//    weak var cellDelegate: CellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [categoryThumbnail, categoryName, bookCount].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        categoryThumbnail.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.height.equalTo(self).multipliedBy(0.6)
            make.leadingMargin.equalTo(20)
            make.width.equalTo(self).multipliedBy(0.1)
        }
        
        categoryName.snp.makeConstraints { make in
            make.centerY.equalTo(self).multipliedBy(0.65)
            make.height.equalTo(self).multipliedBy(0.2)
            make.leadingMargin.equalTo(categoryThumbnail.snp.trailing).offset(30)
            make.width.equalTo(self).multipliedBy(0.7)
        }
        
        bookCount.snp.makeConstraints { make in
            make.topMargin.equalTo(categoryName.snp.bottom).offset(20)
            make.height.equalTo(self).multipliedBy(0.2)
            make.leadingMargin.equalTo(categoryThumbnail.snp.trailing).offset(30)
            make.width.equalTo(self).multipliedBy(0.7)
        }
    }
    
//    public func configureCell(text: String) {
//        categoryName.text = text + (cellDelegate?.value.description ?? "")
//    }
}
