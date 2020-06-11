//
//  CPBaseViewController.swift
//  CP3_UI
//
//  Created by Corné on 15/05/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

import UIKit

public protocol CPBaseViewControllerDelegate: class {
    func expandMenu()
}

open class CPBaseViewController: UIViewController {
    
    // MARK: - Properties
    
    public lazy var menuBarButtonItem: UIBarButtonItem = {
       
        let bundle = Bundle(for: CPMenuViewController.self)
        let image = UIImage(named: "menu", in: bundle, compatibleWith: nil)
        let barButtonItem = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(menuButtonTapped))
        
        return barButtonItem
    }()
    
    public lazy var helpBarButtonItem: UIBarButtonItem = {
        
        var image: UIImage? = nil
        if #available(iOSApplicationExtension 13.0, *) {
            image = UIImage(systemName: "questionmark.circle")
        }
        // TODO: add help icon for iOS <13
        
        let barButtonItem = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(helpButtonTapped))
        
        return barButtonItem
    }()
    
    public lazy var snapshotsBarButtonItem: UIBarButtonItem = {
        
        let button = UIButton()
        button.adjustsImageWhenHighlighted = false
        button.translatesAutoresizingMaskIntoConstraints = false
        let color = CPSelectionViewController.color(forSelectedIndex: 0)
        button.setTitleColor(color, for: .normal)
        button.setTitle("A", for: .normal)
        button.titleLabel?.font = Font.fontBold(ofSize: 20)
        button.addTarget(self, action: #selector(snapshotsButtonTapped), for: .touchUpInside)
        button.backgroundColor = .clear
        
        // add some inset to compensate for font baseline being off
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 1, right: 0)
        
        let dimension: CGFloat = 33
        button.widthAnchor.constraint(equalToConstant: dimension).isActive = true
        button.heightAnchor.constraint(equalToConstant: dimension).isActive = true
        
        let barButtonItem = UIBarButtonItem(customView: button)
        return barButtonItem
    }()
    
    private var isSnapshotsMenuVisible = false
    private var snapshotsSelectionHeightConstraint: NSLayoutConstraint?
    //    private lazy var snapshotViewController = SnapshotViewController(snapshot: selectedSnapshot)
    
    // MARK: - Life cycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.darkestGray
        
        configureNavigationBar()
    }
    
    // MARK: - Configuration
    
    open func configureNavigationBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // MARK: - Selectors
    
    @objc open func menuButtonTapped(_ sender: UIBarButtonItem) {
        
    }
    
    @objc open func helpButtonTapped(_ sender: UIBarButtonItem) {
        
    }
    
    @objc private func snapshotsButtonTapped(_ sender: UIBarButtonItem)  {
        
        isSnapshotsMenuVisible = !isSnapshotsMenuVisible
        let height: CGFloat = isSnapshotsMenuVisible ? 44 : 0
        snapshotsSelectionHeightConstraint?.constant = height
        
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: [.allowUserInteraction],
            animations: { [unowned self] in
                self.view.layoutIfNeeded()
                
//                self.snapshotViewController.channelViewControllers.forEach {
//                    $0.tableView.contentInset = UIEdgeInsets(
//                        top: self.isSnapshotsMenuVisible ? 42 : 0,
//                        left: 0,
//                        bottom: $0.tableView.contentInset.bottom,
//                        right: 0)
//                }
        })
    }
}
