//
//  GridCollectionViewCell.swift
//  cykle
//
//  Created by Corné on 28/09/2018.
//  Copyright © 2018 CP3. All rights reserved.
//

import UIKit

public class GridCollectionViewCell: UICollectionViewCell {

    // MARK: - Private properties

    private lazy var label: UILabel = {

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        label.font = Font.font()
        label.textColor = Color.darkGray

        return label
    }()
    
    private var color: UIColor!
    private var valueName: String?
    private var stepIndex: Int?
    private var showValueLabels = false

    // MARK: - Properties

    override public var isSelected: Bool {
        didSet {
            contentView.alpha = isSelected ? 1 : 0.25
            label.textColor = isSelected ? Color.darkGray : color
            setLabelState()
        }
    }

    override public var isHighlighted: Bool {
        didSet {
            contentView.backgroundColor = isHighlighted ? .white : color
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

        addSubview(label)
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    override public func prepareForReuse() {
        super.prepareForReuse()

        valueName = nil
        stepIndex = nil
        label.text = nil
    }

    public func configure(withColor color: UIColor, valueName: String? = nil, stepIndex: Int? = nil, showValueLabels: Bool = false) {

        self.color = color
        self.showValueLabels = showValueLabels

        self.valueName = valueName
        self.stepIndex = stepIndex

        setLabelState()

        backgroundColor = .clear
        contentView.backgroundColor = color

        contentView.alpha = isSelected ? 1 : 0.25
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
