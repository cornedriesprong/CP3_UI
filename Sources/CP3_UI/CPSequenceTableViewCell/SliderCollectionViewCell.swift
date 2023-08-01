//
//  SliderCollectionViewCell.swift
//  cykle
//
//  Created by Corné on 25/01/2019.
//  Copyright © 2019 CP3. All rights reserved.
//

import UIKit

public protocol SliderCollectionViewCellDelegate: AnyObject {
    func setSliderValue(fromCell cell: SliderCollectionViewCell, to value: CGFloat)
    func didLongPress(fromCell cell: SliderCollectionViewCell, with value: CGFloat)
}

public protocol Highlightable: AnyObject {
    var isActive: Bool { get set }
}

public class SliderCollectionViewCell: UICollectionViewCell, Highlightable {
    
    // MARK: - Private properties
    
    private lazy var sliderView = UIView()
    
    // MARK: - Properties
    
    public var isActive: Bool = false {
        didSet {
            sliderView.backgroundColor = isActive ? UIColor.white : self.color
            backgroundColor = isActive ? UIColor.white.withAlphaComponent(0.25) : self.color.withAlphaComponent(0.25)
        }
    }
    
    public var value: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    public var color: UIColor! {
        didSet {
            backgroundColor = color.withAlphaComponent(0.25)
            sliderView.backgroundColor = color
        }
    }
    
    public var isBipolar: Bool = false
    
    public weak var delegate: SliderCollectionViewCellDelegate?
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    private func configure() {
        addSubview(sliderView)
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress))
        addGestureRecognizer(longPressGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tapGestureRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        panGestureRecognizer.delegate = self
        addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc private func didLongPress(_ sender: UILongPressGestureRecognizer) {
        delegate?.didLongPress(fromCell: self, with: value)
    }
    
    @objc private func didTap(_ sender: UITapGestureRecognizer) {
        
        let y = sender.location(in: self).y
        setValue(forYPosition: y)
    }
    
    @objc private func didPan(_ sender: UIPanGestureRecognizer) {
        
        let y = sender.location(in: self).y
        switch sender.state {
        case .possible, .began, .changed:
            setValue(forYPosition: y)
        default:
            break
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        let height: CGFloat
        let y: CGFloat
        if isBipolar {
            if value < 0.5 {
                height = (bounds.height / 2) - (value * bounds.height)
                y = bounds.height / 2
            } else {
                height = (value - 0.5) * (bounds.height)
                y = (bounds.height / 2) - height
            }
        } else {
            height = value * bounds.height
            y = bounds.height - height
        }
        sliderView.frame = CGRect(
            x: 0,
            y: y,
            width: bounds.width,
            height: height)
    }
    
    // MARK: - Helpers
    
    private func setValue(forYPosition yPosition: CGFloat) {
        
        let newValue = (1 / bounds.height) * (bounds.height - yPosition)
        value = max(0, min(1, newValue))
        
        delegate?.setSliderValue(fromCell: self, to: value)
    }
    
    private func toggleScrollLock(isOn: Bool) {
        
        NotificationCenter.default.post(
            name: Notification.Name("scroll-lock"),
            object: isOn)
    }
}

extension SliderCollectionViewCell: UIGestureRecognizerDelegate {
   
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
