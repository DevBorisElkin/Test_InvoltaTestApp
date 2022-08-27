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
    
    var isKeyboardShown = false
    
    var titleView = TitleView()
    
    var keyboardView = KeyboardView()
    
    var loadingView: LoadingView = {
        let loadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.backgroundColor = .clear
        return loadingView
    }()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        presenter?.viewDidLoad()
    }
    
    func setUI(){
        view.backgroundColor = #colorLiteral(red: 0.6736666451, green: 0.8496916506, blue: 0.9686274529, alpha: 1)
        setNavigationBar()
        setKeyboard()
        setTableView()
        setLoadingView()
    }
    
    // MARK: SET UI
    func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
        
        view.addSubview(titleView)
        titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        titleView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        titleView.heightAnchor.constraint(equalToConstant: GeneralUIConstants.titleViewHeight).isActive = true
    }
    
    func setKeyboard() {
        view.addSubview(keyboardView)
        keyboardView.frame = GeneralUIConstants.keyboardFrame
        keyboardView.searchTextField.textChangedDelegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification){
        guard !isKeyboardShown else { return }
        isKeyboardShown = true
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as?  NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height

            tableView.frame = GeneralUIConstants.calculateTableViewRectWithKeyboard(keyboardHeight: keyboardHeight)
            
            keyboardView.frame = GeneralUIConstants.calculateKeyboardParentFrameWithKeyboard(keyboardHeight: keyboardHeight)
        }
     }
    
    @objc private func keyboardWillHide(){
        tableView.frame = GeneralUIConstants.tableViewRect
        keyboardView.frame = GeneralUIConstants.keyboardFrame
        isKeyboardShown = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setTableView() {
        
        view.addSubview(tableView)
        
        tableView.frame = GeneralUIConstants.tableViewRect
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MessageViewTableViewCell.self, forCellReuseIdentifier: MessageViewTableViewCell.reuseId)
        
        tableView.transform = CGAffineTransform (scaleX: 1,y: -1)
    }
    
    func setLoadingView() {
        view.addSubview(loadingView)
        loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 30).isActive = true
        loadingView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        loadingView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    // MARK: MessengerView Protocol methods
    
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
    
    func onLocalMessageSent() {
        tableView.reloadData()
    }
}

// MARK: Table view protocols

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

extension MessengerViewController: InsertableTextFieldDelegate {
    func onTextChanged(text: String, isNotEmpty: Bool) {
        // text changed
    }
    
    func onReturnButtonPressed(for text: String) {
        print("VC user sent message: \(text)")
        presenter?.userSentMessage(message: text)
    }
}
