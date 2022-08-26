//
//  PreparedEntities.swift
//  Test_InvoltaTestApp
//
//  Created by test on 26.08.2022.
//

import Foundation
import UIKit

struct MessageItemViewModel {
    var authorRandomName: String
    var authorRandomImageUrl: String
    var message: String
    var sizes: Sizes
    var animationData = AnimationSupportingData()
    
    struct AnimationSupportingData {
        var needToAnimate: Bool = true
        var delayBeforeAnimation: Double = 0
        var animationTime: Double = MessageCellConstants.cellOpeningAnimationDuration
    }
    
    struct Sizes {
        var cardViewInitialPoint: CGPoint
        var cardViewFrame: CGRect
        var authorImageFrame: CGRect
        var authorNameFame: CGRect
        var messageTextFrame: CGRect
        var cellHeight: CGFloat
    }
}
