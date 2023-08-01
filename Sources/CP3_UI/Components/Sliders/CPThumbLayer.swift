//
//  CPThumbLayer.swift
//  CP3_UI
//
//  Created by Corné on 24/04/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

import UIKit

public final class CPThumbLayer: CALayer {
    
    // MARK: - Private properties
    
    public static let size = CGSize(width: 32, height: 32)
    
    public var tintColor: UIColor = ColorTheme.blue.uiColor {
        didSet {
            borderColor = tintColor.cgColor
        }
    }
    public var highlightedColor = UIColor.white
    
    public var isHighlighted = false {
        didSet {
            guard isHighlighted != oldValue else { return }
            
            let anim = CABasicAnimation()
            anim.keyPath = "borderWidth"
            anim.fromValue = isHighlighted ? CPRangeSlider.borderWidth : 6
            anim.toValue = isHighlighted ? 6 : CPRangeSlider.borderWidth
            anim.duration = 0.2
            anim.fillMode = .forwards
            anim.isRemovedOnCompletion = false
            self.add(anim, forKey: "grow")
        }
    }
    
    private lazy var centerLayer: CALayer = {
        
        let layer = CALayer()
        let inset = CPRangeSlider.borderWidth - 1
        layer.frame = bounds.insetBy(dx: inset, dy: inset)
        layer.cornerRadius = (bounds.width - CPRangeSlider.borderWidth) / 2
        layer.backgroundColor = ColorTheme.darkGray.cgColor
        
        return layer
    }()
    
    // MARK: - Initialization
    
    override init(layer: Any) {
        super.init(layer: layer)
        
        configure()
    }
    
    override init() {
        super.init()
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    private func configure() {
        
        borderWidth = CPRangeSlider.borderWidth
        borderColor = tintColor.cgColor
        cornerRadius = type(of: self).size.width / 2
        frame.size = type(of: self).size
        addSublayer(centerLayer)
    }
}
