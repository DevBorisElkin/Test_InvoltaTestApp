//
//  LoadingView.swift
//  Test_InvoltaTestApp
//
//  Created by test on 26.08.2022.
//

import Foundation
import UIKit

class LoadingView: UIView {
    
    private weak var spinner: UIActivityIndicatorView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return false
    }
    
    func startLoading(){
        if self.spinner == nil {
            let spinner = UIActivityIndicatorView()
            spinner.translatesAutoresizingMaskIntoConstraints = false
            addSubview(spinner)
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            spinner.startAnimating()
            self.spinner = spinner
        }
    }
    
    func endLoading(){
        spinner?.stopAnimating()
        spinner?.removeFromSuperview()
    }
}
