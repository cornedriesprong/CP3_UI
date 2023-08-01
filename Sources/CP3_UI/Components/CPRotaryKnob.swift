//
//  CPRotaryKnob.swift
//  CP3_UI
//
//  Created by Corné on 22/05/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

import UIKit

@IBDesignable
public final class CPRotaryKnob: UIControl {
    
    // MARK: - Properties
    
    static let lineWidth: CGFloat = 4
    
    public var value: Double = 0 {
        didSet {
            sendActions(for: .valueChanged)
        }
    }
    
    private lazy var backgroundLayer: CAShapeLayer = {
        
        let layer = CAShapeLayer()
        layer.fillColor = nil
        layer.strokeColor = ColorTheme.darkestGray.cgColor
        layer.strokeStart = 0
        layer.strokeEnd = 1
        layer.lineWidth = CPRotaryKnob.lineWidth
        layer.lineCap = .round
        
        return layer
    }()
    
    private lazy var valueLayer: CAShapeLayer = {
        
        let layer = CAShapeLayer()
        layer.fillColor = nil
        layer.strokeColor = tintColor.cgColor
        layer.strokeStart = 0
        layer.strokeEnd = 0
        layer.lineWidth = 3
        layer.lineCap = .round
        
        return layer
    }()
    
    private var valueOffset: CGFloat?
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configure()
    }
    
    // MARK: - Configure
    
    private func configure() {
        
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(valueLayer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        addGestureRecognizer(panGestureRecognizer)
        
        let size: CGFloat = 66
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: size).isActive = true
        heightAnchor.constraint(equalToConstant: size).isActive = true
    }
    
    // MARK: - Layout
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundLayer.frame = bounds
        backgroundLayer.path = layerPath().cgPath
        
        valueLayer.frame = bounds
        valueLayer.path = layerPath().cgPath
    }
    
    // MARK: - Touches
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        valueLayer.lineWidth = CPRotaryKnob.lineWidth * 1.5
        valueLayer.strokeColor = tintColor.bright().cgColor
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        valueLayer.lineWidth = CPRotaryKnob.lineWidth
        valueLayer.strokeColor = tintColor.cgColor
    }
    
    // MARK: - Selectors
    
    @objc private func didPan(_ sender: UIPanGestureRecognizer) {
        
        let dragDistance: CGFloat = 200.0
        
        switch sender.state {
        case .began:
            valueOffset = CGFloat(value) * dragDistance
            
        case .changed:
            guard let valueOffset = valueOffset else { return }
            let translation = sender.translation(in: self)
            let reversedTranslation = translation.y * -1
            let offsetValue = (reversedTranslation + valueOffset)
            CATransaction.setDisableActions(true)
            valueLayer.strokeEnd = offsetValue / dragDistance
            CATransaction.setDisableActions(false)
            self.value = min(1, max(0, Double(offsetValue / dragDistance)))
            
        default:
            valueLayer.lineWidth = CPRotaryKnob.lineWidth
            valueLayer.strokeColor = tintColor.cgColor
        }
    }
    
    // MARK: - Helpers
    
    private func layerPath() -> UIBezierPath {
        
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let angleOffset: CGFloat = ((.pi / 6) * 2)
        let path = UIBezierPath(
            arcCenter: center,
            radius: bounds.width / 2,
            startAngle: (.pi / 3) + angleOffset,
            endAngle: 0 + angleOffset,
            clockwise: true)
        path.lineWidth = 5
        
        return path
    }
}
