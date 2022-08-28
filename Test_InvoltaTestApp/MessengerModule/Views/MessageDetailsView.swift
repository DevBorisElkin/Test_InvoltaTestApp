//
//  MessageDetailsView.swift
//  Test_InvoltaTestApp
//
//  Created by test on 28.08.2022.
//

import Foundation
import UIKit

class MessageDetailsView: UIView {
    
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
    
    
    func setUp(viewModel: MessageDetailsViewModel) {
        self.frame = CGRect(origin: .zero, size: CGSize(width: AppConstants.screenWidth, height: AppConstants.screenHeight))
        backgroundColor = backgroundFadeColor.withAlphaComponent(initialFade)
        
        addSubview(cardView)
        
        cardView.alpha = 0
        cardView.frame = CGRect(origin: insents, size: totalSpaceToOccupy)
        
        cardView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:))))
        
        cardViewInitialPos = cardView.frame.origin.x
        self.lastIterationFrame = cardView.frame
        
        // Animate opening
        
        UIView.animate(withDuration: 1) { [weak self, backgroundFadeColor, targetFade] in
            self?.backgroundColor = backgroundFadeColor.withAlphaComponent(targetFade)
            self?.cardView.alpha = 1
        }
    }
    
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
