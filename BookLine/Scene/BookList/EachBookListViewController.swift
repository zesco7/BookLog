//
//  EachBookListViewController.swift
//  BookLine
//
//  Created by Mac Pro 15 on 2022/12/28.
//

import UIKit
import RealmSwift

class EachBookListViewController: BaseViewController {
    var mainView = EachBookListView()
    var navigationTitle: String?
    
    var eachBookLocalRealm = try! Realm()
    var eachBookList : Results<BookData>!
    var categorySortCode : String?
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        mainView.tableView.register(EachBookListViewCell.self, forCellReuseIdentifier: EachBookListViewCell.identifier)
        navigationAttribute()
        print(categorySortCode)
        
        //eachBookList초기화: categorySortCode기준으로 필터링해서 카테고리에 해당하는 책만 화면표시
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        eachBookList = eachBookLocalRealm.objects(BookData.self).filter("categorySortCode == '\(categorySortCode!)'").sorted(byKeyPath: "lastUpdate", ascending: true)
        mainView.tableView.reloadData()
    }
    
    func navigationAttribute() {
        self.navigationItem.title = navigationTitle
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
    
    func actionSheetForSort() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let sortBytitle = UIAlertAction(title: "제목순", style: .default) { _ in
            self.eachBookList = self.eachBookLocalRealm.objects(BookData.self).sorted(byKeyPath: "title", ascending: true)
            self.mainView.tableView.reloadData()
        }
        let sortByRating = UIAlertAction(title: "별점순", style: .default) { _ in
            self.eachBookList = self.eachBookLocalRealm.objects(BookData.self).sorted(byKeyPath: "rating", ascending: true)
            self.mainView.tableView.reloadData()
        }
        let sortByLastUpdate = UIAlertAction(title: "최종날짜순", style: .default) { _ in
            self.eachBookList = self.eachBookLocalRealm.objects(BookData.self).sorted(byKeyPath: "lastUpdate", ascending: true)
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
            self.eachBookList = self.eachBookLocalRealm.objects(BookData.self).sorted(byKeyPath: "title", ascending: true)
            self.mainView.tableView.reloadData()
        }
        
        let sortByRating = UIAction(title: "별점순") { _ in
            self.eachBookList = self.eachBookLocalRealm.objects(BookData.self).sorted(byKeyPath: "rating", ascending: true)
            self.mainView.tableView.reloadData()
        }
        
        let sortByLastUpdate = UIAction(title: "최종날짜순") { _ in
            self.eachBookList = self.eachBookLocalRealm.objects(BookData.self).sorted(byKeyPath: "lastUpdate", ascending: true)
            self.mainView.tableView.reloadData()
        }
        let menu = UIMenu(title: "정렬기준 선택", children: [sortBytitle, sortByRating, sortByLastUpdate])
    }
    
    @objc func plusButtonClicked() {
        //책추가 옵션 표시
        actionSheetForBookSearch()
    }
    
    func actionSheetForBookSearch() {
        let actionSheet = UIAlertController(title: "원하는 책을 찾아보세요", message: nil, preferredStyle: .actionSheet)
        let searchingForNewBook = UIAlertAction(title: "새 책 찾기", style: .default) { _ in
            let vc = BookSearchViewController()
            vc.categorySortCode = self.categorySortCode!
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let searchingForSavedBook = UIAlertAction(title: "저장된 책에서 찾기", style: .default) { _ in
            self.bookTransferNavigationAttribute()
            let vc = SearchEntireBookListViewController()
            vc.categorySortCode = self.categorySortCode!
            let navi = UINavigationController(rootViewController: vc)
            self.present(navi, animated: true)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        actionSheet.addAction(searchingForNewBook)
        actionSheet.addAction(searchingForSavedBook)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true)
    }
    
    func bookTransferNavigationAttribute() {
        let vc = CategoryListViewController()
        self.navigationItem.title = vc.defaultCategoryTitle[0]
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        let completionButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completionButtonClicked))
        self.navigationItem.rightBarButtonItem = completionButton
    }
    
    @objc func completionButtonClicked() {
        
    }
}

extension EachBookListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eachBookList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EachBookListViewCell.identifier, for: indexPath) as? EachBookListViewCell else { return UITableViewCell() }
        cell.backgroundColor = .clear
        
        cell.bookName.text = eachBookList[indexPath.row].title
        cell.bookAuthor.text = eachBookList[indexPath.row].author
        cell.bookRating.text = "\(eachBookList[indexPath.row].rating!)"
        cell.bookReview.text = eachBookList[indexPath.row].review
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

