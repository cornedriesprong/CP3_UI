//
//  SelectionCell.swift
//  CP3_UI
//
//  Created by Corné on 16/04/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

import UIKit

open class CPItemCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    public static let reuseIdentifier = String(describing: type(of: CPItemCell.self))
    
    public lazy var label: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .white
        label.font = Font.font()
        
        return label
    }()
    
    public var color: UIColor?
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    override open var isSelected: Bool {
        didSet {
            selectionDidChange()
        }
    }
    
    public var isPulsating: Bool = false {
        didSet {
            if isPulsating {
                UIView.animate(
                    withDuration: 0.8,
                    delay: 0,
                    options: [.repeat, .allowUserInteraction],
                    animations: { [weak self] in
                        self?.alpha = 0.5
                    },
                    completion: nil)
            } else {
                layer.removeAllAnimations()
                alpha = 1
            }
        }
    }
    
    override public var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - Initialization
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    open func configure() {
        
        backgroundColor = .clear
        backgroundView = UIView()
        
        addSubview(label)
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    open func configure(index: Int,
        title: String,
        color: UIColor) {
        
        self.color = color
        
        // set label text color appropriately
        label.textColor = isSelected ? ColorTheme.darkGray : color
        backgroundView?.backgroundColor = isSelected ? color : color.dark()
        
        tag = index
        label.text = title
    }
    
    // MARK: - Helpers
    
    open func selectionDidChange() {
        
        backgroundView?.backgroundColor = isSelected ? color : color?.dark()
        label.textColor = isSelected ? ColorTheme.darkGray : color!
    }
}
