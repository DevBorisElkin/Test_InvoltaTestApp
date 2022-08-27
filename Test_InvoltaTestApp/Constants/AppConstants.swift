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
    static var screenHeight: CGFloat = UIScreen.main.bounds.height
    static var safeAreaPadding: UIEdgeInsets = UIEdgeInsets.zero
    
    static func initializePaddings(window: UIWindow){
        safeAreaPadding = window.safeAreaInsets
    }
    
    static let consecutiveNetworkAttempts = 5
    
    // to see loading spinners and etc.
    static let messagesRequestArtificialDelay: Double = 0.6
    
    static let expandCustomButtonsClickArea = CGPoint(x: 10, y: 10)
    
    static let currentUserImageUrl = "https://imagesvc.meredithcorp.io/v3/mm/image?url=https%3A%2F%2Fstatic.onecms.io%2Fwp-content%2Fuploads%2Fsites%2F13%2F2015%2F04%2F05%2Ffeatured.jpg"
    static let currentUserNickname = "Mr.Bob"
}

class GeneralUIConstants {
    // title view
    static let titleViewHeightAboveSafeArea: CGFloat = 30
    static var titleViewHeight: CGFloat { titleViewHeightAboveSafeArea + AppConstants.safeAreaPadding.top }
    
    // table view
    static var tableViewHeight: CGFloat { AppConstants.screenHeight - titleViewHeight - keyboardParentHeight }
    static var tableViewRect: CGRect { CGRect(origin: CGPoint(x: 0, y: GeneralUIConstants.titleViewHeight), size: CGSize(width: AppConstants.screenWidth, height: GeneralUIConstants.tableViewHeight )) }
    static func calculateTableViewRectWithKeyboard(keyboardHeight: CGFloat) -> CGRect {
        return CGRect(origin: CGPoint(x: 0, y: GeneralUIConstants.titleViewHeight), size: CGSize(width: AppConstants.screenWidth, height: GeneralUIConstants.tableViewHeight - (keyboardHeight - AppConstants.safeAreaPadding.bottom)))
    }
    
    // keyboard general insets
    static var keyboardFieldHeight: CGFloat { GeneralUIConstants.keyboardInsets.top + GeneralUIConstants.keyboardInsets.bottom + GeneralUIConstants.keyboardHeightAboveSafeArea }
    static var keyboardParentHeight: CGFloat { return AppConstants.safeAreaPadding.bottom + keyboardFieldHeight }
    
    static var keyboardFrame: CGRect { CGRect(origin: CGPoint(x: 0, y: AppConstants.screenHeight - keyboardParentHeight), size: CGSize(width: AppConstants.screenWidth, height: keyboardParentHeight)) }
    static func calculateKeyboardParentFrameWithKeyboard(keyboardHeight: CGFloat) -> CGRect {
        let rect = keyboardFrame
        return CGRect(origin: CGPoint(x: 0, y: rect.minY - keyboardHeight + AppConstants.safeAreaPadding.bottom), size: rect.size)
    }
    
    static let keyboardInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    static let keyboardHeightAboveSafeArea: CGFloat = 34
}
