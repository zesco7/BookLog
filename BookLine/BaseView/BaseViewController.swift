//
//  BaseViewController.swift
//  BookLine
//
//  Created by Mac Pro 15 on 2022/12/27.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attribute()
        hideKeyboard()
    }
    
    func attribute() {
        view.backgroundColor = .backgroundColorBeige
    }
    
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
