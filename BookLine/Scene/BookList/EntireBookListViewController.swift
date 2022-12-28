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
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        mainView.tableView.register(EntireBookListViewCell.self, forCellReuseIdentifier: "EntireBookListViewCell")
        
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
    }
}

extension EntireBookListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntireBookListViewCell", for: indexPath) as? EntireBookListViewCell else { return UITableViewCell() }
        
        cell.bookName.text = "저승 가는 길에는 목욕탕이 있다"
        cell.bookAuthor.text = "마카롱"
        cell.bookRating.text = "5.0"
        cell.bookReview.text = "우주 안에 무한한 소우주가 존재하듯 인간의 사념도 수 갈래의 하늘과 땅을 만들고, 어느 저승도 그렇게 탄생했다. 이 이야기로 죽음 너머의 한 세계를 소개하려 한다."
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
