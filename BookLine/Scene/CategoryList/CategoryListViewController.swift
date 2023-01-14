//
//  CategoryListViewController.swift
//  BookLine
//
//  Created by Mac Pro 15 on 2022/12/27.
//

import UIKit
import Kingfisher
import RealmSwift
import Toast

class CategoryListViewController: BaseViewController {
    var mainView = CategoryListView()
    var mainViewCell = CategoryListViewCell()
    
    let categoryLocalRealm = try! Realm()
    let bookLocalRealm = try! Realm()
    var categoryList: Results<CategoryData>!
    var bookList: Results<BookData>?
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
        bookList = bookLocalRealm.objects(BookData.self)
        print("categoryLocalRealm is located at: ", self.categoryLocalRealm.configuration.fileURL!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mainView.tableView.reloadData()
    }
    
    func noEditNavigationAttribute() {
        self.navigationItem.title = "카테고리"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationController!.navigationBar.tintColor = .navigationBar
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
        let alert = UIAlertController(title: "카테고리를 추가해주세요.", message: nil, preferredStyle: .alert)
        alert.addTextField()
        let ok = UIAlertAction(title: "확인", style: .default) { (ok) in
            guard let textFieldText = alert.textFields![0].text else { return }
            let categoryDuplicationCheck = self.categoryLocalRealm.objects(CategoryData.self).filter("category == '\(textFieldText)'").count
            if textFieldText.count == 0 {
                self.view.makeToast("카테고리 이름을 정해주세요.", duration: 0.5, position: .center)
            } else {
                if categoryDuplicationCheck > 0 || textFieldText == self.defaultCategoryTitle[0] {
                    self.view.makeToast("이미 추가한 카테고리입니다.", duration: 0.5, position: .center)
                } else {
                    let record = CategoryData(regDate: Date(), category: "\(alert.textFields![0].text!)")
                    try! self.categoryLocalRealm.write {
                        self.categoryLocalRealm.add(record)
                        self.mainView.tableView.reloadData()
                    }
                }
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
        cell.backgroundColor = .backgroundColorBeige
        if indexPath.section == 0 {
            cell.categoryThumbnail.image = UIImage(named: "bookshelf")
            cell.categoryName.text = "\(defaultCategoryTitle[indexPath.row])"
            cell.bookCount.text = "총 \(bookList?.count ?? 0) 권"
        } else {
            cell.categoryThumbnail.image = UIImage(named: "open-book")
            cell.categoryName.text = "\(categoryList[indexPath.row].category)"
            let categorizedBookList = bookList?.filter("categorySortCode == '\(categoryList![indexPath.row].categorySortCode)'")
            cell.bookCount.text = "총 \(categorizedBookList?.count ?? 0) 권"
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
                    self.mainView.tableView.reloadData()
                    print("Category Deleted")
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
        if indexPath.section == 0 {
            let vc = BookListViewController(categorySortType: .all(categoryCode: ""), navigationTitle: UserDefaults.standard.string(forKey: "defaultCategoryTitle"))
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = BookListViewController(categorySortType: .category(categoryCode: "\(categoryList[indexPath.row].categorySortCode)"), navigationTitle: "\(categoryList[indexPath.row].category)")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
