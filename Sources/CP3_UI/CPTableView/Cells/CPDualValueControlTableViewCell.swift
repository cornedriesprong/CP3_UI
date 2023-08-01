//
//  CPDualValueControlTableViewCell.swift
//  CP3_UI
//
//  Created by Corné on 24/04/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

import UIKit

public final class CPDualValueControlTableViewCell: CPTableViewCell {
    
    // MARK: - Properties
    
    private var stackView: UIStackView = {
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 30
        
        return stackView
    }()
    
    public var value1Label: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Font.font()
        label.textColor = .white
        
        return label
    }()
    
    public var value2Label: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Font.font()
        label.textColor = .white
        
        return label
    }()
    
    public var valueControl1: CPValueControl = {
        
        let valueControl = CPValueControl()
        valueControl.translatesAutoresizingMaskIntoConstraints = false
        
        return valueControl
    }()
    
    public var valueControl2: CPValueControl = {
        
        let valueControl = CPValueControl()
        valueControl.translatesAutoresizingMaskIntoConstraints = false
        
        return valueControl
    }()

    // MARK: - Configure

    override public func configure() {
        super.configure()
        
        addSubview(stackView)
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        stackView.addArrangedSubview(value1Label)
        stackView.addArrangedSubview(valueControl1)
        stackView.addArrangedSubview(value2Label)
        stackView.addArrangedSubview(valueControl2)
        stackView.setCustomSpacing(-5, after: value1Label)
        stackView.setCustomSpacing(-5, after: value2Label)
    }
    
    public func configure(
        value1String: String,
        value1: Int,
        value2String: String,
        value2: Int,
        callback: @escaping ((x: Int, y: Int)) -> Void) {
        
        value1Label.text = value1String
        valueControl1.value = value1
        value2Label.text = value2String
        valueControl2.value = value2
        valueControl1.actionCallback = { [unowned self] in
            callback((x: $0, y: self.valueControl2.value))
        }
        valueControl2.actionCallback = {
            callback((x: self.valueControl1.value, y: $0))
        }
    }
}
