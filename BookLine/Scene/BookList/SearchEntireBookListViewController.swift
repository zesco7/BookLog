//
//  SearchEntireBookListViewController.swift
//  BookLine
//
//  Created by Mac Pro 15 on 2023/01/01.
//

import UIKit
import RealmSwift

class SearchEntireBookListViewController: BaseViewController {
    var mainView = SearchEntireBookListView()
    var searchEntireBookLocalRealm = try! Realm()
    var searchEntireBookList : Results<BookData>!
    var categorySortCode : String?
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(SearchEntireBookListViewCell.self, forCellReuseIdentifier: SearchEntireBookListViewCell.identifier)
        mainView.tableView.allowsMultipleSelection = true
        navigationAttribute()
        
        searchEntireBookList = searchEntireBookLocalRealm.objects(BookData.self).sorted(byKeyPath: "lastUpdate", ascending: true)
        
    }
    
    func navigationAttribute() {
        self.navigationItem.title = UserDefaults.standard.string(forKey: "defaultCategoryTitle")
        let completionButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completionButtonClicked))
        self.navigationItem.rightBarButtonItem = completionButton
    }
    
    @objc func completionButtonClicked() {
        self.mainView.tableView.reloadData()
        self.dismiss(animated: true)
    }
    
}

extension SearchEntireBookListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchEntireBookList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchEntireBookListViewCell.identifier , for: indexPath) as? SearchEntireBookListViewCell else { return UITableViewCell() }
        cell.backgroundColor = .clear
        
        cell.bookName.text = searchEntireBookList[indexPath.row].title
        cell.bookAuthor.text = searchEntireBookList[indexPath.row].author
        cell.bookRating.text = "\(searchEntireBookList[indexPath.row].rating!)"
        cell.bookReview.text = searchEntireBookList[indexPath.row].review
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let record = searchEntireBookList[indexPath.row]
        print(record)
        try! self.searchEntireBookLocalRealm.write({
            record.categorySortCode = self.categorySortCode!
        })
        print("searchBarTapped")
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
