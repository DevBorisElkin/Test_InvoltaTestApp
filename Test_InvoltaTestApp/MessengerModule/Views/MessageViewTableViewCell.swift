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
    
    lazy var slidingView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var cardView: UIView = {
        let view = UIView()
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
        label.font = MessageCellConstants.messageAuthorFont
        label.textColor = MessageCellConstants.messageAuthorFontColor
        return label
    }()
    
    lazy var messageTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.backgroundColor = .clear
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
        // MARK: sliding view and cardView
        addSubview(slidingView)
        slidingView.addSubview(cardView)
        
        // MARK: subviews of card view
        cardView.addSubview(messageAuthorIconImage)
        cardView.addSubview(messageAuthorLabel)
        cardView.addSubview(messageTextLabel)
    }
    
    func setUp(viewModel: MessageItemViewModel){
        messageAuthorIconImage.frame = viewModel.sizes.authorImageFrame
        messageAuthorLabel.frame = viewModel.sizes.authorNameFame
        messageTextLabel.frame = viewModel.sizes.messageTextFrame
        
        messageAuthorIconImage.set(imageURL: viewModel.authorRandomImageUrl)
        messageAuthorLabel.text = viewModel.authorRandomName
        messageTextLabel.text = viewModel.message
        
        if(!viewModel.animationData.needToAnimate){
            slidingView.frame = bounds
            cardView.frame = viewModel.sizes.cardViewFrame
            cardView.transform = .identity
        }else{
            slidingView.frame.size = frame.size
            slidingView.frame.origin.x = -slidingView.frame.size.width
            cardView.frame = viewModel.sizes.cardViewFrame
            cardView.transform = viewModel.animationData.cardViewInitialScale
            
            UIView.animate(withDuration: viewModel.animationData.animationTime, delay: viewModel.animationData.delayBeforeAnimation, options: viewModel.animationData.animationOptions ) { [weak self] in
                self?.slidingView.frame.origin.x = self?.bounds.minX ?? 0
                self?.cardView.transform = .identity
            }
        }
    }
}
