import UIKit
import Foundation

extension String {
    
    func height(width: CGFloat, font: UIFont) -> CGFloat {
        let textSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        
        let size = self.boundingRect(
            with: textSize,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font : font],
            context: nil
        )
        
        return ceil(size.height)
    }
    
    // one line text height
    func height(font: UIFont) -> CGFloat {
        let textSize = CGSize(width: CGFloat(20), height: .greatestFiniteMagnitude)
        
        let size = self.boundingRect(
            with: textSize,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font : font],
            context: nil
        )
        
        return ceil(size.height)
    }
}

extension UILabel {
    // one line text height
    func height() -> CGFloat {
        let textSize = CGSize(width: CGFloat(1000), height: .greatestFiniteMagnitude)
        let size = "SomeText".boundingRect(
            with: textSize,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font : self.font ?? UIFont.systemFont(ofSize: 10, weight: .medium)],
            context: nil
        )
        
        return ceil(size.height)
    }
}
