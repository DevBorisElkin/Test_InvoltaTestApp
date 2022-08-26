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
    
    var loadingView: LoadingView = {
        let loadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.backgroundColor = .clear
        return loadingView
    }()
    
    //var refreshView: UIView?
    
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
        
        view.addSubview(loadingView)
        loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 30).isActive = true
        loadingView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        loadingView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        tableView.anchor(top: view.layoutMarginsGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: AppConstants.safeAreaPadding.bottom, right: 0))
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MessageViewTableViewCell.self, forCellReuseIdentifier: MessageViewTableViewCell.reuseId)
        
        tableView.transform = CGAffineTransform (scaleX: 1,y: -1)
        
    }
    
    func onFetchMessagesStarted(isInitialLoad: Bool) {
        if isInitialLoad {
            loadingView.startLoading()
        } else {
            tableView.tableFooterView = UIHelpers.createSpinnerFooterWithConstraints(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        }
    }
    
    func onFetchMessagesCompleted(addedAnyNewMessages: Bool) {
        loadingView.endLoading()
        tableView.tableFooterView = nil
        
        tableView.reloadData()
        if(!addedAnyNewMessages){
            scrollToTop()
        }
    }
    
    func onFetchMessagesFail(error: Error, ranOutOfAttempts: Bool) {
        //print("Failed to fetch messages: \(error)")
        
        if ranOutOfAttempts {
            self.tableView.tableFooterView = nil
            loadingView.endLoading()
            scrollToTop()
        }else {
            // error but continue loading, present something small like 'networking problems'
        }
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        presenter?.scrollViewDidScroll(scrollView: scrollView)
    }
    
    private func scrollToTop() {
        if let presenter = presenter, presenter.canScrollProgrammatically(){
            let topRow = IndexPath(row: presenter.lastRowIndex(), section: 0)
            self.tableView.scrollToRow(at: topRow, at: .top, animated: true)
        }
    }
}
