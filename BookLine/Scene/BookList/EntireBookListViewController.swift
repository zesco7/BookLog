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
    
    func navigationAttribute() {
        self.navigationItem.title = "모든 책"
        let sortButton = UIBarButtonItem(title: "정렬", style: .plain, target: self, action: #selector(sortButtonClicked))
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonClicked))
        self.navigationItem.rightBarButtonItems = [plusButton, sortButton]
    }
    
    @objc func sortButtonClicked() {
        //제목순, 별점순, 최종작성날짜순 선택목록 표시
    }
    
    @objc func plusButtonClicked() {
        //책검색화면으로 이동
        let record = BookData(lastUpdate: Date(), categorySortCode: "1", ISBN: "\(Int.random(in: 1...1000))", rating: 1.1, review: "1", memo: "1", title: "1", author: "1", publisher: "1", pubdate: Date(), linkURL: "1", imageURL: "1") //Realm 레코드 생성
        
        try! bookLocalRealm.write {
            bookLocalRealm.add(record) //경로에 레코드 추가
            print("Realm Succeed. localRealm is located at: ", bookLocalRealm.configuration.fileURL!)
            mainView.tableView.reloadData()
        }
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
        self.navigationController?.pushViewController(vc, animated: true)
    }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 120
        }
    }
