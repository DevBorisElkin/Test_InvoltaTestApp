//
//  MessageCellConstants.swift
//  Test_InvoltaTestApp
//
//  Created by test on 26.08.2022.
//

import Foundation
import UIKit

class MessageCellConstants {
    // MARK: Fonts
    static let messageAuthorFont = UIFont.systemFont(ofSize: 15, weight: .medium)
    static let messageAuthorLimitLines: CGFloat = 2
    static let messageTextFont = UIFont.systemFont(ofSize: 13, weight: .regular)
    
    // MARK: Colors
    static let messageAuthorFontColor = #colorLiteral(red: 0.1803921569, green: 0.1803921569, blue: 0.1803921569, alpha: 1)
    static let messageTextFontColor = #colorLiteral(red: 0.231372549, green: 0.2235294118, blue: 0.2705882353, alpha: 1)
    
    // MARK: Sizes and insets
    static let cardViewOffset = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
    
    static let messageAuthorIconSize = CGSize(width: 45, height: 45)
    static let messageAuthorIconInsets = UIEdgeInsets(top: 8, left: 8, bottom: 16, right: 8)
    
    static let messageAuthorInsets = UIEdgeInsets(top: 8, left: 8, bottom: 5, right: 8)
    static let messageTextInsets = UIEdgeInsets(top: 4, left: 8, bottom: 8, right: 8)
    
    // MARK: Card View animation related
    static let cellOpeningAnimationDuration: Double = 2
    static let cellOpeningAnimationInterval: Double = 0.5
    
}
