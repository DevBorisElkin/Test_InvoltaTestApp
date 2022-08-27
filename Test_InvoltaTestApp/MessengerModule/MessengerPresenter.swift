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
    var lastLoadedItemOffset = 0
    
    func viewDidLoad() {
        interactor?.loadLocalMessages()
        tryToLoadMessages(messageOffset: 0)
    }
    
    func getMessages() {
        tryToLoadMessages(messageOffset: lastLoadedItemOffset)
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
        interactor?.saveLocalMessage(messageEntity: CoreDataMessageEntityToSave(author: AppConstants.currentUserNickname, message: message))
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
        lastLoadedItemOffset += messageItems.count
        self.messageItems.append(contentsOf: messageItems)
        
        DispatchQueue.main.async { [weak self] in
            self?.view?.onFetchMessagesCompleted(addedAnyNewMessages: messageItems.count > 0)
        }
        
        isFetchingContent = false
    }
    
    func receivedLocalMessages(localMessages: [MessageDataItem]) {
        var messageItems = [MessageItemViewModel]()
        
        for i in 0 ..< localMessages.count {
            
            guard let authorName = localMessages[i].author, let messageText = localMessages[i].message else{
                print("Error fetching local message")
                continue
            }
            let authorImageUrl = AppConstants.currentUserImageUrl
            
            let messageItem = prepareMessageItem(authorName: authorName, authorImageUrl: authorImageUrl, message: messageText, belongsToCurrentUser: true)
            
            messageItems.append(messageItem)
        }
        guard messageItems.count > 0 else {
            print("Loading of local messages ended but no messages were found")
            return
        }
        print("Loading of local messages ended")
        self.messageItems.append(contentsOf: messageItems)
        view?.updateMessagesTable()
    }
    
    func localMessageSaved(localMessage: MessageDataItem) {
        insertLatestUserMessage(author: localMessage.author ?? "ErrorAuthor", message: localMessage.message ?? "ErrorMessage")
    }
    
    private func insertLatestUserMessage(author: String, message: String){
        var messageViewModel = prepareMessageItem(authorName: AppConstants.currentUserNickname, authorImageUrl: AppConstants.currentUserImageUrl, message: message, belongsToCurrentUser: true)
        messageItems.insert(messageViewModel, at: 0)
        view?.onLocalMessageSent()
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
