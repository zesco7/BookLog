//
//  CategoryListViewCell.swift
//  BookLine
//
//  Created by Mac Pro 15 on 2022/12/27.
//

import UIKit
import SnapKit

protocol CellDelegate: NSObject {
    
    var value: Date { get }
}

class CategoryListViewCell: BaseTableViewCell {
    
    let categoryThumbnail: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "star.fill")
        return view
    }()
    
    let categoryName: UILabel = {
        let view = UILabel()
        return view
    }()
    
    weak var cellDelegate: CellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [categoryThumbnail, categoryName].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
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
            make.width.equalTo(self).multipliedBy(0.7)
        }
    }
    
    public func configureCell(text: String) {
        categoryName.text = text + (cellDelegate?.value.description ?? "")
    }
}
