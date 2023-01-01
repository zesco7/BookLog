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
    
    var bookLocalRealm = try! Realm()
    var bookList : Results<BookData>!
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        mainView.tableView.register(EntireBookListViewCell.self, forCellReuseIdentifier: EntireBookListViewCell.identifier)
        
        bookList = bookLocalRealm.objects(BookData.self).sorted(byKeyPath: "lastUpdate", ascending: true)
        print("Realm Succeed. localRealm is located at: ", bookLocalRealm.configuration.fileURL!)
        
        navigationAttribute()
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
        //책검색화면으로 이동
        let vc = BookSearchViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
//        let record = BookData(lastUpdate: Date(), categorySortCode: "1", ISBN: "\(Int.random(in: 1...1000))", rating: 1.1, review: "1", memo: "1", title: "\(Int.random(in: 1...1000))", author: "1", publisher: "1", pubdate: Date(), linkURL: "1", imageURL: "1") //Realm 레코드 생성
//
//        try! bookLocalRealm.write {
//            bookLocalRealm.add(record) //경로에 레코드 추가
//            print("Realm Succeed. localRealm is located at: ", bookLocalRealm.configuration.fileURL!)
//            mainView.tableView.reloadData()
//        }
    }
    
    func actionSheetForSort() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let sortBytitle = UIAlertAction(title: "제목순", style: .default) { _ in
            //realm제목순 정렬 후 reloadData
        }
        let sortByRating = UIAlertAction(title: "별점순", style: .default) { _ in
            //realm별점순 정렬 후 reloadData
        }
        let sortByLastUpdate = UIAlertAction(title: "최종날짜순", style: .default) { _ in
            //realm제목순 정렬 후 reloadData
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        actionSheet.addAction(sortBytitle)
        actionSheet.addAction(sortByRating)
        actionSheet.addAction(sortByLastUpdate)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true)
    }
    
    func uiMenuForSort() {
        //제목순, 별점순, 최종작성날짜순 선택목록 표시
        let sortBytitle = UIAction(title: "제목순") { _ in
            //realm제목순 정렬 후 reloadData
        }
        
        let sortByRating = UIAction(title: "별점순") { _ in
            //realm제목순 정렬 후 reloadData
        }
        
        let sortByLastUpdate = UIAction(title: "최종날짜순") { _ in
            //realm제목순 정렬 후 reloadData
        }
        let menu = UIMenu(title: "정렬기준 선택", children: [sortBytitle, sortByRating, sortByLastUpdate])
    }
}

extension EntireBookListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EntireBookListViewCell.identifier , for: indexPath) as? EntireBookListViewCell else { return UITableViewCell() }
        cell.backgroundColor = .clear
        
        cell.bookName.text = bookList[indexPath.row].title
        cell.bookAuthor.text = bookList[indexPath.row].author
        cell.bookRating.text = "\(bookList[indexPath.row].rating!)"
        cell.bookReview.text = bookList[indexPath.row].review
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteMemo = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            let alert = UIAlertController(title: "삭제하시겠습니까?", message: nil, preferredStyle: .alert)
            let ok = UIAlertAction(title: "삭제", style: .destructive) { _ in
                try! self.bookLocalRealm.write {
                    self.bookLocalRealm.delete(self.bookList[indexPath.row])
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
        vc.bookTitle = bookList[indexPath.row].title
        vc.bookWriter = bookList[indexPath.row].author
        self.navigationController?.pushViewController(vc, animated: true)
    }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 120
        }
    }
