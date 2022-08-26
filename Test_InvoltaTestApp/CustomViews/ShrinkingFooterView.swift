//
//  ShrinkingFooterView.swift
//  Test_InvoltaTestApp
//
//  Created by test on 26.08.2022.
//

import Foundation
import UIKit

class ShrinkingFooterView: UIView {
    
    var spinner: UIActivityIndicatorView!
    var completion: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp(completion: @escaping () -> Void) {
        //widthAnchor.constraint(equalToConstant: 100).isActive = true
        //heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        self.completion = completion
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        spinner.startAnimating()
        self.spinner = spinner
        backgroundColor = .blue
    }
    
    func shrink(){
        print("Started shrinking")
        UIView.animate(withDuration: 1.0) { [weak self] in
            self?.spinner.color = .clear
        } completion: { [weak self] isCompleted in
            if isCompleted {
                self?.spinner.removeFromSuperview()
                self?.spinner = nil
            }
        }
        
        UIView.animate(withDuration: 2.0) { [weak self] in
            self?.frame.size = CGSize.zero
        } completion: { [weak self] isCompleted in
            if isCompleted {
                print("ended shrinking")
                self?.completion?()
            }
        }
    }
}
