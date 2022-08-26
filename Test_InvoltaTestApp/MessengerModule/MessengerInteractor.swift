//
//  MessengerInteractor.swift
//  Test_InvoltaTestApp
//
//  Created by test on 26.08.2022.
//

import Foundation

class MessengerInteractor: MessengerPresenterToInteractorProtocol {
    
    weak var presenter: MessengerInteractorToPresenterProtocol?
    
    func loadMessages(messageOffset: Int) {
        let requestUrlString = NetworkRequestBuilder.createRequestUrlString(offset: messageOffset)
        
        Task.detached(priority: .medium) { [weak self] in
            
            // MARK: LOAD MESSAGES
            let messagesData: MessagesWrapped?
            let resultVideosData: Result<MessagesWrapped, Error>  = await NetworkingHelpers.loadDataFromUrlString(from: requestUrlString, printJsonAndRequestString: false)
            
            switch resultVideosData {
            case .success(let data):
                messagesData = data
            case .failure(let error):
                print(error)
                self?.presenter?.onMessagesLoadingFailed(error: error)
                return
            }
            guard let messagesData = messagesData else {
                print("search failed");
                self?.presenter?.onMessagesLoadingFailed(error: NetworkingHelpers.NetworkRequestError.undefined)
                return }
            
            self?.presenter?.receivedMessages(messagesData: messagesData)
        }
    }
}
