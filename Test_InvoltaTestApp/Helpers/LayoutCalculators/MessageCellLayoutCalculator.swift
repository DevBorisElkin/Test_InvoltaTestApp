//
//  MessageCellLayoutCalculator.swift
//  Test_InvoltaTestApp
//
//  Created by test on 26.08.2022.
//

import Foundation
import UIKit

class MessageCellLayoutCalculator {
    static func calculateMessageCellSizes(authorName: String, messageText: String, messageBelongsToCurrentUser: Bool) -> MessageItemViewModel.Sizes {
        
        let cardViewWidth: CGFloat = AppConstants.screenWidth * MessageCellConstants.cardViewWidthOfScreenMult
        let cardViewXPoint: CGFloat = MessageCellConstants.messageAuthorIconInsets.left + MessageCellConstants.messageAuthorIconSize.width + MessageCellConstants.cardViewOffset.left
        
        var authorImageFrameOrigin = CGPoint.zero
        if !messageBelongsToCurrentUser {
            authorImageFrameOrigin = CGPoint(x: -MessageCellConstants.messageAuthorIconInsets.right - MessageCellConstants.messageAuthorIconSize.width, y: MessageCellConstants.messageAuthorIconInsets.top)
        }else{
            authorImageFrameOrigin = CGPoint(x: cardViewWidth + MessageCellConstants.messageAuthorIconInsets.left, y: MessageCellConstants.messageAuthorIconInsets.top)
        }
        
        // MARK: Calculate author image frame
        let authorImageFrame = CGRect(origin: authorImageFrameOrigin,
                                      size: MessageCellConstants.messageAuthorIconSize)
        
        // MARK: Calculate author name frame
        var authorNameFame = CGRect(origin: CGPoint(x: MessageCellConstants.messageAuthorInsets.left , y: MessageCellConstants.messageAuthorInsets.top), size: .zero)
        
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
        var messageTextFrame = CGRect(origin: CGPoint(x: MessageCellConstants.messageTextInsets.left , y:  authorNameFame.maxY + MessageCellConstants.messageTextInsets.top), size: .zero)
        
        let messageTextWidth: CGFloat = cardViewWidth - authorImageFrame.maxX - MessageCellConstants.messageTextInsets.left - MessageCellConstants.messageTextInsets.right
        
        if !messageText.isEmpty {
            let height = messageText.height(width: messageTextWidth, font: MessageCellConstants.messageTextFont)
            messageTextFrame.size = CGSize(width: messageTextWidth, height: height)
        }
        
        // MARK: Calculate cell height:
        
        let minCellHeight: CGFloat = MessageCellConstants.messageAuthorIconSize.height + MessageCellConstants.messageAuthorIconInsets.top + MessageCellConstants.messageAuthorIconInsets.bottom + MessageCellConstants.cardViewOffset.top + MessageCellConstants.cardViewOffset.bottom
        
        let cellHeight: CGFloat = messageTextFrame.maxY + MessageCellConstants.messageTextInsets.bottom + MessageCellConstants.cardViewOffset.top + MessageCellConstants.cardViewOffset.bottom
        
        let finalCellHeight = max(minCellHeight, cellHeight)
        
        // MARK: Calculate Card View frame
        let cardViewHeight: CGFloat = finalCellHeight - MessageCellConstants.cardViewOffset.top - MessageCellConstants.cardViewOffset.bottom
        let cardViewFrame = CGRect(x: cardViewXPoint, y: MessageCellConstants.cardViewOffset.top, width: cardViewWidth, height: cardViewHeight)
        
        let cardViewInitialPoint = CGPoint(x: -cardViewWidth, y: cardViewFrame.minY)
        
        return MessageItemViewModel.Sizes(cardViewInitialPoint: cardViewInitialPoint,
                                          cardViewFrame: cardViewFrame,
                                          authorImageFrame: authorImageFrame,
                                          authorNameFame: authorNameFame,
                                          messageTextFrame: messageTextFrame,
                                          cellHeight: finalCellHeight)
    }
}
