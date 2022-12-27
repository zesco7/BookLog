//
//  CategoryListViewController.swift
//  BookLine
//
//  Created by Mac Pro 15 on 2022/12/27.
//

import UIKit

class CategoryListViewController: BaseViewController {
    var mainView = CategoryListView()
    var mainViewCell = CategoryListViewCell()
    
    var categoryList = ["모든 책"]
    
    override func loadView() {
        self.view = mainView
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(CategoryListViewCell.self, forCellReuseIdentifier: "CategoryListViewCell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationAttribute()
    }
    
    func navigationAttribute() {
        self.navigationItem.title = "카테고리"
        let editButton = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(editButtonClicked))
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonClicked))
        self.navigationItem.rightBarButtonItems = [addButton, editButton]
    }
    
    @objc func editButtonClicked() {
        
    }
    
    @objc func addButtonClicked() {
        alertForAddCategory()
    }
    
    func alertForAddCategory() {
        let alert = UIAlertController(title: "카테고리를 추가해주세요", message: nil, preferredStyle: .alert)
        alert.addTextField()
        let ok = UIAlertAction(title: "확인", style: .destructive) { (ok) in
            self.categoryList.append(alert.textFields![0].text!) //확인버튼 누르면 카테고리목록배열에 값추가
            print(self.mainViewCell.categoryName.text!)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}

extension CategoryListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryListViewCell", for: indexPath) as? CategoryListViewCell else { return UITableViewCell() }
        
        mainViewCell.categoryName.text = categoryList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
