//
//  GridCollectionViewCell.swift
//  cykle
//
//  Created by Corné on 28/09/2018.
//  Copyright © 2018 CP3. All rights reserved.
//

import UIKit

fileprivate final class GridSelectionView: UIView {
    
    // MARK: - Properties
    
    var color: UIColor {
        didSet {
            segmentViews.forEach { $0.backgroundColor = color }
        }
    }
    
    var segmentCount = 0 {
        didSet {
            configure()
        }
    }
    
    private var segmentViews = [UIView]()
    
    // MARK: - Initialization
    
    init(color: UIColor, segmentCount: Int = 0) {
        self.color = color
        self.segmentCount = segmentCount
        
        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    private func configure() {
        
        backgroundColor = .clear
        
        segmentViews.forEach { $0.removeFromSuperview() }
        segmentViews.removeAll()
        
        for _ in 0..<segmentCount {
            
            let view = UIView()
            view.backgroundColor = self.color
            addSubview(view)
            segmentViews.append(view)
        }
        
        setNeedsLayout()
    }
    
    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        
        for (i, view) in segmentViews.enumerated() {
            
            let isLastSegment = i == (segmentCount - 1)
            let width = segmentCount > 0 ? (bounds.width / CGFloat(segmentCount)) : bounds.width
            let x = CGFloat(i) * width
            view.frame = CGRect(
                x: x,
                y: 0,
                width: isLastSegment ? width : width - 1,
                height: bounds.height)
        }
    }
}

public class GridCollectionViewCell: UICollectionViewCell, Highlightable, Reusable {
    
    // MARK: - Private properties

    private lazy var label: UILabel = {

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        label.font = Font.font()
        label.textColor = ColorTheme.darkGray

        return label
    }()
    
    private lazy var selectionView: GridSelectionView = {

        let view = GridSelectionView(color: .red)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    private var color: UIColor!
    private var valueName: String?
    private var stepIndex: Int?
    private var showValueLabels = false

    // MARK: - Properties

    override public var isSelected: Bool {
        didSet {
            self.selectionView.alpha = self.isSelected ? 1 : 0.25
            self.label.textColor = self.isSelected ? ColorTheme.darkGray : self.color
            setLabelState()
        }
    }
    
    public var isActive: Bool = false {
        didSet {
            if isActive {
                selectionView.color = .white
            } else {
                let alpha = ((0.75 / 127.0) * Double(velocityValue)) + 0.25
                selectionView.color = color.withAlphaComponent(alpha)
            }
        }
    }
    
    public var velocityValue: Int = 127 {
        didSet {
            let alpha = ((0.75 / 127.0) * Double(velocityValue)) + 0.25
            selectionView.color = color.withAlphaComponent(alpha)
        }
    }
    
    public var ratchetCount: Int = 0 {
        didSet {
            selectionView.segmentCount = ratchetCount + 1
            setLabelState()
        }
    }

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    private func configure() {
        
        backgroundColor = .clear

        contentView.addSubview(selectionView)
        selectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        selectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        selectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        selectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        contentView.addSubview(label)
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    override public func prepareForReuse() {
        super.prepareForReuse()

        isSelected = false
        valueName = nil
        stepIndex = nil
        label.text = nil
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        label.isHidden = bounds.height < 15
    }

    public func configure(
        withColor color: UIColor,
        valueName: String? = nil,
        ratchetCount: Int = 0,
        stepIndex: Int? = nil,
        showValueLabels: Bool = false) {

        self.color = color
        self.showValueLabels = showValueLabels

        self.valueName = valueName
        self.stepIndex = stepIndex

        selectionView.color = color
        self.ratchetCount = ratchetCount
        
        setLabelState()

        selectionView.alpha = isSelected ? 1 : 0.25
        label.textColor = isSelected ? ColorTheme.darkGray : color
    }

    private func setLabelState() {

        if selectionView.segmentCount > 1 {
            label.text = nil
        } else if let valueName = valueName, isSelected, showValueLabels {
            label.text = valueName
        } else if let stepIndex = stepIndex {
            label.text = "\(stepIndex)"
        } else {
            label.text = nil
        }
    }
}
