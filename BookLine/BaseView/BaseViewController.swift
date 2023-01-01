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
//        hideKeyboard()
    }
    
    func attribute() {
        view.backgroundColor = .backgroundColorBeige
    }

    //self는 BaseViewController에만 적용되고 서브클래스에는 적용안됨
    //스토리보드에서 버튼하나에 액션두개넣으면 앱죽는 것처럼 이중셀렉터 발생할수도 있어서 적용안됨
    //네비게이션 없는 BaseViewController가 맨처음 적용되기 때문에 uiresponderchain 꼬여서 화면전환이 안되는 것임
//    func hideKeyboard() {
//        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        view.addGestureRecognizer(tap)
//    }
//
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//    }
}
