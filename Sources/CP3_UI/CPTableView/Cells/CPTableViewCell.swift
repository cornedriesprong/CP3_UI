//
//  CPTableViewCell.swift
//  CP3_UI
//
//  Created by Corné on 17/04/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

import UIKit

open class CPTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    public static let reuseIdentifier = String(describing: type(of: self))
    
    private let cellStyle: UITableViewCell.CellStyle?
    
    // MARK: - Initialization
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.cellStyle = style
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    open func configure() {
        
        backgroundColor = .clear
        
        textLabel?.font = Font.font()
        textLabel?.textColor = .white
        
        imageView?.tintColor = .white
        
        let detailTextSize: CGFloat = cellStyle == .subtitle ? 10 : 14
        detailTextLabel?.font = Font.font(ofSize: detailTextSize)
        detailTextLabel?.textColor = UIColor.white.withAlphaComponent(0.5)
        detailTextLabel?.numberOfLines = 0
        
        backgroundColor = ColorTheme.darkGray
        selectionStyle = .none
        tintColor = .white
    }
    
    // MARK: - Layout
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.layer.cornerRadius = imageView!.bounds.width / 2
    }
}
