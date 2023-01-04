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

    let categoryLocalRealm = try! Realm() //Realm테이블에 데이터 CRUD할때 Realm테이블 경로에 접근할 수 있는 객체 생성
    var categoryList: Results<CategoryData>!
    
    let defaultCategoryTitle = ["모든 책"]
    
    override func loadView() {
        self.view = mainView
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(CategoryListViewCell.self, forCellReuseIdentifier: CategoryListViewCell.identifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        UserDefaults.standard.set(defaultCategoryTitle[0], forKey: "defaultCategoryTitle")
        noEditNavigationAttribute()
        categoryList = categoryLocalRealm.objects(CategoryData.self).sorted(byKeyPath: "categorySortCode", ascending: true)
        print("Realm Succeed. categoryLocalRealm is located at: ", self.categoryLocalRealm.configuration.fileURL!)
    }
    
    func noEditNavigationAttribute() {
        self.navigationItem.title = "카테고리"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        let editButton = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(editButtonClicked))
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonClicked))
        self.navigationItem.rightBarButtonItems = [addButton, editButton]
    }
    
    func editNavigationAttribute() {
        self.navigationItem.title = "카테고리"
        let completionButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(editButtonClicked))
        let dummyButton = UIBarButtonItem()
        self.navigationItem.rightBarButtonItems = [dummyButton, completionButton]
    }
    
    @objc func editButtonClicked() {
        if mainView.tableView.isEditing == false {
            mainView.tableView.isEditing = true
            editNavigationAttribute()
        } else {
            mainView.tableView.isEditing = false
            noEditNavigationAttribute()
        }
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
                let record = CategoryData(regDate: Date(), category: "\(alert.textFields![0].text!)", savedBook: 1)
                try! self.categoryLocalRealm.write {
                    self.categoryLocalRealm.add(record)
                    print("Realm Succeed. categoryLocalRealm is located at: ", self.categoryLocalRealm.configuration.fileURL!)
                    self.mainView.tableView.reloadData()
                }
            } else {
                //글자수 0이하면 버튼비활성화 처리 예정(토스트 대신)
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return defaultCategoryTitle.count
        } else {
            return categoryList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryListViewCell.identifier, for: indexPath) as? CategoryListViewCell else { return UITableViewCell() }
        cell.backgroundColor = .clear
        
        //전체목록: 기본사진, 각 카테고리: 해당 카테고리 첫번째 레코드 이미지로 카테고리목록화면 표시예정
        if indexPath.section == 0 {
            cell.categoryName.text = "\(defaultCategoryTitle[indexPath.row])"
        } else {
            cell.categoryName.text = "\(categoryList[indexPath.row].category)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 0 {
            return nil
        } else {
            let deleteMemo = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
                try! self.categoryLocalRealm.write {
                    self.categoryLocalRealm.delete(self.categoryList[indexPath.row])
                    self.mainView.tableView.reloadData() //note변수에 didSet있는데 왜 reloadData가 안될까?
                    print("Realm Deleted")
                }
            }
            deleteMemo.image = UIImage(systemName: "trash.fill")
            deleteMemo.backgroundColor = .red
            return UISwipeActionsConfiguration(actions: [deleteMemo])
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section != 0
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //첫행은 순서변경적용 안되도록 처리예정
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.section == 0 {
            return .none
        } else {
            return .delete
        }
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categorySortCode = categoryList[indexPath.row].categorySortCode
        if indexPath.section == 0 {
            let vc = EntireBookListViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = EachBookListViewController()
            vc.categorySortCode = "\(categorySortCode)"
            vc.navigationTitle = categoryList[indexPath.row].category
            print(categorySortCode)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

//extension CategoryListViewController: CellDelegate {
//
//    var value: Date {
//        Date()
//    }
//}
