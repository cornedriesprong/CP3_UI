//
//  CPValueControlTableViewCell.swift
//  CP3_UI
//
//  Created by Corné on 24/04/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

#if canImport(UIKit)
import UIKit

public final class CPValueControlTableViewCell: CPTableViewCell {
    
    // MARK: - Properties
    
    public var valueControl: CPValueControl = {
        
        let valueControl = CPValueControl()
        valueControl.translatesAutoresizingMaskIntoConstraints = false
        
        return valueControl
    }()
    
    // MARK: - Life cycle
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        valueControl.actionCallback = nil
    }
    
    // MARK: - Configure
    
    override public func configure() {
        super.configure()
        
        addSubview(valueControl)
        valueControl.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        valueControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    public func configure(value: Int, callback: @escaping (_ value: Int) -> Void) {
        
        valueControl.value = value
        valueControl.actionCallback = callback
    }
}
#endif
