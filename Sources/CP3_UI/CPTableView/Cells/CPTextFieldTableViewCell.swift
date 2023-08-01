//
//  CPTextFieldTableViewCell.swift
//  CP3_UI
//
//  Created by Corné on 17/04/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

import UIKit

public final class CPTextFieldTableViewCell: CPTableViewCell {
    
    // MARK: - Private properties
    
    private lazy var textField: UITextField = {
        
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        
        textField.font = Font.font()
        textField.textColor = .white
        textField.tintColor = .white
        textField.keyboardAppearance = .dark
        textField.inputAccessoryView = toolBar
        
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var toolBar: UIToolbar = {
        
        var toolBar = UIToolbar()
        toolBar.barStyle = .blackTranslucent
        toolBar.backgroundColor = .clear
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneButtonTapped))
        
        doneButton.setTitleTextAttributes(
            [NSAttributedString.Key.font: Font.font(),
             NSAttributedString.Key.foregroundColor: UIColor.white],
            for: .normal)
        
        doneButton.setTitleTextAttributes(
            [NSAttributedString.Key.font: Font.font(),
             NSAttributedString.Key.foregroundColor: UIColor.white],
            for: .highlighted)
        
        toolBar.items = [doneButton]
        
        return toolBar
    }()
    
    private var callback: ((String) -> Void)?
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    public func configure(withText text: String, callback: @escaping ((String) -> Void)) {
        
        textField.text = text
        self.callback = callback
    }
    
    override public func configure() {
        super.configure()
        
        addSubview(textField)
        textField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        textField.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 17).isActive = true
        textField.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        textField.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        addEditImageToTextField()
    }
    
    // MARK: - Selectors
    
    @objc private func clearTextField(_ sender: UITextField) {
        textField.text = ""
    }
    
    @objc private func doneButtonTapped(_ sender: UIButton) {
        textField.resignFirstResponder()
    }
    
    // MARK: - Helpers
    
    func addEditImageToTextField() {
        
        let image = UIImage(systemName: "pencil")
        textField.rightView = UIImageView(image: image)
        textField.rightViewMode = .unlessEditing
    }
}

extension CPTextFieldTableViewCell: UITextFieldDelegate {
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let button = UIButton(type: .custom)
        let image = UIImage(named: "delete_tiny")
        button.setImage(image, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.addTarget(
            self,
            action: #selector(clearTextField),
            for: .touchUpInside)
        textField.rightView = button
        textField.rightViewMode = .whileEditing
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        
        addEditImageToTextField()
        
        if let text = textField.text {
            callback?(text)
        }
    }
}
