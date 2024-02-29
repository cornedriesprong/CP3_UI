//
//  SelectionController.swift
//  CP3_UI
//
//  Created by Corné on 16/04/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

#if canImport(UIKit)
import UIKit

public protocol SelectionViewControllerDelegate: AnyObject {
    func didSelectItem(withIndex index: Int) -> Bool
    func didAddItem()
    func didDeleteItem(withIndex index: Int)
    func didDuplicateItem(withIndex: Int)
}

open class CPSelectionViewController: UIViewController {
    
    // MARK: - Properties
    
    static let height: CGFloat = 64
    static let cellWidth: CGFloat = 66
    
    public lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = canAddItems
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(
            CPItemCell.self,
            forCellWithReuseIdentifier: CPItemCell.reuseIdentifier)
        
        collectionView.register(
            CPAddItemCell.self,
            forCellWithReuseIdentifier: CPAddItemCell.reuseIdentifier)
        
        return collectionView
    }()
    
    private lazy var blurEffect = UIBlurEffect(style: .dark)
    private lazy var blurView: UIVisualEffectView = {
        
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var itemCount: Int
    private var itemNames: [String]
    private let canAddItems: Bool
    private let maxItemCount: Int
    private let pulsates: Bool
        
    public var selectedItemIndex = 0 {
        didSet {
            let indexPath = IndexPath(item: selectedItemIndex, section: 0)
            collectionView.selectItem(
                at: indexPath,
                animated: false,
                scrollPosition: [])
            
            if pulsates {
                // animate pending snapshot cell
                for cell in collectionView.visibleCells where (cell as? CPItemCell)?.isPulsating == true {
                    (collectionView.cellForItem(at: indexPath) as? CPItemCell)?.isPulsating = false
                }
                (collectionView.cellForItem(at: indexPath) as? CPItemCell)?.isPulsating = true
            }
        }
    }
    
    public weak var delegate: SelectionViewControllerDelegate?
    
    // MARK: - Initialization
    
    public init(itemCount: Int, itemNames: [String]? = nil, canAddItems: Bool = true, maxItemCount: Int = 8, pulsates: Bool = true) {
        self.itemCount = itemCount
        self.itemNames = itemNames ?? (0...itemCount).map { "\($0)" }
        self.canAddItems = canAddItems
        self.maxItemCount = maxItemCount
        self.pulsates = pulsates
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = true
        view.backgroundColor = .clear

        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 43).isActive = true
        
        view.insertSubview(blurView, at: 0)
        blurView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blurView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        blurView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        selectCurrentItem()
    }
    
    // MARK: - Configuration
    
    public func configure(with itemCount: Int, selectedItemIndex index: Int = 0) {
        
        self.itemCount = itemCount
        selectedItemIndex = index
        collectionView.reloadData()
        selectCurrentItem()
    }
    
    // MARK: - Helpers
    
    private func selectCurrentItem() {
        
        let indexPath = IndexPath(item: selectedItemIndex, section: 0)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
    
    private func scrollToLastItem() {
        
        let indexPath = IndexPath(item: itemCount, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .right, animated: true)
    }
    
    private func updateCells() {
        // update cell labels and colors
        for indexPath in self.collectionView.indexPathsForVisibleItems {
            let itemCell = self.collectionView.cellForItem(at: indexPath) as? CPItemCell
            itemCell?.label.text = "\(indexPath.item + 1)"
            itemCell?.configure(
                index: indexPath.row,
                title: itemNames[indexPath.row],
                color: CPSelectionViewController.color(forSelectedIndex: indexPath.row))
        }
    }
    
    public static func color(forSelectedIndex index: Int) -> UIColor {
        return ColorTheme.allCases[(index * 5) % ColorTheme.allCases.count].uiColor
    }
    
    func deleteItem(withIndex index: Int) {
        
        // cannot delete last item
        guard itemCount > 1 else {
            return
        }
        
        // if deleted channel was selected, select previous
        if selectedItemIndex >= itemCount - 1 {
            selectedItemIndex -= 1
        }
        
        itemCount -= 1
        delegate?.didDeleteItem(withIndex: index)
        
        collectionView.performBatchUpdates({ [weak self] in
            let indexPath = IndexPath(item: index, section: 0)
            self?.collectionView.deleteItems(at: [indexPath])
        }) { [weak self] _ in
            self?.updateCells()
            self?.selectCurrentItem()
        }
    }
    
    func duplicateItem(withIndex index: Int) {
        
        itemCount += 1
        delegate?.didDuplicateItem(withIndex: index)
        
        collectionView.performBatchUpdates({ [unowned self] in
            let indexPath = IndexPath(item: index + 1, section: 0)
            self.collectionView.insertItems(at: [indexPath])
        }) { [weak self] _ in
            // reload data to reset channel numbers
            self?.updateCells()
            self?.selectCurrentItem()
        }
    }
    
    // MARK: - Selectors
    
    // this is just here to be able to set a custom tooltip menu item
    @objc private func deleteButtonTapped(_ sender: UIMenuController) { }
    @objc private func duplicateButtonTapped(_ sender: UIMenuController) { }
}

extension CPSelectionViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return canAddItems ? itemCount + 1 : itemCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == itemCount {
            // last cell, show add item cell
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CPAddItemCell.reuseIdentifier,
                for: indexPath) as! CPAddItemCell
            
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CPItemCell.reuseIdentifier,
                for: indexPath) as! CPItemCell
            
            cell.configure(
                index: indexPath.row,
                title: itemNames[indexPath.row],
                color: CPSelectionViewController.color(forSelectedIndex: indexPath.row))
            
            return cell
        }
    }
}

extension CPSelectionViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        // shouldn't be able to (re)select current item
        if selectedItemIndex == indexPath.row {
            return false
        } else {
            return true
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == itemCount {
            
            if itemCount >= maxItemCount {
                return
            }
            itemCount += 1
            delegate?.didAddItem()
            
            collectionView.performBatchUpdates({ [weak self] in
                self?.selectCurrentItem()
                let indexPath = IndexPath(item: itemCount - 1, section: 0)
                self?.collectionView.insertItems(at: [indexPath])
            }) { [weak self] _ in
                self?.selectCurrentItem()
                self?.scrollToLastItem()
            }
            
        } else {
            selectedItemIndex = indexPath.row
            delegate?.didSelectItem(withIndex: selectedItemIndex)
        }
    }
    
    @available(iOS 13.0, *)
    public func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        // don't show menu for add item cell
        guard indexPath.item < itemCount else {
            return nil
        }
        
        var actions = [UIAction]()
        if itemCount > 1 {
            let deleteAction = UIAction(
                title: "Delete",
                image: UIImage(systemName: "trash"),
                attributes: [.destructive]) { [weak self] _ in
                    self?.deleteItem(withIndex: indexPath.item)
            }
            actions.append(deleteAction)
        }
        
        if itemCount < maxItemCount {
            let duplicateAction = UIAction(title: "Duplicate", image: UIImage(systemName: "doc.on.doc")) { [weak self] _ in
                self?.duplicateItem(withIndex: indexPath.item)
            }
            actions.append(duplicateAction)
        }
        
        let actionProvider: UIContextMenuActionProvider = { _ in
            return UIMenu(title: "", children: actions)
        }
        
        return UIContextMenuConfiguration(
            identifier: "unique-ID" as NSCopying,
            previewProvider: nil,
            actionProvider: actionProvider)
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        
        // don't show menu for add item cell
        guard indexPath.item < itemCount else {
            return false
        }
        
        let delete = UIMenuItem(title: "Delete", action: #selector(deleteButtonTapped))
        let duplicate = UIMenuItem(title: "Duplicate", action: #selector(duplicateButtonTapped))
        UIMenuController.shared.menuItems = [delete, duplicate]
        return true
    }
    
    public func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        
        if (action == #selector(deleteButtonTapped) && itemCount > 1) {
            return true
        } else if (action == #selector(duplicateButtonTapped) && itemCount < 7) {
            return true
        }
        
        return false
    }
    
    public func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        
    }
}

extension CPSelectionViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, sizeForItemAt
        indexPath: IndexPath) -> CGSize {
        
        if canAddItems {
            return CGSize(
                width: CPSelectionViewController.cellWidth,
                height: collectionView.bounds.height)
        } else {
            return CGSize(
                width: collectionView.bounds.width / CGFloat(itemCount),
                height: collectionView.bounds.height)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt
        section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
#endif
