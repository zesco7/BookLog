//
//  BaseView.swift
//  BookLine
//
//  Created by Mac Pro 15 on 2022/12/27.
//

import UIKit

class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        setConstraints()
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func attribute() {
        self.backgroundColor = .clear
    }
    
    func configureUI() { }
    func setConstraints() { }
}
