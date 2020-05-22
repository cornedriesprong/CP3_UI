//
//  CPRotaryKnob.swift
//  CP3_UI
//
//  Created by Corné on 22/05/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

import UIKit

public final class CPRotaryKnob: UIControl {
    
    // MARK: - Properties
    
    static let lineWidth: CGFloat = 3
    
    private (set) var value: Double = 0
    
    private lazy var backgroundLayer: CAShapeLayer = {
        
        let layer = CAShapeLayer()
        layer.fillColor = nil
        layer.strokeColor = Color.darkestGray.cgColor
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
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    private func configure() {
        
        tintColor = Color.red
        
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(valueLayer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        addGestureRecognizer(panGestureRecognizer)
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
        
        valueLayer.lineWidth = CPRotaryKnob.lineWidth * 2
        valueLayer.strokeColor = tintColor.bright().cgColor
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
            
        case .ended, .cancelled:
            valueLayer.lineWidth = CPRotaryKnob.lineWidth
            valueLayer.strokeColor = tintColor.cgColor
            
        default:
            break
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
