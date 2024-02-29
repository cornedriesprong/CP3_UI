//
//  CPSliderTableViewCell.swift
//  CP3_UI
//
//  Created by Corné on 17/04/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

#if canImport(UIKit)
import UIKit

public final class CPSliderTableViewCell: CPTableViewCell {
    
    public struct ViewModel {
        let title: String
        let range: (minimum: Double, maximum: Double)
        var tintColor: UIColor
        let value: Double
        let unitString: String
        
        public init(
            title: String,
            range: (minimum: Double, maximum: Double),
            value: Double,
            unitString: String = "",
            tintColor: UIColor = ColorTheme.red.uiColor) {
            
            self.title = title
            self.range = range
            self.value = value
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
        stackView.spacing = 0
        
        return stackView
    }()
    
    private lazy var slider: UISlider = {
        
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.tintColor = ColorTheme.red.uiColor
        
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
    
    private lazy var valueLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        label.font = Font.font()
        label.textAlignment = .right
        
        return label
    }()
    
    private var callback: ((Double) -> Void)?
    
    public var unitString: String?
    
    // MARK: - Configuration
    
    public func configure(
        viewModel: ViewModel,
        callback: @escaping (Double) -> Void) {
        
        titleLabel.text = viewModel.title
        
        slider.minimumValue = Float(viewModel.range.minimum)
        slider.maximumValue = Float(viewModel.range.maximum)
        slider.value = Float(viewModel.value)
        
        slider.tintColor = viewModel.tintColor
        self.unitString = viewModel.unitString
        self.callback = callback
        
        valueLabel.text = valueString()
    }
    
    override public func configure() {
        super.configure()
        
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        
        let topRowStackView = self.topRowStackView()
        stackView.addArrangedSubview(topRowStackView)
        stackView.addArrangedSubview(bottomRowStackView())
        
    }
    
    // MARK: - Selectors
    
    @objc private func decreaseButtonTapped(_ sender: UIButton) {
        slider.value -= 1
        sliderValueChanged(slider)
    }
    
    @objc private func increaseButtonTapped(_ sender: UIButton) {
        slider.value += 1
        sliderValueChanged(slider)
    }
    
    @objc private func sliderValueChanged(_ sender: UISlider) {
        
        valueLabel.text = valueString()
        callback?(Double(slider.value))
    }
    
    // MARK: - Helpers
    
    private func topRowStackView() -> UIStackView {
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(valueLabel)
        
        return stackView
    }
    
    private func bottomRowStackView() -> UIStackView {
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        let bundle = Bundle(for: CPSliderTableViewCell.self)
        
        let dimension: CGFloat = 33
        let decreaseButton = UIButton()
        decreaseButton.translatesAutoresizingMaskIntoConstraints = false
        let minusImage = UIImage(named: "minus_slider", in: bundle, compatibleWith: nil)
        decreaseButton.setImage(minusImage, for: .normal)
        decreaseButton.addTarget(self, action: #selector(decreaseButtonTapped), for: .touchUpInside)
        stackView.addArrangedSubview(decreaseButton)
        decreaseButton.widthAnchor.constraint(equalToConstant: dimension).isActive = true
        decreaseButton.heightAnchor.constraint(equalToConstant: dimension).isActive = true
        
        stackView.addArrangedSubview(slider)
        
        let increaseButton = UIButton()
        increaseButton.translatesAutoresizingMaskIntoConstraints = false
        let plusImage = UIImage(named: "plus_slider", in: bundle, compatibleWith: nil)
        increaseButton.setImage(plusImage, for: .normal)
        increaseButton.addTarget(self, action: #selector(increaseButtonTapped), for: .touchUpInside)
        stackView.addArrangedSubview(increaseButton)
        increaseButton.widthAnchor.constraint(equalToConstant: dimension).isActive = true
        increaseButton.heightAnchor.constraint(equalToConstant: dimension).isActive = true
        
        stackView.addArrangedSubview(increaseButton)
        
        return stackView
    }
    
    private func valueString() -> String? {
        return "\(Int(round(slider.value)))" + (unitString ?? "")
    }
}
#endif
