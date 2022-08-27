import UIKit

class UIHelpers{
    
    /// for example, frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100)
    public static func createSpinnerFooter(frame: CGRect) -> UIView{
        let footerView = UIView(frame: frame)
        
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        
        spinner.startAnimating()
        return footerView
    }
    
    public static func createSpinnerFooterWithConstraints(frame: CGRect) -> UIView{
        let footerView = UIView(frame: frame)
        
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        footerView.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        
        spinner.startAnimating()
        return footerView
    }
    
    public static func createSpinnerFooterWithBackground(height: CGFloat, innerRectSize: CGSize) -> UIView{
        let footerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: height)))
        
        let cardView = UIView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        footerView.addSubview(cardView)
        cardView.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
        cardView.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        cardView.widthAnchor.constraint(equalToConstant: innerRectSize.width).isActive = true
        cardView.heightAnchor.constraint(equalToConstant: innerRectSize.height).isActive = true
        
        cardView.backgroundColor = #colorLiteral(red: 0.231372549, green: 0.2235294118, blue: 0.2705882353, alpha: 1)
        cardView.layer.cornerRadius = 5
        
        let spinner = UIActivityIndicatorView()
        spinner.transform = CGAffineTransform(scaleX: 1, y: -1)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: cardView.centerYAnchor).isActive = true
        
        spinner.startAnimating()
        return footerView
    }
    
    static func createAlertController(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel))
        return alert
    }
    
    // Calculate cell push animation delay
    private static var lastItemPushed: DispatchTime?
    
    static func calculateTimeDelayBeforeAnimation() -> Double {
        var thisTimeDelay: TimeInterval!
        if lastItemPushed == nil {
            thisTimeDelay = 0
            lastItemPushed = DispatchTime.now()
        } else if let lastItemPushed = lastItemPushed{
            let timeDiff = lastItemPushed.distance(to: .now())
            if(timeDiff.double() > MessageCellConstants.cellOpeningAnimationInterval) {
                thisTimeDelay = 0
            }else{
                thisTimeDelay = MessageCellConstants.cellOpeningAnimationInterval - timeDiff.double()
            }
            self.lastItemPushed = DispatchTime.now() + thisTimeDelay
        }
        //print("thisTimeDelay: \(thisTimeDelay)")
        return thisTimeDelay
    }
}
