//
//  MessageCellLayoutCalculator.swift
//  Test_InvoltaTestApp
//
//  Created by test on 26.08.2022.
//

import Foundation
import UIKit

class MessageCellLayoutCalculator {
    static func calculateMessageCellSizes(authorName: String, messageText: String) -> MessageItemViewModel.Sizes {
        
        let cardViewWidth: CGFloat = AppConstants.screenWidth - MessageCellConstants.cardViewOffset.left - MessageCellConstants.cardViewOffset.right
        
        // MARK: Calculate author image frame
        let authorImageFrame = CGRect(origin: CGPoint(x: MessageCellConstants.messageAuthorIconInsets.left,
                                                      y: MessageCellConstants.messageAuthorIconInsets.top),
                                      size: MessageCellConstants.messageAuthorIconSize)
        
        // MARK: Calculate author name frame
        var authorNameFame = CGRect(origin: CGPoint(x: authorImageFrame.maxX + MessageCellConstants.messageAuthorInsets.left , y: MessageCellConstants.messageAuthorInsets.top), size: .zero)
        
        let authorNameWidth: CGFloat = cardViewWidth - authorImageFrame.maxX - MessageCellConstants.messageAuthorInsets.left - MessageCellConstants.messageAuthorInsets.right
        
        if !authorName.isEmpty {
            var height = authorName.height(width: authorNameWidth, font: MessageCellConstants.messageAuthorFont)
            
            // check limit height for name label
            let limitHeight: CGFloat = MessageCellConstants.messageAuthorFont.lineHeight * MessageCellConstants.messageAuthorLimitLines
            if height > limitHeight {
                height = MessageCellConstants.messageAuthorFont.lineHeight * MessageCellConstants.messageAuthorLimitLines
            }
            
            authorNameFame.size = CGSize(width: authorNameWidth, height: height)
        }
        
        // MARK: Calculate comment text frame
        var messageTextFrame = CGRect(origin: CGPoint(x: authorImageFrame.maxX + MessageCellConstants.messageTextInsets.left , y:  authorNameFame.maxY + MessageCellConstants.messageTextInsets.top), size: .zero)
        
        let messageTextWidth: CGFloat = cardViewWidth - authorImageFrame.maxX - MessageCellConstants.messageTextInsets.left - MessageCellConstants.messageTextInsets.right
        
        if !messageText.isEmpty {
            let height = messageText.height(width: messageTextWidth, font: MessageCellConstants.messageTextFont)
            messageTextFrame.size = CGSize(width: messageTextWidth, height: height)
        }
        
        // MARK: Calculate cell height:
        
        let minCellHeight: CGFloat = MessageCellConstants.messageAuthorIconSize.height + MessageCellConstants.messageAuthorIconInsets.top + MessageCellConstants.messageAuthorIconInsets.bottom + MessageCellConstants.cardViewOffset.top + MessageCellConstants.cardViewOffset.bottom
        
        let cellHeight: CGFloat = messageTextFrame.maxY + MessageCellConstants.messageTextInsets.bottom + MessageCellConstants.cardViewOffset.top + MessageCellConstants.cardViewOffset.bottom
        
        let finalCellHeight = max(minCellHeight, cellHeight)
        
        return MessageItemViewModel.Sizes(authorImageFrame: authorImageFrame,
                                          authorNameFame: authorNameFame,
                                          messageTextFrame: messageTextFrame,
                                          cellHeight: finalCellHeight)
    }
}
