//
//  MessageViewTableViewCell.swift
//  Test_InvoltaTestApp
//
//  Created by test on 26.08.2022.
//

import Foundation
import UIKit

class MessageViewTableViewCell: UITableViewCell {
    static let reuseId = "MessageViewTableViewCell"
    
    lazy var containerView: UIView = {
        let view = UIView()
        //view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var cardView: UIView = {
        let view = UIView()
        //view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return view
    }()
    
    lazy var messageAuthorIconImage: WebImageView = {
        let imageView = WebImageView()
        imageView.checkForAbsoluteUrl = false
        imageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        imageView.layer.cornerRadius = MessageCellConstants.messageAuthorIconSize.width / 2
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var messageAuthorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.backgroundColor = .clear
        //label.backgroundColor = .brown
        label.font = MessageCellConstants.messageAuthorFont
        label.textColor = MessageCellConstants.messageAuthorFontColor
        return label
    }()
    
    lazy var messageTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.backgroundColor = .clear
        //label.backgroundColor = .blue
        label.font = MessageCellConstants.messageTextFont
        label.textColor = MessageCellConstants.messageTextFontColor
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        messageAuthorIconImage.set(imageURL: nil)
    }
    
    func setUpConstraints(){
        // MARK: cardView
        addSubview(containerView)
        containerView.addSubview(cardView)
        //cardView.fillSuperview(padding: MessageCellConstants.cardViewOffset)
        
        // MARK: subviews of card view
        cardView.addSubview(messageAuthorIconImage)
        cardView.addSubview(messageAuthorLabel)
        cardView.addSubview(messageTextLabel)
    }
    
    func setUp(viewModel: MessageItemViewModel){
        containerView.frame = frame
        
        //messageAuthorIconImage.frame = CGRect(x: -15, y: 5, width: 50, height: 50)
        messageAuthorIconImage.frame = viewModel.sizes.authorImageFrame
        messageAuthorIconImage.set(imageURL: viewModel.authorRandomImageUrl)
        //messageAuthorLabel.frame = CGRect(x: 60, y: 5, width: 200, height: 50)
        messageAuthorLabel.frame = viewModel.sizes.authorNameFame
        messageAuthorLabel.text = viewModel.authorRandomName
        //messageTextLabel.frame = CGRect(x: 60, y: 60, width: 200, height: 50)
        messageTextLabel.frame = viewModel.sizes.messageTextFrame
        messageTextLabel.text = viewModel.message
        
        if(viewModel.animationData.needToAnimate){
            cardView.frame.size = viewModel.sizes.cardViewFrame.size
            cardView.frame.origin = viewModel.sizes.cardViewInitialPoint
            let scale = MessageCellConstants.cellInitialScale
            let targetScale =  MessageCellConstants.cellTargetScale
            cardView.transform = CGAffineTransform(scaleX: scale, y: scale)
            
            UIView.animate(withDuration: viewModel.animationData.animationTime, delay: viewModel.animationData.delayBeforeAnimation ) { [weak self] in
                self?.cardView.frame.origin = viewModel.sizes.cardViewFrame.origin
                //self?.cardView.transform = CGAffineTransform(scaleX: targetScale, y: targetScale)
                self?.cardView.transform = .identity
            }
            
        }else{
            cardView.frame = viewModel.sizes.cardViewFrame
        }
        
        
        
//        UIView.animate(withDuration: 2) { [weak self] in
//            //self?.frame.origin = viewModel.sizes.cardViewFrame.origin // cool actually
//            self?.cardView.frame.origin = viewModel.sizes.cardViewFrame.origin
//        }
//        cardView.frame.origin = CGPoint(x: cardView.frame.origin.x - 20, y: cardView.frame.origin.y)
    }
}
