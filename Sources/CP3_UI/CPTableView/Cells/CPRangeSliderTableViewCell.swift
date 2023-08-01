//
//  CPRangeSliderTableViewCell.swift
//  CP3_UI
//
//  Created by Corné on 23/04/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

import UIKit

public typealias ValueRange<T: Numeric> = (lowerValue: T, upperValue: T)

public final class CPRangeSliderTableViewCell: CPTableViewCell {
    
    public struct ViewModel {
        let title: String
        let range: (minimum: Double, maximum: Double)
        var tintColor: UIColor
        let valueRange: ValueRange<Int>
        let unitString: String
        
        public init(
            title: String,
            range: (minimum: Double, maximum: Double),
            valueRange: ValueRange<Int>,
            unitString: String = "",
            tintColor: UIColor = ColorTheme.red.uiColor) {
            
            self.title = title
            self.range = range
            self.valueRange = valueRange
            self.unitString = unitString
            self.tintColor = tintColor
        }
    }
    
    // MARK: - Static properties
    
    public static let height: CGFloat = 74
    
    // MARK: - Private properties
    
    private lazy var stackView: UIStackView = {
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private lazy var rangeSlider: CPRangeSlider = {
        
        let slider = CPRangeSlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.tintColor = ColorTheme.red.uiColor
        slider.heightAnchor.constraint(equalToConstant: CPThumbLayer.size.height).isActive = true
        
        slider.addTarget(
            self,
            action: #selector(sliderValueChanged),
            for: .valueChanged)
        
        return slider
    }()
    
    private lazy var titleLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .white
        label.font = Font.font()
        
        return label
    }()
    
    private lazy var lowerValueLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        label.font = Font.font()
        label.textColor = UIColor.white
        label.textAlignment = .left
        
        label.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        return label
    }()
    
    private lazy var upperValueLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        label.font = Font.font()
        label.textColor = UIColor.white
        label.textAlignment = .right
        
        label.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        return label
    }()
    
    private var callback: ((ValueRange<Int>) -> Void)?
    private var viewModel: ViewModel?
    public var unitString: String?
    
    // MARK: - Configuration
    
    public func configure(
        viewModel: ViewModel,
        callback: @escaping (ValueRange<Int>) -> Void) {
        
        self.viewModel = viewModel
        
        titleLabel.text = viewModel.title
        
        rangeSlider.minimumValue = Float(viewModel.range.minimum)
        rangeSlider.maximumValue = Float(viewModel.range.maximum)
        rangeSlider.lowerValue = Float(viewModel.valueRange.lowerValue)
        rangeSlider.upperValue = Float(viewModel.valueRange.upperValue)
        
        rangeSlider.tintColor = viewModel.tintColor
        self.unitString = viewModel.unitString
        self.callback = callback
        
        lowerValueLabel.text = valueString(for: Float(viewModel.valueRange.lowerValue))
        upperValueLabel.text = valueString(for: Float(viewModel.valueRange.upperValue))
    }
    
    override public func configure() {
        super.configure()
        
        contentView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        
        stackView.addArrangedSubview(topRowView())
        stackView.addArrangedSubview(bottomRowView())
        
    }
    
    // MARK: - Selectors
    
    @objc private func decreaseButtonTapped(_ sender: UIButton) {
        rangeSlider.upperValue -= 1
        sliderValueChanged(rangeSlider)
    }
    
    @objc private func increaseButtonTapped(_ sender: UIButton) {
        rangeSlider.lowerValue += 1
        sliderValueChanged(rangeSlider)
    }
    
    @objc private func sliderValueChanged(_ sender: CPRangeSlider) {
        
        lowerValueLabel.text = valueString(for: rangeSlider.lowerValue)
        upperValueLabel.text = valueString(for: rangeSlider.upperValue)
        callback?((lowerValue: Int(rangeSlider.lowerValue), upperValue: Int(rangeSlider.upperValue)))
    }
    
    // MARK: - Helpers
    
    private func topRowView() -> UIView {
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(titleLabel)
        
        return stackView
    }
    
    private func bottomRowView() -> UIView {
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.addArrangedSubview(lowerValueLabel)
        stackView.addArrangedSubview(rangeSlider)
        stackView.addArrangedSubview(upperValueLabel)
        
        return stackView
    }
    
    private func valueString(for value: Float) -> String? {
        return "\(Int(round(value)))" + (unitString ?? "")
    }
}
