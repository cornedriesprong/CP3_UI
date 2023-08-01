//
//  CPMinimalSlider.swift
//  CP3_UI
//
//  Created by Corné Driesprong on 31/05/2023.
//  Copyright © 2023 cp3.io. All rights reserved.
//

import UIKit

public final class CPMinimalSlider: UIControl {
    
    // MARK: - Properties
    
    static let lineWidth: CGFloat = 5
    
    public var value: Double = 0.5 {
        didSet {
            sendActions(for: .valueChanged)
        }
    }
    
    private lazy var backgroundLayer: CAShapeLayer = {
        
        let layer = CAShapeLayer()
        layer.fillColor = nil
        layer.strokeColor = tintColor.withAlphaComponent(0.5).cgColor
        layer.strokeStart = 0
        layer.strokeEnd = 1
        layer.lineWidth = CPMinimalSlider.lineWidth
        layer.lineCap = .round
        
        return layer
    }()
    
    private lazy var valueLayer: CAShapeLayer = {
        
        let layer = CAShapeLayer()
        layer.fillColor = nil
        layer.strokeColor = tintColor.cgColor
        layer.strokeStart = 0
        layer.strokeEnd = value
        layer.lineWidth = CPMinimalSlider.lineWidth
        layer.lineCap = .round
        
        return layer
    }()
    
    private var valueOffset: CGFloat?
    
    // MARK: - Initialization
    
    public init(color: UIColor) {
        super.init(frame: .zero)
        
        self.tintColor = color
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    private func configure() {
        
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(valueLayer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        addGestureRecognizer(panGestureRecognizer)
        
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: 174).isActive = true
        heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    // MARK: - Layout
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundLayer.frame = bounds
        backgroundLayer.path = layerPath().cgPath
        
        valueLayer.frame = bounds
        valueLayer.path = layerPath().cgPath
        valueLayer.strokeEnd = value
    }
    
    // MARK: - Touches
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        valueLayer.lineWidth = CPMinimalSlider.lineWidth * 2
        valueLayer.strokeColor = tintColor.bright().cgColor
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        valueLayer.lineWidth = CPMinimalSlider.lineWidth
        valueLayer.strokeColor = tintColor.cgColor
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
//        valueLayer.lineWidth = CPMinimalSlider.lineWidth
//        backgroundLayer.lineWidth = CPMinimalSlider.lineWidth
        
//        valueLayer.strokeColor = tintColor.cgColor
    }
    
    // MARK: - Selectors
    
    @objc private func didPan(_ sender: UIPanGestureRecognizer) {
        
        let dragDistance: CGFloat = 200.0
        
        switch sender.state {
        case .began:
            valueOffset = CGFloat(value) * dragDistance
            
        case .changed:
            guard let valueOffset = valueOffset else { return }
            let translation = sender.translation(in: self).x
            let offsetValue = (translation + valueOffset)
            CATransaction.setDisableActions(true)
            valueLayer.strokeEnd = offsetValue / dragDistance
            CATransaction.setDisableActions(false)
            self.value = min(1, max(0, Double(offsetValue / dragDistance)))
            
//        case .ended, .cancelled, .failed:
            
            
        default:
            valueLayer.lineWidth = CPRotaryKnob.lineWidth
            valueLayer.strokeColor = tintColor.cgColor
        }
    }
    
    
    // MARK: - Helpers
    
    private func layerPath() -> UIBezierPath {
        
        let path = UIBezierPath()
        let y = bounds.height / 2
        path.move(to: CGPoint(x: 0, y: y))
        path.addLine(to: CGPoint(x: bounds.width, y: y))
        
        path.lineWidth = CPMinimalSlider.lineWidth
        path.lineCapStyle = .round
        
        tintColor.setStroke()
        path.stroke()
        
        return path
    }
}
