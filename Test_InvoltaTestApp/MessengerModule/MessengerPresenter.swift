//
//  MessengerPresenter.swift
//  Test_InvoltaTestApp
//
//  Created by test on 26.08.2022.
//

import Foundation
import UIKit

class MessengerPresenter: MessengerViewToPresenterProtocol {
    weak var view: MessengerPresenterToViewProtocol?
    var interactor: MessengerPresenterToInteractorProtocol?
    var router: MessengerPresenterToRouterProtocol?
    
    var messageItems: [MessageItemViewModel] = []
    var isFetchingContent = false
    var maxMessagesDetected: Int? // to use or not to use?
        
    // MARK: TableViewRelated
    func numberOfRowsInSection() -> Int {
        return messageItems.count
    }
    
    func setCell(tableView: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageViewTableViewCell.reuseId, for: indexPath) as! MessageViewTableViewCell
        
        //cell.contentView.transform = CGAffineTransform (scaleX: 1,y: -1);
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        cell.setUp(viewModel: messageItems[indexPath.row])
        return cell
    }
    
    func tableViewCellHeight(at indexPath: IndexPath) -> CGFloat {
        return messageItems[indexPath.row].sizes.cellHeight
    }
    
    func viewDidLoad() {
        tryToLoadMessages(messageOffset: 0)
    }
    
    func getMessages() {
        tryToLoadMessages(messageOffset: messageItems.count)
    }
    
    private func tryToLoadMessages(messageOffset: Int){
        if !isFetchingContent {
            isFetchingContent = true
            view?.onFetchMessagesStarted()
            interactor?.loadMessages(messageOffset: messageOffset)
        }
    }
}

extension MessengerPresenter: MessengerInteractorToPresenterProtocol {
    func receivedMessages(messagesData: MessagesWrapped) {
        
        var messageItems = [MessageItemViewModel]()
        
        for i in 0 ..< messagesData.result.count {
            
            let authorName = "Bob bb"
            let messageText = messagesData.result[i]
            
            let sizes = MessageCellLayoutCalculator.calculateMessageCellSizes(authorName: authorName, messageText: messageText)
            
            let messageItem = MessageItemViewModel(authorRandomName: authorName,
                                          authorRandomImageUrl: NetworkRequestBuilder.getRandomImageUrl(id: self.messageItems.count + i),
                                                   message: messageText, sizes: sizes)
            messageItems.append(messageItem)
        }
        self.messageItems.append(contentsOf: messageItems)
        
        DispatchQueue.main.async { [weak self] in
            self?.view?.onFetchMessagesCompleted()
        }
        
        isFetchingContent = false
    }
    
    func onMessagesLoadingFailed(error: Error, ranOutOfAttempts: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.onFetchMessagesFail(error: error, ranOutOfAttempts: ranOutOfAttempts)
        }
        
        if ranOutOfAttempts {
            isFetchingContent = false
        }
    }
}
