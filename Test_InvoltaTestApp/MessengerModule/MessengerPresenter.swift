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
    
    func viewDidLoad() {
        interactor?.loadMessages(messageOffset: 0)
    }
    
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
        return 150
    }
    
    func getMessages() {
        
    }
    
    
}

extension MessengerPresenter: MessengerInteractorToPresenterProtocol {
    func receivedMessages(messagesData: MessagesWrapped) {
        
        var messageItems = [MessageItemViewModel]()
        
        for i in 0 ..< messagesData.result.count {
            let messageItem = MessageItemViewModel(authorRandomName: "Bob",
                                          authorRandomImageUrl: NetworkRequestBuilder.getRandomImageUrl(id: self.messageItems.count + i) /*"https://picsum.photos/300/300"*/,
                                          message: messagesData.result[i])
            messageItems.append(messageItem)
        }
        self.messageItems = messageItems
        
        DispatchQueue.main.async { [weak self] in
            self?.view?.onFetchMessagesCompleted()
        }
        
    }
    
    func onMessagesLoadingFailed(error: Error) {
        view?.onFetchMessagesFail(error: error)
    }
}
