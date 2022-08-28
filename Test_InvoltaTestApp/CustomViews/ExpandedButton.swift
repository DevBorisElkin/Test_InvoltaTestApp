//
//  ExpandedButton.swift
//  Test_InvoltaTestApp
//
//  Created by test on 28.08.2022.
//

import Foundation
import UIKit

class ExpandedButton: UIButton {
    
    var clickIncreasedArea: CGPoint = .zero
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: -clickIncreasedArea.x, dy: -clickIncreasedArea.y).contains(point)
    }
}
