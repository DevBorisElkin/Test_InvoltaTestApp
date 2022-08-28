//
//  MessageDetailsConstants.swift
//  Test_InvoltaTestApp
//
//  Created by test on 28.08.2022.
//

import Foundation
import UIKit

class MessageDetailsConstants {
    // MARK: Fonts
    static let messageAuthorFont = UIFont.systemFont(ofSize: 16, weight: .medium)
    static let messageAuthorLimitLines: CGFloat = 2
    static let messageTextFont = UIFont.systemFont(ofSize: 13, weight: .regular)
    static let messageDateFont = UIFont.systemFont(ofSize: 13, weight: .regular)
    
    // MARK: Colors
    static let messageAuthorFontColor = #colorLiteral(red: 0.1803921569, green: 0.1803921569, blue: 0.1803921569, alpha: 1)
    static let messageDateFontColor = #colorLiteral(red: 0.231372549, green: 0.2235294118, blue: 0.2705882353, alpha: 1)
    static let messageTextFontColor = #colorLiteral(red: 0.1803921569, green: 0.1803921569, blue: 0.1803921569, alpha: 1)
    
    // MARK: Sizes and insets
    static let cardViewOffset = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
    static let cardViewWidthOfScreenMult: CGFloat = 0.65
    
    static let messageAuthorIconSize = CGSize(width: 70, height: 70)
    static let messageAuthorIconOffsetFromCardView: CGFloat = -(messageAuthorIconSize.height / 2 + (-0.1 * messageAuthorIconSize.height))
    
    static let messageAuthorInsets = UIEdgeInsets(top: 8, left: 30, bottom: 5, right: 30)
    static let messageDateInsets = UIEdgeInsets(top: 8, left: 45, bottom: 5, right: 45)
    static let messageTextInsets = UIEdgeInsets(top: 8, left: 9, bottom: 8, right: 9)
    
    // MARK: Buttons insets
    static let topRightCloseMessageDetailsButtonInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    static let topRightCloseMessageDetailsButtonSize = CGSize(width: 20, height: 20)
    
    // Bottom buttons
    static let buttonsStackViewInsets = UIEdgeInsets(top: 5, left: 5, bottom: 8, right: 5)
    static let buttonsStackViewHeight: CGFloat = 20
    
    static let closeMessageDetailsButtonInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    static let closeMessageDetailsButtonSize = CGSize(width: 100, height: 30)
    
    static let deleteMessageDetailsButtonInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    static let deleteMessageDetailsButtonSize = CGSize(width: 100, height: 30)
}
