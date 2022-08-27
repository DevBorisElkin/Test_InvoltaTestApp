//
//  MessengerInteractor.swift
//  Test_InvoltaTestApp
//
//  Created by test on 26.08.2022.
//

import Foundation

class MessengerInteractor: MessengerPresenterToInteractorProtocol {
    
    weak var presenter: MessengerInteractorToPresenterProtocol?
    
    var coreDataManager = CoreDataManager()
    
    func loadMessages(messageOffset: Int) {
        let requestUrlString = NetworkRequestBuilder.createRequestUrlString(offset: messageOffset)
        
        Task.detached(priority: .medium) { [weak self] in
            
            var currentFailedRequests = 0
            var messagesData: MessagesWrapped?
            var resultVideosData: Result<MessagesWrapped, Error>!
            
            while(messagesData == nil && currentFailedRequests < AppConstants.consecutiveNetworkAttempts) {
                // MARK: LOAD MESSAGES
                
                resultVideosData = await NetworkingHelpers.loadDataFromUrlString(from: requestUrlString, printJsonAndRequestString: false)
                
                if AppConstants.messagesRequestArtificialDelay > 0 {
                    Thread.sleep(forTimeInterval: AppConstants.messagesRequestArtificialDelay)
                }
                
                switch resultVideosData {
                case .success(let data):
                    messagesData = data
                case .failure(let error):
                    currentFailedRequests += 1
                    //print("failed at request, currentFailedRequests: \(currentFailedRequests)")
                    self?.presenter?.onMessagesLoadingFailed(error: error, ranOutOfAttempts: false)
                case .none:
                    break
                }
            }
            
            guard let messagesData = messagesData else {
                //print("currentFailedRequests: \(currentFailedRequests)\nsearch failed for undefined reason")
                let ranOutOfAttempts = currentFailedRequests == AppConstants.consecutiveNetworkAttempts
                self?.presenter?.onMessagesLoadingFailed(error: NetworkingHelpers.NetworkRequestError.undefined, ranOutOfAttempts: ranOutOfAttempts)
                return }
            
            //print("Network request succeeded from attempt: \(currentFailedRequests)")
            self?.presenter?.receivedMessages(messagesData: messagesData)
        }
    }
    
    func loadLocalMessages() {
        var items = coreDataManager.getMessageDataItems()
        presenter?.receivedLocalMessages(localMessages: items)
    }
    
    func saveLocalMessage(messageEntity: CoreDataMessageEntityToSave) {
        if let messageDataItem =  coreDataManager.addMessage(message: messageEntity.message, author: messageEntity.author) {
            presenter?.localMessageSaved(localMessage: messageDataItem)
        }else{
            print("Error saving message to database")
        }
    }
}
