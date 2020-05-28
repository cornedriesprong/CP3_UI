//
//  CPNoteVisualizerView.swift
//  CP3_UI
//
//  Created by Corné on 22/05/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

import UIKit
import CP3Music

public final class CPNoteVisualizerView: UIView {
    
    // MARK: - Properties
    
    static let scrollDuration: TimeInterval = 8
    
    private var activeNotes = [Note: CAShapeLayer]()
    
    // MARK: - Initialization
    
    public init() {
        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    private func configure() {

        tintColor = Color.red
        backgroundColor = Color.red.dark()
        
        layer.borderWidth = 1
        layer.borderColor = tintColor.cgColor
    }
    
    public func play(_ note: Note) {
        
        let noteLayer = layer(for: note)
        layer.addSublayer(noteLayer)
        activeNotes[note] = noteLayer
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            noteLayer.removeAllAnimations()
            noteLayer.removeFromSuperlayer()
        }
        
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.fromValue = 0
        animation.toValue = bounds.width + noteLayer.path!.boundingBox.width
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = true
        animation.duration = CPNoteVisualizerView.scrollDuration
        
        let id = UUID().uuidString
        noteLayer.add(animation, forKey: "move-\(id)")
        
        CATransaction.commit()
    }
    
    public func stop(_ note: Note) {
        
        guard let duration = note.duration,
            let layer = activeNotes[note],
            let oldPath = layer.path else {
                return
        }
        
        
        let width = (bounds.width / CGFloat(CPNoteVisualizerView.scrollDuration)) * CGFloat(duration) * 2
        let xOffset = bounds.width - width
        let rect = CGRect(
            x: oldPath.boundingBox.origin.x + xOffset,
            y: oldPath.boundingBox.origin.y,
            width: width,
            height: 5)
        let newPath = UIBezierPath(roundedRect: rect, cornerRadius: 2)
        layer.path = newPath.cgPath
        layer.opacity = self.opacity(for: note.velocity)
        let color = Color.allColors[note.pitch.class.rawValue]
        layer.fillColor = color.cgColor
        activeNotes[note]?.path = newPath.cgPath
    }
    
    // MARK: - Helpers
    
    private func layer(for note: Note) -> CAShapeLayer {
        
        let layer = CAShapeLayer()
        let y = self.y(for: note.pitch)
        let rect = CGRect(
            x: -bounds.width,
            y: y,
            width: bounds.width,
            height: 5)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 2)
        layer.path = path.cgPath
        layer.opacity = self.opacity(for: note.velocity)
        let color = Color.allColors[note.pitch.class.rawValue]
        layer.fillColor = color.cgColor
        
        return layer
    }
    
    private func y(for pitch: Pitch) -> CGFloat {
        
        var y = (bounds.height / 120) * CGFloat(pitch.midiNoteNumber)
        y = (y * -1) + bounds.height
        
        return y
    }
    
    private func opacity(for velocity: Int) -> Float {
        return (Float(velocity) / 64) + 0.5
    }
}
