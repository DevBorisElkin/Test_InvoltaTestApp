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
    
    static let consecutiveNetworkAttempts = 5
    
    // to see loading spinners and etc.
    static let messagesRequestArtificialDelay: Double = 0.6
    
    static let expandCustomButtonsClickArea = CGPoint(x: 10, y: 10)
}

class GeneralUIConstants {
    // title view
    static let titleViewHeightAboveSafeArea: CGFloat = 30
    
    // keyboard general insets
    static var keyboardParentHeight: CGFloat { return AppConstants.safeAreaPadding.bottom + GeneralUIConstants.keyboardInsets.top + GeneralUIConstants.keyboardInsets.bottom + GeneralUIConstants.keyboardHeightAboveSafeArea }
    static let keyboardInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    static let keyboardHeightAboveSafeArea: CGFloat = 34
}
