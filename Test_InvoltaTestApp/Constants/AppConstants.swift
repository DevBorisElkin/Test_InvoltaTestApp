//
//  AppConstants.swift
//  Test_InvoltaTestApp
//
//  Created by test on 26.08.2022.
//

import Foundation
import UIKit

class AppConstants {
    static var screenWidth: CGFloat = UIScreen.main.bounds.width
    static var safeAreaPadding: UIEdgeInsets = UIEdgeInsets.zero
    
    static func initializePaddings(window: UIWindow){
        safeAreaPadding = window.safeAreaInsets
    }
    
    // to see loading spinners and etc.
    static let messagesRequestArtificialDelay: Double = 0.6
    
    static let expandCustomButtonsClickArea = CGPoint(x: 10, y: 10)
}
