//
//  CategoryListViewController.swift
//  BookLine
//
//  Created by Mac Pro 15 on 2022/12/27.
//

import UIKit
import RealmSwift
import Toast

class CategoryListViewController: BaseViewController {
    var mainView = CategoryListView()
    var mainViewCell = CategoryListViewCell()
    
    let localRealm = try! Realm() //Realm테이블에 데이터 CRUD할때 Realm테이블 경로에 접근할 수 있는 객체 생성
    let categoryLocalRealm = try! Realm()
    
    //var categoryList: Results<BookData>!
    var categoryList: Results<CategoryData>!
    
    override func loadView() {
        self.view = mainView
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(CategoryListViewCell.self, forCellReuseIdentifier: "CategoryListViewCell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        navigationAttribute()
        
        //categoryList = localRealm.objects(BookData.self).sorted(byKeyPath: "pubdate", ascending: true)
        categoryList = categoryLocalRealm.objects(CategoryData.self).sorted(byKeyPath: "categorySortCode", ascending: true)
        //Realm데이터 정렬하여 tasks객체에 담기
        
    }
    
    func navigationAttribute() {
        self.navigationItem.title = "카테고리"
        let editButton = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(editButtonClicked))
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonClicked))
        self.navigationItem.rightBarButtonItems = [addButton, editButton]
    }
    
    @objc func editButtonClicked() {
        let task = BookData(categorySortCode: 1, ISBN: "1", rating: 1.1, review: "1", memo: "1", title: "1", author: "1", publisher: "1", pubdate: Date(), linkURL: "1", imageURL: "1") //Realm 레코드 생성
        
        try! localRealm.write {
            localRealm.add(task) //경로에 레코드 추가
            print("Realm Succeed. localRealm is located at: ", localRealm.configuration.fileURL!)
        }
        mainView.tableView.reloadData()
    }
    
    @objc func addButtonClicked() {
        alertForAddCategory()
    }
    
    func alertForAddCategory() {
        let alert = UIAlertController(title: "카테고리를 추가해주세요", message: nil, preferredStyle: .alert)
        alert.addTextField()
        //확인버튼 누르면 카테고리목록테이블에 값추가
        let ok = UIAlertAction(title: "확인", style: .destructive) { (ok) in
            if alert.textFields![0].text!.count > 0 {
                let record = CategoryData(order: 1, category: "\(alert.textFields![0].text!)", savedBook: 1)
                try! self.categoryLocalRealm.write {
                    self.categoryLocalRealm.add(record)
                    print("Realm Succeed. categoryLocalRealm is located at: ", self.categoryLocalRealm.configuration.fileURL!)
                    self.mainView.tableView.reloadData()
                }
            } else {
                self.view.makeToast("카테고리 이름을 정해주세요", duration: 0.5, position: .center)
            }
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
        
        cell.categoryName.text = "\(categoryList[indexPath.row].category)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = EachBookListViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
