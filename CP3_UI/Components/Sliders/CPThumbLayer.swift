//
//  CPThumbLayer.swift
//  CP3_UI
//
//  Created by Corné on 24/04/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

import UIKit

final class CPThumbLayer: CALayer {
    
    // MARK: - Private properties
    
    static let size = CGSize(width: 28, height: 28)
    
    public var tintColor = Color.red
    public var highlightedColor = UIColor.white
    
    public var isHighlighted = false {
        didSet {
            borderColor = isHighlighted ? highlightedColor.cgColor : tintColor.cgColor
        }
    }
    
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
        
        backgroundColor = Color.darkGray.cgColor
        borderWidth = 3
        borderColor = tintColor.cgColor
        cornerRadius = type(of: self).size.width / 2
        frame.size = type(of: self).size
    }
}
