//
//  MessengerViewController.swift
//  Test_InvoltaTestApp
//
//  Created by test on 26.08.2022.
//

import Foundation
import UIKit

class MessengerViewController: UIViewController,  MessengerPresenterToViewProtocol {
    weak var presenter: MessengerViewToPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .brown
    }
    
    func onFetchMessagesStarted() {
        
    }
    
    func onFetchMessagesCompleted() {
        
    }
    
    func onFetchMessagesFail(error: Error) {
        
    }
}
