//
//  CPRangeSliderView.swift
//  CP3_UI
//
//  Created by Corné on 11/06/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

import UIKit

public final class CPRangeSliderView: UIView {
    
    // MARK: - Properties
    
    private static let labelWidth: CGFloat = 32
    
    private lazy var verticalStackView: UIStackView = {
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .leading
        
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
    
    private lazy var headerView: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorTheme.darkGray
        
        let labelHeight: CGFloat = 20
        view.layer.cornerRadius = labelHeight / 2
        view.layer.masksToBounds = true
        view.addSubview(headerLabel)
        
        let sideMargin: CGFloat = 12
        headerLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: sideMargin).isActive = true
        headerLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -sideMargin).isActive = true
        headerLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        view.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        
        return view
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        
        return stackView
    }()
    
    private lazy var lowerValueLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Font.font(ofSize: 13)
        label.textAlignment = .center
        label.textColor = color
        label.text = "0"
        horizontalStackView.addArrangedSubview(label)
        label.widthAnchor.constraint(equalToConstant: CPRangeSliderView.labelWidth).isActive = true
        
        return label
    }()
    
    private lazy var slider: CPRangeSlider = {
        
        let slider = CPRangeSlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.tintColor = color
        slider.minimumValue = Float(range.lowerBound)
        slider.maximumValue = Float(range.upperBound)
        slider.lowerValue = Float(range.lowerBound)
        slider.upperValue = Float(range.upperBound)
        slider.heightAnchor.constraint(equalToConstant: CPThumbLayer.size.height).isActive = true
        slider.addTarget(self, action: #selector(rangeSliderValueChanged), for: .valueChanged)
        horizontalStackView.addArrangedSubview(slider)
        
        return slider
    }()
    
    private lazy var upperValueLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Font.font(ofSize: 13)
        label.textAlignment = .center
        label.textColor = color
        label.text = "100"
        horizontalStackView.addArrangedSubview(label)
        label.widthAnchor.constraint(equalToConstant: CPRangeSliderView.labelWidth).isActive = true
        
        return label
    }()
    
    private let text: String
    private let range: Range<Int>
    private let color: UIColor
    private let unitConversionClosure: ((Int) -> String)?
    private let callback: (_ range: Range<Int>) -> Void
    
    // MARK: - Initialization
    
    public init(
        text: String,
        range: Range<Int>,
        color: UIColor,
        unitConversionClosure: ((Int) -> String)? = nil,
        callback: @escaping (_ range: Range<Int>) -> Void) {
        
        self.text = text
        self.range = range
        self.color = color
        self.unitConversionClosure = unitConversionClosure
        self.callback = callback
        
        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    private func configure() {
        
        backgroundColor = color.withAlphaComponent(0.05)
        addSubview(verticalStackView)
        let margin: CGFloat = 10
        let horizontalMargin: CGFloat = 12
        verticalStackView.topAnchor.constraint(equalTo: topAnchor, constant: margin).isActive = true
        verticalStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: horizontalMargin).isActive = true
        verticalStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -horizontalMargin).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7).isActive = true
        
        verticalStackView.addArrangedSubview(headerView)
        
        horizontalStackView.addArrangedSubview(lowerValueLabel)
        horizontalStackView.addArrangedSubview(slider)
        horizontalStackView.addArrangedSubview(upperValueLabel)
        verticalStackView.addArrangedSubview(horizontalStackView)
        horizontalStackView.widthAnchor.constraint(equalTo: verticalStackView.widthAnchor).isActive = true
    }
    
    // MARK: - Selectors
    
    @objc private func rangeSliderValueChanged(_ sender: CPRangeSlider) {
        
        let lowerBound = Int(sender.lowerValue)
        let upperBound = Int(sender.upperValue)
        
        guard lowerBound < upperBound else { return }
        
        lowerValueLabel.text = unitConversionClosure?(lowerBound) ?? "\(lowerBound)"
        upperValueLabel.text = unitConversionClosure?(upperBound) ?? "\(upperBound)"
        
        callback(lowerBound..<upperBound)
    }
}
