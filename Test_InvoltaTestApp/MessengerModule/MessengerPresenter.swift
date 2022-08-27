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
    
    var lastScrollTopPoint: CGFloat = 0
    
    func viewDidLoad() {
        tryToLoadMessages(messageOffset: 0)
    }
    
    func getMessages() {
        tryToLoadMessages(messageOffset: messageItems.count)
    }
    
    private func tryToLoadMessages(messageOffset: Int){
        if !isFetchingContent {
            //print("LOADING MESSAGES")
            isFetchingContent = true
            view?.onFetchMessagesStarted(isInitialLoad: messageOffset == 0)
            interactor?.loadMessages(messageOffset: messageOffset)
        }
    }
    
    func userSentMessage(message: String) {
        insertLatestUserMessage(message: message)
    }
    
    private func insertLatestUserMessage(message: String){
        var messageViewModel = prepareMessageItem(authorName: AppConstants.currentUserNickname, authorImageUrl: AppConstants.currentUserImageUrl, message: message, belongsToCurrentUser: true)
        messageItems.insert(messageViewModel, at: 0)
        view?.onLocalMessageSent()
    }
}

// MARK: TableViewRelated
extension MessengerPresenter: MessengerViewToPresenterTableViewProtocol {
    
    func canScrollProgrammatically() -> Bool {
        return messageItems.count > 0
    }
    
    func lastRowIndex() -> Int {
        return messageItems.count - 1
    }
    
    func numberOfRowsInSection() -> Int {
        return messageItems.count
    }
    
    func setCell(tableView: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageViewTableViewCell.reuseId, for: indexPath) as! MessageViewTableViewCell
        
        // reverse for table view
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        // check appear time delay
        var timeDelay: Double = 0
        if(messageItems[indexPath.row].animationData.needToAnimate){
            timeDelay = UIHelpers.calculateTimeDelayBeforeAnimation()
            messageItems[indexPath.row].animationData.delayBeforeAnimation = timeDelay
        }
        
        cell.setUp(viewModel: messageItems[indexPath.row])
        messageItems[indexPath.row].animationData.needToAnimate = false
        return cell
    }
    
    func tableViewCellHeight(at indexPath: IndexPath) -> CGFloat {
        return messageItems[indexPath.row].sizes.cellHeight
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let topPoint = scrollView.contentOffset.y + scrollView.bounds.size.height
        let scrollPointToLoadMoreContent = scrollView.contentSize.height
        
        // direction - up
        if topPoint > lastScrollTopPoint {
            if(topPoint >= scrollPointToLoadMoreContent){
                getMessages()
            }
        }
        lastScrollTopPoint = topPoint
    }
}

extension MessengerPresenter: MessengerInteractorToPresenterProtocol {
    func receivedMessages(messagesData: MessagesWrapped) {
        
        var messageItems = [MessageItemViewModel]()
        
        for i in 0 ..< messagesData.result.count {
            
            let authorName = "Bob bb"
            let authorImageUrl = NetworkRequestBuilder.getRandomImageUrl(id: self.messageItems.count + i)
            let messageText = messagesData.result[i]
            
            let messageItem = prepareMessageItem(authorName: authorName, authorImageUrl: authorImageUrl, message: messageText, belongsToCurrentUser: false)
            
            messageItems.append(messageItem)
        }
        self.messageItems.append(contentsOf: messageItems)
        
        DispatchQueue.main.async { [weak self] in
            self?.view?.onFetchMessagesCompleted(addedAnyNewMessages: messageItems.count > 0)
        }
        
        isFetchingContent = false
    }
    
    func prepareMessageItem(authorName: String, authorImageUrl: String, message: String, belongsToCurrentUser: Bool) -> MessageItemViewModel{
        let sizes = MessageCellLayoutCalculator.calculateMessageCellSizes(authorName: authorName, messageText: message, messageBelongsToCurrentUser: belongsToCurrentUser)
        
        return MessageItemViewModel(authorRandomName: authorName,
                                      authorRandomImageUrl: authorImageUrl,
                                               message: message, belongsToCurrentUser: belongsToCurrentUser, sizes: sizes)
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
