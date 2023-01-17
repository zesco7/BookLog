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
    var categoryListArray: Array<CategoryData> = []
    
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
        categoryListArray = categoryList.map({ $0 })
    }
    
    func configureUI() {
        view.addSubview(mainView.tableView)
    }
    
    func setConstraints() {
        mainView.tableView.snp.makeConstraints { make in
            make.topMargin.equalTo(view.safeAreaLayoutGuide)
            make.bottomMargin.equalTo(view.safeAreaLayoutGuide)
            make.leadingMargin.equalTo(view.safeAreaLayoutGuide)
            make.trailingMargin.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mainView.tableView.reloadData()
    }
    
    func navigationAttribute() {
        self.navigationItem.title = "카테고리"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationController!.navigationBar.tintColor = .navigationBar
        let editButton = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(editButtonClicked))
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonClicked))
        self.navigationItem.rightBarButtonItems = [addButton, editButton]
    }
    
    @objc func editButtonClicked() {
        mainView.tableView.isEditing = true
        let completionButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completionButtonClicked))
        let dummyButton = UIBarButtonItem()
        self.navigationItem.rightBarButtonItems = [dummyButton, completionButton]
        print(categoryListArray)
    }
    
    @objc func completionButtonClicked() {
        mainView.tableView.isEditing = false
        navigationAttribute()
        print("완료", self.categoryListArray)
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
                        self.categoryListArray = self.categoryList.map({ $0 })
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
            return categoryListArray.count
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
            cell.categoryName.text = "\(categoryListArray[indexPath.row].category)"
            let categorizedBookList = bookList?.filter("categorySortCode == '\(categoryListArray[indexPath.row].categorySortCode)'")
            cell.bookCount.text = "총 \(categorizedBookList?.count ?? 0) 권"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 0 {
            return nil
        } else {
            let deleteMemo = UIContextualAction(style: .destructive, title: nil) { action, view, completionHandler in
                try! self.categoryLocalRealm.write {
                    self.categoryLocalRealm.delete(self.categoryList[indexPath.row])
                    self.mainView.tableView.reloadData()
                    print("Category Deleted")
                }
            }
            deleteMemo.image = UIImage(systemName: "trash.fill")
            deleteMemo.backgroundColor = .red
            let config = UISwipeActionsConfiguration(actions: [deleteMemo])
            config.performsFirstActionWithFullSwipe = false
            return config
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section != 0
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //@리팩토링: 첫행은 순서변경불가 처리예정
        let categoryToMove = categoryListArray[sourceIndexPath.row]
        categoryListArray.remove(at: sourceIndexPath.row)
        categoryListArray.insert(categoryToMove, at: destinationIndexPath.row)
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
        print(categoryList[indexPath.row].category)
        if indexPath.section == 0 {
            let vc = BookListViewController(categorySortType: .all, navigationTitle: UserDefaults.standard.string(forKey: "defaultCategoryTitle"))
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            //print(bookList)
            let vc = BookListViewController(categorySortType: .category(categoryCode: "\(categoryListArray[indexPath.row].categorySortCode)"), navigationTitle: "\(categoryListArray[indexPath.row].category)")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
