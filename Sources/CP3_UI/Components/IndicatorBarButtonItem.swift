//
//  IndicatorBarButtonItem.swift
//  CP3_UI
//
//  Created by Corné Driesprong on 28/03/2023.
//  Copyright © 2023 cp3.io. All rights reserved.
//

import UIKit

public class IndicatorBarButtonItem: UIBarButtonItem {
    
    // MARK: - Properties
    
    private lazy var filterButton: UIButton = {
        
        let button = UIButton()
        let size: CGFloat = 44
        button.frame = CGRect(x: 0, y: 0, width: size, height: size)
        button.adjustsImageWhenHighlighted = true
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.addSubview(indicator)
        
        return button
    }()
    
    private lazy var indicator: UIView = {
       
        let view = UIView()
        let size: CGFloat = 7
        view.frame = CGRect(x: 5, y: 5, width: 7, height: 7)
        view.backgroundColor = ColorTheme.red.uiColor
        view.layer.cornerRadius = size / 2
        
        return view
    }()

    private var badgeVisible = false {
        didSet {
            indicator.isHidden = !badgeVisible
        }
    }

    private let callback: () -> Void
    
    // MARK: - Initialization

    public init(image: UIImage?, callback: @escaping () -> Void) {
        self.callback = callback
        
        super.init()
        
        self.image = image
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration

    private func configure() {
        customView = filterButton
    }

    public func setBadgeVisible(_ isVisible: Bool) {
        self.badgeVisible = isVisible
    }

    // MARK: - Selectors
    
    @objc func didTapButton() {
        callback()
    }
}
