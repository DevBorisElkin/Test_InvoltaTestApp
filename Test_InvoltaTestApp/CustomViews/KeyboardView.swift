//
//  KeyboardView.swift
//  Test_InvoltaTestApp
//
//  Created by test on 27.08.2022.
//

import Foundation
import UIKit

// MARK: SearchTitleView
class KeyboardView: UIView {
    
    
    var lastSearchText: String = ""
    var searchTextField = InsertableTextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //translatesAutoresizingMaskIntoConstraints = false
        //backgroundColor = .red
        backgroundColor = .white
        makeConstraints()
        makeOtherSettings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init() - coder has not been implemented")
    }
    
    private func makeConstraints(){
        
        addSubview(searchTextField)
        searchTextField.topAnchor.constraint(equalTo: topAnchor, constant: GeneralUIConstants.keyboardInsets.top).isActive = true
        searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: GeneralUIConstants.keyboardInsets.left).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -GeneralUIConstants.keyboardInsets.right).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: GeneralUIConstants.keyboardHeightAboveSafeArea).isActive = true
    }
    
    func makeOtherSettings(){
//        searchTextField.textChangedDelegate = self
//        searchTextField.delegate = self
    }
}
// MARK: InsertableTextField
class InsertableTextField: UITextField, UITextFieldDelegate{

    weak var textChangedDelegate: InsertableTextFieldDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = #colorLiteral(red: 0.9360918617, green: 0.9360918617, blue: 0.9360918617, alpha: 1)
        placeholder = "Type in message"
        font = UIFont.systemFont(ofSize: 14, weight: .medium)
        textColor = .black
        clearButtonMode = .whileEditing
        borderStyle = .none
        layer.cornerRadius = 10
        layer.masksToBounds = true

        leftViewMode = .always
        
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        leftView = leftPadding
        
        setUpOnTextEdited()
    }

    func setUpOnTextEdited(){
        addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.delegate = self
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        textChangedDelegate?.onTextChanged(text: text, isNotEmpty: !text.isEmpty)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        guard let text = textField.text, !text.isEmpty else {
            return true
        }
        print("TF resigned and passed text: \(text)")
        textChangedDelegate?.onReturnButtonPressed(for: text)
        textField.text = ""
        return true
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error with coder")
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 36, dy: 0)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 36, dy: 0)
    }

    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += 12
        return rect
    }
}

protocol InsertableTextFieldDelegate: AnyObject {
    func onTextChanged(text: String, isNotEmpty: Bool)
    func onReturnButtonPressed(for text: String)
}
