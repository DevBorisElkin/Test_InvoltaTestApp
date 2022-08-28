//
//  MessageDetailsView.swift
//  Test_InvoltaTestApp
//
//  Created by test on 28.08.2022.
//

import Foundation
import UIKit

class MessageDetailsView: UIView {
    
    weak var presenter: MessengerViewToPresenterProtocol?
    private var viewModel: MessageDetailsViewModel!
    
    // MARK: ColorSettings
    private let backgroundFadeColor = #colorLiteral(red: 0.02357130427, green: 0.07965320206, blue: 0.1247922936, alpha: 1)
    private let initialFade = 0.0
    private let targetFade = 0.7
    
    // MARK: Sizes
    private static let aspectRatio = AppConstants.screenWidth / AppConstants.screenHeight
    private let spaceToOccupy = CGSize(width: max(MessageDetailsView.aspectRatio * 1.3, 0.7), height: MessageDetailsView.aspectRatio)
    var totalSpaceToOccupy: CGSize { CGSize(width: AppConstants.screenWidth * spaceToOccupy.width, height: AppConstants.screenHeight * spaceToOccupy.height) }
    var insents: CGPoint { CGPoint(x: (AppConstants.screenWidth - totalSpaceToOccupy.width) / 2, y: (AppConstants.screenHeight - totalSpaceToOccupy.height) / 2) }
    
    lazy var cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        
        // ?
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 2, height: 1)
        view.layer.shadowRadius = 10
        return view
    }()
    
    lazy var messageAuthorIconImage: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.checkForAbsoluteUrl = false
        imageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        imageView.layer.cornerRadius = (MessageDetailsConstants.messageAuthorIconSize.width / 2)
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var messageAuthorLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = MessageDetailsConstants.messageAuthorFont
        label.textColor = MessageDetailsConstants.messageAuthorFontColor
        label.textAlignment = .center
        label.layer.cornerRadius = (label.height() + label.intrinsicContentSize.height) / 2
        label.layer.masksToBounds = true
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.backgroundColor = .blue
        
        return label
    }()
    
    lazy var messageDateLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = MessageDetailsConstants.messageDateFont
        label.textColor = MessageDetailsConstants.messageDateFontColor
        label.textAlignment = .center
        label.layer.cornerRadius = (label.height() + label.intrinsicContentSize.height) / 2
        label.layer.masksToBounds = true
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.backgroundColor = .blue
        
        return label
    }()
    
    lazy var messageTextLabel: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.numberOfLines = 0
        label.backgroundColor = .clear
        label.backgroundColor = .blue
        label.font = MessageDetailsConstants.messageTextFont
        label.textColor = MessageDetailsConstants.messageTextFontColor
        return label
    }()
    
    lazy var bottomButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 0
        stackView.backgroundColor = .lightGray
        return stackView
    }()
    
    lazy var topRightcloseMessageDetailsButton: ExpandedButton = {
        var button = ExpandedButton()
        button.clickIncreasedArea = AppConstants.expandCustomButtonsClickArea
        button.translatesAutoresizingMaskIntoConstraints = false
        var buttonImage = UIImage(named: "close")?.withRenderingMode(.alwaysTemplate)
        button.setImage(buttonImage, for: .normal)
        button.imageView?.tintColor = .cyan
        button.backgroundColor = .clear
        return button
    }()
    
    lazy var closeMessageDetailsButton: ExpandedButton = {
        var button = ExpandedButton()
        button.clickIncreasedArea = AppConstants.expandCustomButtonsClickArea
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Назад", for: .normal)
        let buttonTextColor = #colorLiteral(red: 0.2392156869, green: 0.5184240254, blue: 0.9686274529, alpha: 1)
        button.setTitleColor(buttonTextColor, for: .normal)
        button.backgroundColor = .clear
        //button.backgroundColor = .blue
        return button
    }()
    
    lazy var deleteMessageDetailsButton: ExpandedButton = {
        var button = ExpandedButton()
        button.clickIncreasedArea = AppConstants.expandCustomButtonsClickArea
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Удалить", for: .normal)
        let buttonTextColor = #colorLiteral(red: 0.7443636798, green: 0.1364066129, blue: 0.2615735445, alpha: 1)
        button.setTitleColor(buttonTextColor, for: .normal)
        button.backgroundColor = .clear
        //button.backgroundColor = .green
        return button
    }()
    
    func setUp(viewModel: MessageDetailsViewModel) {
        self.viewModel = viewModel
        self.frame = CGRect(origin: .zero, size: CGSize(width: AppConstants.screenWidth, height: AppConstants.screenHeight))
        backgroundColor = backgroundFadeColor.withAlphaComponent(initialFade)
        
        addSubview(cardView)
        
        cardView.alpha = 0
        cardView.frame = CGRect(origin: insents, size: totalSpaceToOccupy)
        
        cardView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:))))
        
        cardViewInitialPos = cardView.frame.origin.x
        self.lastIterationFrame = cardView.frame
        
        setInnerUI(viewModel: viewModel)
        
        // Animate opening
        
        UIView.animate(withDuration: 1) { [weak self, backgroundFadeColor, targetFade] in
            self?.backgroundColor = backgroundFadeColor.withAlphaComponent(targetFade)
            self?.cardView.alpha = 1
        }
    }
    
    private func setInnerUI(viewModel: MessageDetailsViewModel) {
        viewModel.printValues()
        
        // MARK: MessageAuthorIcon
        cardView.addSubview(messageAuthorIconImage)
        messageAuthorIconImage.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
        messageAuthorIconImage.topAnchor.constraint(equalTo: cardView.topAnchor, constant: MessageDetailsConstants.messageAuthorIconOffsetFromCardView).isActive = true
        messageAuthorIconImage.widthAnchor.constraint(equalToConstant: MessageDetailsConstants.messageAuthorIconSize.width).isActive = true
        messageAuthorIconImage.heightAnchor.constraint(equalToConstant: MessageDetailsConstants.messageAuthorIconSize.height).isActive = true
        
        messageAuthorIconImage.set(imageURL: viewModel.authorRandomImageUrl)
        
        // MARK: MessageAuthorName
        cardView.addSubview(messageAuthorLabel)
        messageAuthorLabel.anchor(top: messageAuthorIconImage.bottomAnchor, leading: cardView.leadingAnchor, bottom: nil, trailing: cardView.trailingAnchor, padding: MessageDetailsConstants.messageAuthorInsets)
        messageAuthorLabel.heightAnchor.constraint(equalToConstant: messageAuthorLabel.height() + messageAuthorLabel.intrinsicContentSize.height).isActive = true
        messageAuthorLabel.text = viewModel.authorName
        
        // MARK: MessageDate label
        cardView.addSubview(messageDateLabel)
        messageDateLabel.anchor(top: messageAuthorLabel.bottomAnchor, leading: cardView.leadingAnchor, bottom: nil, trailing: cardView.trailingAnchor, padding: MessageDetailsConstants.messageDateInsets)
        messageDateLabel.heightAnchor.constraint(equalToConstant: messageDateLabel.height() + messageDateLabel.intrinsicContentSize.height).isActive = true
        messageDateLabel.text = "Sept 16, 15:37"
        
        // MARK: Close Message Details Top-right button
        cardView.addSubview(topRightcloseMessageDetailsButton)
        topRightcloseMessageDetailsButton.anchor(top: cardView.topAnchor, leading: nil, bottom: nil, trailing: cardView.trailingAnchor, padding: MessageDetailsConstants.topRightCloseMessageDetailsButtonInsets, size: MessageDetailsConstants.topRightCloseMessageDetailsButtonSize)
        
        // MARK: Stack view with buttons
        cardView.addSubview(bottomButtonsStackView)
        bottomButtonsStackView.anchor(top: nil, leading: cardView.leadingAnchor, bottom: cardView.bottomAnchor, trailing: cardView.trailingAnchor, padding: MessageDetailsConstants.buttonsStackViewInsets)
        bottomButtonsStackView.heightAnchor.constraint(equalToConstant: MessageDetailsConstants.buttonsStackViewHeight).isActive = true
        
        bottomButtonsStackView.addArrangedSubview(deleteMessageDetailsButton)
        bottomButtonsStackView.addArrangedSubview(closeMessageDetailsButton)
        
//        // MARK: Close Message Details button
//        cardView.addSubview(closeMessageDetailsButton)
//        closeMessageDetailsButton.anchor(top: nil, leading: nil, bottom: cardView.bottomAnchor, trailing: cardView.trailingAnchor, padding: MessageDetailsConstants.closeMessageDetailsButtonInsets)
//        closeMessageDetailsButton.heightAnchor.constraint(equalToConstant: MessageDetailsConstants.closeMessageDetailsButtonSize.height).isActive = true
//
//        // MARK: Delete Message Details button
//        cardView.addSubview(deleteMessageDetailsButton)
//        deleteMessageDetailsButton.centerYAnchor.constraint(equalTo: closeMessageDetailsButton.centerYAnchor).isActive = true
//        deleteMessageDetailsButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: MessageDetailsConstants.deleteMessageDetailsButtonInsets.left).isActive = true
//        deleteMessageDetailsButton.heightAnchor.constraint(equalToConstant: MessageDetailsConstants.deleteMessageDetailsButtonSize.height).isActive = true
        
        // MARK: Message Text label
        cardView.addSubview(messageTextLabel)
        //messageAuthorLabel.setContentCompressionResistancePriority(.defaultHigh , for: .vertical)
        messageTextLabel.anchor(top: messageDateLabel.bottomAnchor, leading: cardView.leadingAnchor, bottom: closeMessageDetailsButton.topAnchor, trailing: cardView.trailingAnchor, padding: MessageDetailsConstants.messageTextInsets)
        messageTextLabel.text = viewModel.message
        
        // MARK: Assign button actions
        topRightcloseMessageDetailsButton.addTarget(self, action: #selector(closeButtonPessed), for: .touchUpInside)
        closeMessageDetailsButton.addTarget(self, action: #selector(closeButtonPessed), for: .touchUpInside)
        deleteMessageDetailsButton.addTarget(self, action: #selector(deleteButtonPessed), for: .touchUpInside)
    }
    
    // MARK: Button actions
    @objc private func closeButtonPessed() {
        executeClosingAnimation()
    }
    
    @objc private func deleteButtonPessed() {
        presenter?.requestedToDeleteMessage(messageid: viewModel.messageId, belongsToCurrentUser: viewModel.belongsToCurrentUser)
        executeClosingAnimation()
    }
    
    
    // MARK: Panning related
    private var cardViewInitialPos: CGFloat!
    private var lastIterationFrame: CGRect!
    private let percentThresholdToClose = 0.2
    
    @objc private func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        
        // ?
        let translation = panGesture.translation(in: cardView)
        let horizontalMovement = translation.x / cardView.bounds.width
        let rightwardsMovement = fmaxf(Float(horizontalMovement), 0.0)
        let progress = CGFloat(fminf(rightwardsMovement, 1.0))

        
        let newXPos = max(cardViewInitialPos, translation.x + lastIterationFrame.origin.x)
        
        if panGesture.state == .changed {
            self.backgroundColor = backgroundFadeColor.withAlphaComponent((1 - progress) * targetFade)
            cardView.frame.origin = CGPoint(
                x: newXPos,
                y: cardView.frame.origin.y
            )
        } else if panGesture.state == .ended {
            self.lastIterationFrame = cardView.frame
            if(progress > percentThresholdToClose){
                executeClosingAnimation()
            }else{
                executeCancelAnimation()
            }
        }
    }
    
    private func executeClosingAnimation(){
        UIView.animate(withDuration: 0.5) { [weak self, backgroundFadeColor] in
            self?.cardView.frame.origin.x = AppConstants.screenWidth
            self?.backgroundColor = backgroundFadeColor.withAlphaComponent(0)
        } completion: { [weak self] isCompleted in
            self?.removeFromSuperview()
        }
    }
    
    private func executeCancelAnimation(){
        UIView.animate(withDuration: 0.5) { [weak self, cardViewInitialPos, backgroundFadeColor, targetFade] in
            self?.cardView.frame.origin.x = cardViewInitialPos ?? 0
            self?.backgroundColor = backgroundFadeColor.withAlphaComponent(targetFade)
        } completion: { [weak self] isCompleted in
            self?.lastIterationFrame = self?.cardView.frame
        }
    }
}
