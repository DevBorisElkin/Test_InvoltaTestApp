//
//  MessengerViewController.swift
//  Test_InvoltaTestApp
//
//  Created by test on 26.08.2022.
//

import Foundation
import UIKit

class MessengerViewController: UIViewController,  MessengerPresenterToViewProtocol {
    var presenter: MessengerViewToPresenterProtocol?
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.backgroundColor = .red
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .brown
        setUpUI()
        presenter?.viewDidLoad()
    }
    
    func setUpUI() {
        view.addSubview(tableView)
//        tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: VideoSearchConstants.tableViewInsets)
        tableView.anchor(top: view.layoutMarginsGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: AppConstants.safeAreaPadding.bottom, right: 0))
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MessageViewTableViewCell.self, forCellReuseIdentifier: MessageViewTableViewCell.reuseId)
        
        tableView.transform = CGAffineTransform (scaleX: 1,y: -1)
        
        
    }
    
    func onFetchMessagesStarted() {
        
    }
    
    func onFetchMessagesCompleted() {
        tableView.reloadData()
    }
    
    func onFetchMessagesFail(error: Error) {
        //print("Failed to fetch messages: \(error)")
    }
}

extension MessengerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection() ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return presenter?.setCell(tableView: tableView, forRowAt: indexPath) ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter?.tableViewCellHeight(at: indexPath) ?? 100
    }
    
}
