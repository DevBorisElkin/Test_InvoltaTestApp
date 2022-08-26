//
//  MessengerProtocols.swift
//  Test_InvoltaTestApp
//
//  Created by test on 26.08.2022.
//

import Foundation
import UIKit

protocol MessengerViewToPresenterProtocol: AnyObject {
    var view: MessengerPresenterToViewProtocol? { get set }
    var interactor: MessengerPresenterToInteractorProtocol? { get set }
    var router: MessengerPresenterToRouterProtocol? { get set }
    
    func viewDidLoad()
    func getMessages()
}

protocol MessengerViewToPresenterTableViewProtocol: AnyObject {
    func canScrollProgrammatically() -> Bool
    func lastRowIndex() -> Int
    func numberOfRowsInSection() -> Int
    func setCell(tableView: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell
    func tableViewCellHeight(at indexPath: IndexPath) -> CGFloat
    func scrollViewDidScroll(scrollView: UIScrollView)
}

typealias MessengerPresenterProtocols = MessengerViewToPresenterProtocol & MessengerViewToPresenterTableViewProtocol

protocol MessengerPresenterToViewProtocol: AnyObject {
    var presenter: MessengerPresenterProtocols? { get set }
    
    func onFetchMessagesStarted(isInitialLoad: Bool)
    func onFetchMessagesCompleted(addedAnyNewMessages: Bool)
    func onFetchMessagesFail(error: Error, ranOutOfAttempts: Bool)
}

protocol MessengerPresenterToInteractorProtocol: AnyObject {
    var presenter: MessengerInteractorToPresenterProtocol? { get set }
    
    func loadMessages(messageOffset: Int)
}

protocol MessengerInteractorToPresenterProtocol: AnyObject {
    func receivedMessages(messagesData: MessagesWrapped)
    func onMessagesLoadingFailed(error: Error, ranOutOfAttempts: Bool)
}

typealias EntryPoint = MessengerPresenterToViewProtocol & UIViewController

protocol MessengerPresenterToRouterProtocol: AnyObject {
    var entry: EntryPoint? { get }
    
    static func start() -> MessengerPresenterToRouterProtocol
    
    // func pushTo // need method to open window with video details
}
