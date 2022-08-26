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
    
    struct Sizes {
        var authorImageFrame: CGRect
        var authorNameFame: CGRect
        var messageTextFrame: CGRect
        var cellHeight: CGFloat
    }
}
