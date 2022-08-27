//
//  MessengerViewController.swift
//  Test_InvoltaTestApp
//
//  Created by test on 26.08.2022.
//

import Foundation
import UIKit

class MessengerViewController: UIViewController,  MessengerPresenterToViewProtocol {
    var presenter: MessengerPresenterProtocols?
    
    var titleView = TitleView()
    var keyboardView = KeyboardView()
    
    var loadingView: LoadingView = {
        let loadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.backgroundColor = .clear
        return loadingView
    }()
    
    //var refreshView: UIView?
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        //tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.6736666451, green: 0.8496916506, blue: 0.9686274529, alpha: 1)
        setNavigationBar()
        setKeyboard()
        setUpUI()
        presenter?.viewDidLoad()
    }
    
    func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
        
        view.addSubview(titleView)
        titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        titleView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        titleView.heightAnchor.constraint(equalToConstant: GeneralUIConstants.titleViewHeight).isActive = true
        //navigationItem.titleView = titleView
        //titleView.fillSuperview()
    }
    
    // MARK: KEYBOARD SET UP
    var isKeyboardShown = false
    func setKeyboard() {
        view.addSubview(keyboardView)
        keyboardView.frame = GeneralUIConstants.keyboardFrame
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification){
        print("keyboard will show")
        
        guard !isKeyboardShown else { return }
        isKeyboardShown = true
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as?  NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height

            tableView.frame = GeneralUIConstants.calculateTableViewRectWithKeyboard(keyboardHeight: keyboardHeight)
            
            keyboardView.frame = GeneralUIConstants.calculateKeyboardFrameWithKeyboard(keyboardHeight: keyboardHeight)
        }
     }
    
    @objc private func keyboardWillHide(){
        print("keyboard will hide")
        //self.view.frame.origin.y = 0
        //self.tableView.frame.origin.y = titleView.frame.maxY
        tableView.frame = GeneralUIConstants.tableViewRect
        keyboardView.frame = GeneralUIConstants.keyboardFrame
        isKeyboardShown = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: OTHER
    
    func setUpUI() {
        
        view.addSubview(tableView)
        
        view.addSubview(loadingView)
        loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 30).isActive = true
        loadingView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        loadingView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //tableView.anchor(top: titleView.bottomAnchor, leading: view.leadingAnchor, bottom: keyboardView.topAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        tableView.frame = GeneralUIConstants.tableViewRect
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MessageViewTableViewCell.self, forCellReuseIdentifier: MessageViewTableViewCell.reuseId)
        
        tableView.transform = CGAffineTransform (scaleX: 1,y: -1)
    }
    
    
    
    
    
    func onFetchMessagesStarted(isInitialLoad: Bool) {
        tableView.tableFooterView = UIHelpers.createSpinnerFooterWithBackground(height: 50, innerRectSize: CGSize(width: 30, height: 30))
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
