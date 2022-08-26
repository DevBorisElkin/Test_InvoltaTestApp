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
    
    func numberOfRowsInSection() -> Int
    func setCell(tableView: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell
    func tableViewCellHeight(at indexPath: IndexPath) -> CGFloat
    
    func getMessages()
}

protocol MessengerPresenterToViewProtocol: AnyObject {
    var presenter: MessengerViewToPresenterProtocol? { get set }
    
    func onFetchMessagesStarted()
    func onFetchMessagesCompleted()
    func onFetchMessagesFail(error: Error)
}

protocol MessengerPresenterToInteractorProtocol: AnyObject {
    var presenter: MessengerInteractorToPresenterProtocol? { get set }
    
    func loadMessages(messageOffset: Int)
}

protocol MessengerInteractorToPresenterProtocol: AnyObject {
    func receivedMessages(messagesData: MessagesWrapped)
    func onMessagesLoadingFailed(error: Error)
}

typealias EntryPoint = MessengerPresenterToViewProtocol & UIViewController

protocol MessengerPresenterToRouterProtocol: AnyObject {
    var entry: EntryPoint? { get }
    
    static func start() -> MessengerPresenterToRouterProtocol
    
    // func pushTo // need method to open window with video details
}
