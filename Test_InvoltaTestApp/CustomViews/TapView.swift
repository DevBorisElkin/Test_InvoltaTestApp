//
//  TapView.swift
//  Test_InvoltaTestApp
//
//  Created by test on 28.08.2022.
//

import Foundation
import UIKit

class TapView: UIView {
    
    private var onClick: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //translatesAutoresizingMaskIntoConstraints = false
        //backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 0.6360595905)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func viewTapped(){
        onClick?()
    }
    
    func setOnClickAction(onClick: @escaping () -> Void) {
        self.onClick = onClick
    }
}
