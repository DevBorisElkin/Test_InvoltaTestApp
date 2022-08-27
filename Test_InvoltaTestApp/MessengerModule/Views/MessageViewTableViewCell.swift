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
        view.layer.cornerRadius = 17
        return view
    }()
    
    lazy var shadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        //view.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        view.layer.cornerRadius = 17
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 2, height: 1)
        view.layer.shadowRadius = 10
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
        //label.backgroundColor = .blue
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
        layer.removeAllAnimations() // ?
        messageAuthorIconImage.set(imageURL: nil)
    }
    
    func setUpConstraints(){
        // MARK: sliding view and cardView
        addSubview(slidingView)
        slidingView.addSubview(cardView)
        
        cardView.addSubview(shadowView)
        shadowView.fillSuperview()
        
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
        
        //print("animate: \(viewModel.animationData.needToAnimate)")
        
        if(!viewModel.animationData.needToAnimate){
            slidingView.frame = bounds
            cardView.frame = viewModel.sizes.cardViewFrame
            cardView.transform = .identity
        }else{
            slidingView.frame.size = frame.size
            slidingView.frame.origin.x = !viewModel.belongsToCurrentUser ? -slidingView.frame.size.width : slidingView.frame.size.width
            cardView.frame = viewModel.sizes.cardViewFrame
            cardView.transform = viewModel.animationData.cardViewInitialScale
            
            UIView.animate(withDuration: viewModel.animationData.animationTime, delay: viewModel.animationData.delayBeforeAnimation, options: viewModel.animationData.animationOptions ) { [weak self] in
                self?.slidingView.frame.origin.x = self?.bounds.minX ?? 0
                self?.cardView.transform = .identity
            }
        }
    }
}
