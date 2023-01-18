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
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(CategoryListViewCell.self, forCellReuseIdentifier: CategoryListViewCell.identifier)
        UserDefaults.standard.set(defaultCategoryTitle[0], forKey: "defaultCategoryTitle")
        navigationAttribute()
        categoryList = categoryLocalRealm.objects(CategoryData.self).sorted(byKeyPath: "categorySortCode", ascending: true)
        bookList = bookLocalRealm.objects(BookData.self)
        print("categoryLocalRealm is located at: ", self.categoryLocalRealm.configuration.fileURL!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mainView.tableView.reloadData()
    }
    
    func navigationAttribute() {
        self.navigationItem.title = "카테고리"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationController!.navigationBar.tintColor = .navigationBar
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonClicked))
        let sortButton = UIBarButtonItem(title: "정렬", style: .plain, target: self, action: #selector(sortCategoryClicked))
        self.navigationItem.rightBarButtonItems = [addButton, sortButton]
    }
    
    @objc func addButtonClicked() {
        alertForAddCategory()
    }
        
    @objc func sortCategoryClicked() {
        sortCategoryList()
    }

    func sortCategoryList() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let sortByTitleAscending = UIAlertAction(title: "가나다순", style: .default) { _ in
            self.categoryList = self.categoryLocalRealm.objects(CategoryData.self).sorted(byKeyPath: "category", ascending: true)
            self.mainView.tableView.reloadData()
        }
        let sortByTitleDescending = UIAlertAction(title: "가나다역순", style: .default) { _ in
            self.categoryList = self.categoryLocalRealm.objects(CategoryData.self).sorted(byKeyPath: "category", ascending: false)
            self.mainView.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        actionSheet.addAction(sortByTitleAscending)
        actionSheet.addAction(sortByTitleDescending)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true)
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
        cell.backgroundColor = .tableViewCellColor
        if indexPath.section == 0 {
            cell.categoryThumbnail.image = UIImage(named: "bookshelf")
            cell.categoryName.text = "\(defaultCategoryTitle[indexPath.row])"
            cell.bookCount.text = "총 \(bookList?.count ?? 0) 권"
        } else {
            cell.categoryThumbnail.image = UIImage(named: "open-book")
            cell.categoryName.text = "\(categoryList[indexPath.row].category)"
            let categorizedBookList = bookList?.filter("categorySortCode == '\(categoryList[indexPath.row].categorySortCode)'")
            cell.bookCount.text = "총 \(categorizedBookList?.count ?? 0) 권"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 0 {
            return nil
        } else {
            let deleteMemo = UIContextualAction(style: .destructive, title: nil) { action, view, completionHandler in
                let alert = UIAlertController(title: "삭제하시겠습니까?", message: nil, preferredStyle: .alert)
                let ok = UIAlertAction(title: "삭제", style: .destructive) { _ in
                    try! self.categoryLocalRealm.write {
                        self.categoryLocalRealm.delete(self.categoryList[indexPath.row])
                        self.mainView.tableView.reloadData()
                        print("Category Deleted")
                    }
                }
                let cancel = UIAlertAction(title: "취소", style: .cancel)
                alert.addAction(ok)
                alert.addAction(cancel)
                self.present(alert, animated: true)
            }
            deleteMemo.image = UIImage(systemName: "trash.fill")
            deleteMemo.backgroundColor = .red
            let config = UISwipeActionsConfiguration(actions: [deleteMemo])
            config.performsFirstActionWithFullSwipe = false
            return config
        }
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let vc = BookListViewController(categorySortType: .all, navigationTitle: UserDefaults.standard.string(forKey: "defaultCategoryTitle"))
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
