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
    
    var data = ["One", "Two", "Thee", "Four", "One", "Two", "Thee", "Four","One", "Two", "Thee", "Four","One", "Two", "Thee", "Four","One", "Two", "Thee", "Four","One", "Two", "Thee", "Four","One", "Two", "Thee", "Four","One", "Two", "Thee", "Four","One", "Two", "Thee", "Four","One", "Two", "Thee", "Four"]
    
    func viewDidLoad() {
        
    }
    
    func numberOfRowsInSection() -> Int {
        return data.count
    }
    
    func setCell(tableView: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageViewTableViewCell.reuseId, for: indexPath) as! MessageViewTableViewCell
        cell.setUp(someText: data[indexPath.row])
        return cell
    }
    
    func tableViewCellHeight(at indexPath: IndexPath) -> CGFloat {
        return 150
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
