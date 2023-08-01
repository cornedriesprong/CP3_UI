//
//  CPRangeSlider.swift
//  CP3_UI
//
//  Created by Corné on 23/04/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

import UIKit

public final class CPRangeSlider: UIControl {
    
    // MARK: - Properties
    
    static let borderWidth: CGFloat = 4
    
    private lazy var trackLayer: CPTrackLayer = {
    
        let layer = CPTrackLayer()
        layer.backgroundColor = ColorTheme.darkGray.cgColor
        layer.contentsScale = UIScreen.main.scale
        layer.rangeSlider = self
        layer.cornerRadius = CPRangeSlider.borderWidth / 2
        layer.masksToBounds = true
        
        return layer
    }()
    
    private let trackMaskLayer = CALayer()
    
    private lazy var lowerThumbLayer: CPThumbLayer = {
        
        let layer = CPThumbLayer()
        layer.contentsScale = UIScreen.main.scale
        layer.tintColor = tintColor
        
        return layer
    }()
    
    private lazy var upperThumbLayer: CPThumbLayer = {
        
        let layer = CPThumbLayer()
        layer.contentsScale = UIScreen.main.scale
        layer.tintColor = tintColor
        
        return layer
    }()
    
    private var previousLocation = CGPoint.zero
    
    public var minimumValue: Float = 0
    public var maximumValue: Float = 1.0
    public var lowerValue: Float = 0
    public var upperValue: Float = 1.0
    
    public override var tintColor: UIColor! {
        didSet {
            trackLayer.backgroundColor = tintColor.cgColor
            upperThumbLayer.tintColor = tintColor
            lowerThumbLayer.tintColor = tintColor
        }
    }
    
    var trackTintColor = ColorTheme.darkestGray
    var trackHighlightTintColor: UIColor {
        return tintColor
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configure()
    }
    
    // MARK: - Layout
    
    public override func layoutSubviews() {
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
    
    // MARK: - Configure
    
    private func configure() {
        
        layer.addSublayer(trackLayer)
        layer.addSublayer(lowerThumbLayer)
        layer.addSublayer(upperThumbLayer)
        
        // this is only here to prevent this from triggering
        // gesture recognizers in containing views
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        panGestureRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(panGestureRecognizer)
    }
    
    // MARK: - Tracking
    
    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {

        previousLocation = touch.location(in: self)
        
        let lowerFrame = lowerThumbLayer.frame.insetBy(dx: -20, dy: -20)
        let upperFrame = upperThumbLayer.frame.insetBy(dx: -20, dy: -20)
        
        if lowerFrame.contains(previousLocation) {
            lowerThumbLayer.isHighlighted = true
        } else if upperFrame.contains(previousLocation) {
            upperThumbLayer.isHighlighted = true
        } else if previousLocation.x > lowerThumbLayer.frame.origin.x &&
            previousLocation.x < (upperThumbLayer.frame.origin.x + upperThumbLayer.frame.width) {
            // touch is in between the thumbs
            upperThumbLayer.isHighlighted = true
            lowerThumbLayer.isHighlighted = true
        }
        
        return lowerThumbLayer.isHighlighted || upperThumbLayer.isHighlighted
    }
    
    public override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        
        let deltaLocation = location.x - previousLocation.x
        let deltaValue = Float((CGFloat(maximumValue) - CGFloat(minimumValue)) * deltaLocation / bounds.width)
        
        // swap thumbs depending on swipe direction if they are in the same location
        if lowerValue == upperValue && location.x > previousLocation.x {
            // moves right
            upperThumbLayer.isHighlighted = true
            lowerThumbLayer.isHighlighted = false
            
        } else if lowerValue == upperValue && location.x < previousLocation.x {
            // moves left
            lowerThumbLayer.isHighlighted = true
            upperThumbLayer.isHighlighted = false
        }
        
        previousLocation = location
        
        if lowerThumbLayer.isHighlighted && upperThumbLayer.isHighlighted {
            // move both thumbs
            lowerValue += deltaValue
            lowerValue = boundValue(lowerValue, toLowerValue: minimumValue, upperValue: upperValue)
            upperValue += deltaValue
            upperValue = boundValue(upperValue, toLowerValue: lowerValue, upperValue: maximumValue)
        } else if lowerThumbLayer.isHighlighted {
            // lower thumb
            lowerValue += deltaValue
            lowerValue = boundValue(lowerValue, toLowerValue: minimumValue, upperValue: upperValue)
        } else if upperThumbLayer.isHighlighted {
            // upper thumb
            upperValue += deltaValue
            upperValue = boundValue(upperValue, toLowerValue: lowerValue, upperValue: maximumValue)
        }
        
        updateLayerFrames()
        sendActions(for: .valueChanged)
        
        return true
    }
    
    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        lowerThumbLayer.isHighlighted = false
        upperThumbLayer.isHighlighted = false
    }
    
    // MARK: - Selectors
    
    @objc private func didPan(_ sender: UIPanGestureRecognizer) {
        
    }
    
    // MARK: - Helpers
    
    func positionForValue(_ value: Float) -> CGFloat {
        return (bounds.width - CPThumbLayer.size.width) * (CGFloat(value) / CGFloat(maximumValue))
    }
    
    private func thumbOriginForValue(_ value: Float) -> CGPoint {
        let x = positionForValue(value)
        return CGPoint(x: x, y: (bounds.height / 2) - (CPThumbLayer.size.height / 2))
    }
    
    private func boundValue(_ value: Float, toLowerValue lowerValue: Float, upperValue: Float) -> Float {
        return min(max(value, lowerValue), upperValue)
    }
}
