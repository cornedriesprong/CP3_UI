//
//  CPContainerView.swift
//  CP3_UI
//
//  Created by Corné on 11/06/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

import UIKit

final class CPContainerView: UIView {
    
    struct Configuration {
        let axis: NSLayoutConstraint.Axis
        let borderColor: UIColor
        let items: [Item]
        
        init(axis: NSLayoutConstraint.Axis = .horizontal, borderColor: UIColor, items: [Item]) {
            self.axis = axis
            self.borderColor = borderColor
            self.items = items
        }
    }
    
    enum Item {
        case knob(text: String, color: UIColor)
        case rangeSlider(text: String, color: UIColor)
    }
    
    // MARK: - Properties
    
    private lazy var stackView: UIStackView = {
        
        let stackView = UIStackView()
        stackView.axis = configuration.axis
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 1.5
        stackView.backgroundColor = Color.darkestGray
        
        return stackView
    }()
    
    private var configuration: Configuration
    
    // MARK: - Initialization
    
    init(configuration: Configuration) {
        self.configuration = configuration
        
        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        tintColor = Color.cyan
        
        layer.cornerRadius = 10
        layer.borderWidth = 1.5
        layer.borderColor = configuration.borderColor.withAlphaComponent(0.5).cgColor
        layer.masksToBounds = true
        
        addSubview(stackView)
        let margin: CGFloat = 0
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: margin).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: margin).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -margin).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin).isActive = true
        
        for item in configuration.items {
            switch item {
            case .knob(let text, let color):
                let knobView = CPKnobView(text: text, color: color)
                stackView.addArrangedSubview(knobView)
                
            case .rangeSlider(let text, let color):
                let slider = CPRangeSliderView(text: text, color: color)
                stackView.addArrangedSubview(slider)
            }
        }
    }
}
