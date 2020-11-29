//
//  GridCollectionViewCell.swift
//  cykle
//
//  Created by Corné on 28/09/2018.
//  Copyright © 2018 CP3. All rights reserved.
//

import UIKit

fileprivate final class GridSelectionView: UIView {
    
    var color: UIColor {
        didSet {
            setNeedsLayout()
        }
    }
    
    var segmentCount = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    init(color: UIColor, segmentCount: Int = 0) {
        self.color = color
        self.segmentCount = segmentCount
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        subviews.forEach { $0.removeFromSuperview() }
        
        for i in 0..<segmentCount {
            
            let isLastSegment = i == (segmentCount - 1)
            let width = segmentCount > 0 ? (bounds.width / CGFloat(segmentCount)) : bounds.width
            let x = CGFloat(i) * width
            let rect = CGRect(
                x: x,
                y: 0,
                width: isLastSegment ? width : width - 1,
                height: bounds.height)
            let view = UIView(frame: rect)
            view.backgroundColor = self.color
            addSubview(view)
        }
    }
}

public class GridCollectionViewCell: UICollectionViewCell {

    // MARK: - Private properties

    private lazy var label: UILabel = {

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        label.font = Font.font()
        label.textColor = Color.darkGray

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
            UIView.animate(withDuration: 0.2) {
                self.selectionView.alpha = self.isSelected ? 1 : 0.25
                self.label.textColor = self.isSelected ? Color.darkGray : self.color
            }
            setLabelState()
        }
    }

    override public var isHighlighted: Bool {
        didSet {
            selectionView.color = isHighlighted ? .white : color
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

        valueName = nil
        stepIndex = nil
        label.text = nil
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

        setLabelState()

        backgroundColor = .clear
        selectionView.color = color
        selectionView.segmentCount = ratchetCount + 1

        selectionView.alpha = isSelected ? 1 : 0.25
        label.textColor = isSelected ? Color.darkGray : color
    }

    private func setLabelState() {

        if let valueName = valueName, isSelected, showValueLabels {
            label.text = valueName
        } else if let stepIndex = stepIndex {
            label.text = "\(stepIndex)"
        } else {
            label.text = nil
        }
    }
}
