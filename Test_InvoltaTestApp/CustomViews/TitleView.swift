//
//  TitleView.swift
//  Test_InvoltaTestApp
//
//  Created by test on 27.08.2022.
//

import Foundation
import UIKit

class TitleView: UIView {
    
    // use this to see safe area
    var safeAreaIndicator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.2330949306, green: 0.2231936157, blue: 0.2745918632, alpha: 1)
        //view.backgroundColor = .clear
        return view
    }()
    
    var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Тестовое задание"
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    var bottomSeparator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.231372549, green: 0.2235294118, blue: 0.2705882353, alpha: 1)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08
        layer.shadowOffset = CGSize(width: 2, height: 1)
        layer.shadowRadius = 10
        
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpConstraints(){
        addSubview(safeAreaIndicator)
        safeAreaIndicator.topAnchor.constraint(equalTo: topAnchor).isActive = true
        safeAreaIndicator.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        safeAreaIndicator.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        safeAreaIndicator.heightAnchor.constraint(equalToConstant: AppConstants.safeAreaPadding.top).isActive = true
        
        let textHeight = label.text!.height(width: AppConstants.screenWidth, font: label.font)
        let textTopPoint: CGFloat = (GeneralUIConstants.titleViewHeightAboveSafeArea - textHeight) / 2 + AppConstants.safeAreaPadding.top
        
        addSubview(label)
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor, constant: textTopPoint).isActive = true
        
        addSubview(bottomSeparator)
        bottomSeparator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomSeparator.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bottomSeparator.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        bottomSeparator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
}
