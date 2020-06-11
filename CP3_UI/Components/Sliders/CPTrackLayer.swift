//
//  CPTrackLayer.swift
//  CP3_UI
//
//  Created by Corné on 24/04/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

import UIKit

final class CPTrackLayer: CALayer {
    
    weak var rangeSlider: CPRangeSlider?
    
    override func draw(in ctx: CGContext) {
        
        guard let slider = rangeSlider else {
            return
        }
        
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        ctx.addPath(path.cgPath)
        ctx.setFillColor(slider.trackTintColor.cgColor)
        ctx.fillPath()
        
        ctx.setFillColor(slider.trackHighlightTintColor.cgColor)
        let lowerValuePosition = slider.positionForValue(slider.lowerValue)
        let upperValuePosition = slider.positionForValue(slider.upperValue)
        let rect = CGRect(x: lowerValuePosition + 5, y: 0,
                          width: (upperValuePosition - lowerValuePosition) + 5,
                          height: bounds.height)
        ctx.fill(rect)
        ctx.setFillColor(slider.trackTintColor.cgColor)
    }
}
