//
//  CPRangeSlider.swift
//  CP3_UI
//
//  Created by Corné on 23/04/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

import UIKit

final class CPRangeSlider: UIControl {
    
    // MARK: - Properties
    
    static let borderWidth: CGFloat = 3
    
    private lazy var trackLayer: CPTrackLayer = {
    
        let layer = CPTrackLayer()
        layer.rangeSlider = self
        
        return layer
    }()
    
    private let lowerThumbLayer = CPThumbLayer()
    private let upperThumbLayer = CPThumbLayer()
    private var previousLocation = CGPoint.zero
    
    public var minimumValue: Float = 0
    public var maximumValue: Float = 127
    public var lowerValue: Float = 0
    public var upperValue: Float = 127
    
    override var tintColor: UIColor! {
        didSet {
            trackLayer.backgroundColor = tintColor.cgColor
            upperThumbLayer.borderColor = tintColor.cgColor
            lowerThumbLayer.borderColor = tintColor.cgColor
        }
    }
    
    var trackTintColor = Color.darkestGray
    var trackHighlightTintColor = Color.red
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.addSublayer(trackLayer)
        layer.addSublayer(lowerThumbLayer)
        layer.addSublayer(upperThumbLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateLayerFrames()
    }
    
    private func updateLayerFrames() {
        
        trackLayer.frame = CGRect(
            x: 0,
            y: (bounds.height / 2) - (type(of: self).borderWidth / 2) ,
            width: bounds.width,
            height: type(of: self).borderWidth)
        trackLayer.setNeedsDisplay()
        
        lowerThumbLayer.frame.origin = thumbOriginForValue(lowerValue)
        lowerThumbLayer.setNeedsDisplay()
        upperThumbLayer.frame.origin = thumbOriginForValue(upperValue)
        upperThumbLayer.setNeedsDisplay()
    }
    
    // MARK: - Tracking
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {

        previousLocation = touch.location(in: self)
        
        if lowerThumbLayer.frame.contains(previousLocation) {
            lowerThumbLayer.isHighlighted = true
        } else if upperThumbLayer.frame.contains(previousLocation) {
            upperThumbLayer.isHighlighted = true
        }
        
        return lowerThumbLayer.isHighlighted || upperThumbLayer.isHighlighted
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        
        let deltaLocation = location.x - previousLocation.x
        let deltaValue = Float((CGFloat(maximumValue) - CGFloat(minimumValue)) * deltaLocation / bounds.width)
        
        previousLocation = location
        
        if lowerThumbLayer.isHighlighted {
            lowerValue += deltaValue
            lowerValue = boundValue(lowerValue, toLowerValue: minimumValue, upperValue: upperValue)
        } else if upperThumbLayer.isHighlighted {
            upperValue += deltaValue
            upperValue = boundValue(upperValue, toLowerValue: lowerValue, upperValue: maximumValue)
        }
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        updateLayerFrames()
        
        CATransaction.commit()
        
        sendActions(for: .valueChanged)
        
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        lowerThumbLayer.isHighlighted = false
        upperThumbLayer.isHighlighted = false
    }
    
    // MARK: - Helpers
    
    func positionForValue(_ value: Float) -> CGFloat {
        return bounds.width * (CGFloat(value) / CGFloat(maximumValue))
    }
    
    private func thumbOriginForValue(_ value: Float) -> CGPoint {
        let x = positionForValue(value) - CPThumbLayer.size.width / 2.0
        return CGPoint(x: x, y: (bounds.height / 2) - (CPThumbLayer.size.height / 2))
    }
    
    private func boundValue(_ value: Float, toLowerValue lowerValue: Float, upperValue: Float) -> Float {
        return min(max(value, lowerValue), upperValue)
    }
}
