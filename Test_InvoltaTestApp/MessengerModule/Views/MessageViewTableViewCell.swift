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
    
    lazy var cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return view
    }()
    
    lazy var messageAuthorIconImage: WebImageView = {
        let imageView = WebImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        imageView.layer.cornerRadius = MessageCellConstants.messageAuthorIconSize / 2
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var messageAuthorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.backgroundColor = .brown
        label.font = MessageCellConstants.messageAuthorFont
        label.textColor = MessageCellConstants.messageAuthorFontColor
        return label
    }()
    
    lazy var messageTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.backgroundColor = .blue
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
        //videoThumbnailImageView.set(imageURL: nil)
        //channelIconImage.set(imageURL: nil)
    }
    
    func setUpConstraints(){
        // MARK: cardView
        addSubview(cardView)
        cardView.fillSuperview(padding: MessageCellConstants.cardViewOffset)
        
        // MARK: subviews of card view
        cardView.addSubview(messageAuthorIconImage)
        cardView.addSubview(messageAuthorLabel)
        cardView.addSubview(messageTextLabel)
    }
    
    func setUp(someText: String){
        messageAuthorIconImage.frame = CGRect(x: 5, y: 5, width: 50, height: 50)
        messageAuthorLabel.frame = CGRect(x: 60, y: 5, width: 200, height: 50)
        messageAuthorLabel.text = "Some Author"
        messageTextLabel.frame = CGRect(x: 60, y: 60, width: 200, height: 50)
        messageTextLabel.text = someText
        
        
        
    }
}
