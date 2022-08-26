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
    weak var interactor: MessengerPresenterToInteractorProtocol?
    weak var router: MessengerPresenterToRouterProtocol?
    
    func viewDidLoad() {
        
    }
    
    func numberOfRowsInSection() -> Int {
        
    }
    
    func setCell(tableView: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
    
    func tableViewCellHeight(at indexPath: IndexPath) -> CGFloat {
        
    }
    
    func getMessages() {
        
    }
    
    
}

extension MessengerPresenter: MessengerInteractorToPresenterProtocol {
    func receivedMessages() {
        
    }
    
    func onMessagesLoadingFailed() {
        
    }
    
    
}
