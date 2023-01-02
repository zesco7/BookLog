//
//  EntireBookListViewController.swift
//  BookLine
//
//  Created by Mac Pro 15 on 2022/12/28.
//

import UIKit
import RealmSwift

class EntireBookListViewController: BaseViewController {
    var mainView = EntireBookListView()
    
    var entireBookLocalRealm = try! Realm()
    var entireBookList : Results<BookData>!
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        mainView.tableView.register(EntireBookListViewCell.self, forCellReuseIdentifier: EntireBookListViewCell.identifier)
        
        entireBookList = entireBookLocalRealm.objects(BookData.self).sorted(byKeyPath: "lastUpdate", ascending: true)
        
        navigationAttribute()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mainView.tableView.reloadData()
    }
    
    func dateFormatter() {
        //날짜표시형식 변경필요(한국시간)
    }
    
    func navigationAttribute() {
        self.navigationItem.title = "모든 책"
        let sortButton = UIBarButtonItem(title: "정렬", style: .plain, target: self, action: #selector(sortButtonClicked))
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonClicked))
        self.navigationItem.rightBarButtonItems = [plusButton, sortButton]
    }
    
    @objc func sortButtonClicked() {
        //iOS14미만: actionSheet
        actionSheetForSort()
        
        //iOS14+: UImenu
        uiMenuForSort()
    }
    
    @objc func plusButtonClicked() {
        //카테고리 구분코드 전달 + 책검색화면으로 이동
        let vc = BookSearchViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func actionSheetForSort() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let sortBytitle = UIAlertAction(title: "제목순", style: .default) { _ in
            self.entireBookList = self.entireBookLocalRealm.objects(BookData.self).sorted(byKeyPath: "title", ascending: true)
            self.mainView.tableView.reloadData()
        }
        let sortByRating = UIAlertAction(title: "별점순", style: .default) { _ in
            self.entireBookList = self.entireBookLocalRealm.objects(BookData.self).sorted(byKeyPath: "rating", ascending: true)
            self.mainView.tableView.reloadData()
        }
        let sortByLastUpdate = UIAlertAction(title: "최종날짜순", style: .default) { _ in
            self.entireBookList = self.entireBookLocalRealm.objects(BookData.self).sorted(byKeyPath: "lastUpdate", ascending: true)
            self.mainView.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        actionSheet.addAction(sortBytitle)
        actionSheet.addAction(sortByRating)
        actionSheet.addAction(sortByLastUpdate)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true)
    }
    
    func uiMenuForSort() {
        let sortBytitle = UIAction(title: "제목순") { _ in
            self.entireBookList = self.entireBookLocalRealm.objects(BookData.self).sorted(byKeyPath: "title", ascending: true)
            self.mainView.tableView.reloadData()
        }
        
        let sortByRating = UIAction(title: "별점순") { _ in
            self.entireBookList = self.entireBookLocalRealm.objects(BookData.self).sorted(byKeyPath: "rating", ascending: true)
            self.mainView.tableView.reloadData()
        }
        
        let sortByLastUpdate = UIAction(title: "최종날짜순") { _ in
            self.entireBookList = self.entireBookLocalRealm.objects(BookData.self).sorted(byKeyPath: "lastUpdate", ascending: true)
            self.mainView.tableView.reloadData()
        }
        let menu = UIMenu(title: "정렬기준 선택", children: [sortBytitle, sortByRating, sortByLastUpdate])
    }
}

extension EntireBookListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entireBookList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EntireBookListViewCell.identifier , for: indexPath) as? EntireBookListViewCell else { return UITableViewCell() }
        cell.backgroundColor = .clear
        
        cell.bookName.text = entireBookList[indexPath.row].title
        cell.bookAuthor.text = entireBookList[indexPath.row].author
        cell.bookRating.text = "\(entireBookList[indexPath.row].rating!)"
        cell.bookReview.text = entireBookList[indexPath.row].review
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteMemo = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            let alert = UIAlertController(title: "삭제하시겠습니까?", message: nil, preferredStyle: .alert)
            let ok = UIAlertAction(title: "삭제", style: .destructive) { _ in
                try! self.entireBookLocalRealm.write {
                    self.entireBookLocalRealm.delete(self.entireBookList[indexPath.row])
                    self.mainView.tableView.reloadData()
                    print("Realm Deleted")
                }
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            alert.addAction(ok)
            alert.addAction(cancel)
            self.present(alert, animated: true)
        }
        deleteMemo.image = UIImage(systemName: "trash.fill")
        deleteMemo.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteMemo])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = BookMemoViewController()
        vc.bookTitle = entireBookList[indexPath.row].title
        vc.bookWriter = entireBookList[indexPath.row].author
        self.navigationController?.pushViewController(vc, animated: true)
    }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 120
        }
    }
