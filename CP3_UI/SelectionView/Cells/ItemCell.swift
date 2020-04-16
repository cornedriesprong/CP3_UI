//
//  SelectionCell.swift
//  CP3_UI
//
//  Created by Corné on 16/04/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

import UIKit

protocol ItemCellDelegate: class {
    func deleteItem(withIndex index: Int)
    func duplicateItem(withIndex index: Int)
}

final class ItemCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = String(describing: type(of: self))
    
    private (set) lazy var label: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .white
        label.font = Font.font()
        
        return label
    }()
    
    private var color: UIColor?
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    weak var delegate: ItemCellDelegate?
    
    override var isSelected: Bool {
        didSet {
            backgroundView?.backgroundColor = isSelected ? color : color?.dark()
            label.textColor = isSelected ? Color.darkGray : color!
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    private func configure() {
        
        backgroundColor = .clear
        backgroundView = UIView()
        
        addSubview(label)
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func configure(index: Int,
        title: String,
        color: UIColor) {
        
        self.color = color
        
        // set label text color appropriately
        label.textColor = isSelected ? Color.darkGray : color
        backgroundView?.backgroundColor = isSelected ? color : color.dark()
        
        tag = index
        label.text = title
    }
    
    // MARK: - Selectors
    
    @objc private func deleteButtonTapped(_ sender: UIMenuController) {
        delegate?.deleteItem(withIndex: tag)
    }
    
    @objc private func duplicateButtonTapped(_ sender: UIMenuController) {
        delegate?.duplicateItem(withIndex: tag)
    }
}
