//
//  CPSequenceTableViewCell.swift
//  CP3_UI
//
//  Created by Corné on 29/04/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

import UIKit

public protocol SequenceCollectionViewCellDelegate: AnyObject {
    func sequenceChanged<T>(values: T, forSequenceIndex index: Int)
}

open class CPSequenceTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    public lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.alwaysBounceHorizontal = false
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delaysContentTouches = true
        collectionView.canCancelContentTouches = false
        
        collectionView.register(
            GridCollectionViewCell.self,
            forCellWithReuseIdentifier: String(describing: GridCollectionViewCell.self))
        
        collectionView.register(
            SliderCollectionViewCell.self,
            forCellWithReuseIdentifier: String(describing: SliderCollectionViewCell.self))
        
        collectionView.register(
            GridResizingCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: String(describing: GridResizingCell.self))
        
        return collectionView
    }()

    open var cellWidth: CGFloat {
        // round to floor or we get inconsistent cell spacings
        return min(floor(((bounds.width - GridResizingCell.width) / 8) - 1), 65)
    }
    
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    private var previousDragOffset = 0
    public var draggingThreshold: CGFloat!
        
    // MARK: - Properties
    
    public weak var delegate: SequenceCollectionViewCellDelegate?
    
    // MARK: - Configuration
    
    open func configure() {
        
        backgroundColor = ColorTheme.darkGray
        
        contentView.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(orientationDidChange),
            name: UIDevice.orientationDidChangeNotification,
            object: nil)
    }
    
    open func selectValues() {
        
    }
    
    public func activateCell(with indexPath: IndexPath) {
        (collectionView.cellForItem(at: indexPath) as? Highlightable)?.isActive = true
    }
    
    public func deactivateAllCells() {
        collectionView.visibleCells.forEach { ($0 as? Highlightable)?.isActive = false }
    }
    
    // MARK: - Selectors
    
    @objc private func orientationDidChange(_ sender: Notification) {
        
        collectionView.reloadData()
        selectValues()
    }
    
    open func addStep(for index: Int) { }
    open func removeStep(for index: Int) { }
}
