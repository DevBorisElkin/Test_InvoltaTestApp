//
//  MessengerRouter.swift
//  Test_InvoltaTestApp
//
//  Created by test on 26.08.2022.
//

import Foundation

class MessengerRouter: MessengerPresenterToRouterProtocol {
    var entry: EntryPoint?
    
    static func start() -> MessengerPresenterToRouterProtocol {
        // create instances
        let presenter = MessengerPresenter()
        let interactor = MessengerInteractor()
        let router = MessengerRouter()
        
        // create UI instances
        let viewController = MessengerViewController()
        
        // assign appropriate values
        interactor.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = viewController
        viewController.presenter = presenter
        
        router.entry = viewController
        
        return router
    }
}
