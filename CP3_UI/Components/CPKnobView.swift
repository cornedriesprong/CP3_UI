//
//  CPKnobView.swift
//  CP3_UI
//
//  Created by Corné on 11/06/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

import UIKit

public final class CPKnobView: UIView {
    
    // MARK: - Properties
    
    private lazy var stackView: UIStackView = {
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        
        return stackView
    }()
    
    private lazy var headerLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Font.fontMedium(ofSize: 14)
        label.textColor = color
        label.textAlignment = .center
        label.text = text
        
        return label
    }()
    
    private lazy var knob: CPRotaryKnob = {
        
        let knob = CPRotaryKnob()
        knob.tintColor = color
        knob.addTarget(self, action: #selector(knobValueChanged), for: .valueChanged)
        
        return knob
    }()
    
    private lazy var valueLabel: UILabel = {
        
        let label = UILabel()
        label.font = Font.font(ofSize: 13)
        label.textColor = color
        label.text = "0%"
        
        return label
    }()
    
    private let text: String
    private let color: UIColor
    
    // MARK: - Initialization
    
    public init(text: String, color: UIColor) {
        self.text = text
        self.color = color
        
        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    private func configure() {
        
        backgroundColor = color.withAlphaComponent(0.05)
        addSubview(stackView)
        let margin: CGFloat = 10
        let horizontalMargin: CGFloat = 12
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: margin).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: horizontalMargin).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -horizontalMargin).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7).isActive = true
        
        stackView.addArrangedSubview(headerLabel)
        stackView.addArrangedSubview(knob)
        stackView.setCustomSpacing(5, after: knob)
        stackView.addArrangedSubview(valueLabel)
    }
    
    // MARK: - Selectors
    
    @objc private func knobValueChanged(_ sender: CPRotaryKnob) {
        valueLabel.text = "\(Int(sender.value * 100))%"
    }
}
