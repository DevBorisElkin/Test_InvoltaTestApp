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
    
//    var refreshControlParent: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .blue
//        return view
//    }()
    
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
    
    func onFetchMessagesStarted() {
        loadingView.startLoading()
    }
    
    func onFetchMessagesCompleted() {
        tableView.reloadData()
        loadingView.endLoading()
    }
    
    func onFetchMessagesFail(error: Error, ranOutOfAttempts: Bool) {
        //print("Failed to fetch messages: \(error)")
        
        if ranOutOfAttempts {
            loadingView.endLoading()
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
    
    // TODO move logic to presenter
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let topPoint = scrollView.contentOffset.y + scrollView.bounds.size.height
        let scrollPointToLoadMoreContent = scrollView.contentSize.height
        //print("topPoint: \(topPoint), scrollPointToLoadMoreContent: \(scrollPointToLoadMoreContent)")
        
        if(topPoint >= scrollPointToLoadMoreContent){
            //print("fetch more data")
            presenter?.getMessages()
        }
        
//        let bottomPoint: CGFloat = scrollView.contentOffset.y + scrollView.bounds.size.height
//        let scrollPointToLoadMoreContent: CGFloat = scrollView.contentSize.height + CommentCellConstants.commentInsetToLoadMoreComments
//
//        if(bottomPoint > scrollPointToLoadMoreContent && table.tableFooterView == nil){
//            print("fetch more data")
//            presenter?.commentsPaginationRequest()
//        }
    }
}

extension MessengerViewController {
    func loadingDataStarted(){
//        if refreshView == nil {
//            var spinnerHeader = UIHelpers.createSpinnerFooterWithConstraints(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 100))
//            refreshView = spinnerHeader
//            refreshControlParent.addSubview(spinnerHeader)
//            //spinnerHeader.frame.origin = CGPoint(x: refreshControlParent.frame.midX, y: refreshControlParent.frame.maxY)
//            spinnerHeader.centerXAnchor.constraint(equalTo: refreshControlParent.centerXAnchor).isActive = true
//            spinnerHeader.centerYAnchor.constraint(equalTo: refreshControlParent.centerYAnchor).isActive = true
//        }
        
        
        
//        self.tableView.tableFooterView = UIHelpers.createSpinnerFooterWithConstraints(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 100))
    }
    
    func loadingDataEnded(){
//        if let refreshView = refreshView {
//            refreshView.removeFromSuperview()
//            self.refreshView = nil
//        }
        
        
        
        
//        self.tableView.tableFooterView = nil
//
//        if let refreshControl = tableView.refreshControl, refreshControl.isRefreshing{
//            refreshControl.endRefreshing()
//        }
    }
}
