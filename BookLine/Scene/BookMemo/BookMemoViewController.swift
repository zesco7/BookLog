//
//  BookMemoViewController.swift
//  BookLine
//
//  Created by Mac Pro 15 on 2022/12/30.
//

import UIKit

class BookMemoViewController: BaseViewController {
    var mainView = BookMemoView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension BookMemoViewController: UIToolbarDelegate {
    
}
