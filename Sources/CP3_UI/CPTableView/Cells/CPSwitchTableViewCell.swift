//
//  CPSwitchTableViewCell.swift
//  CP3_UI
//
//  Created by Corné on 17/04/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

import UIKit

public final class CPSwitchTableViewCell: CPTableViewCell {
    
    // MARK: - Properties
    
    private lazy var `switch`: UISwitch = {
        
        let `switch` = UISwitch()
        `switch`.translatesAutoresizingMaskIntoConstraints = false
        
        `switch`.addTarget(
            self,
            action: #selector(switchValueChanged),
            for: .valueChanged)
        
        return `switch`
    }()
    
    public var actionCallBack: ((_ isOn: Bool) -> Void)?
    
    public var color: UIColor = ColorTheme.red.uiColor {
        didSet {
            `switch`.tintColor = color
            `switch`.onTintColor = color
        }
    }
    
    // MARK: - Initialization
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    override public func configure() {
        super.configure()
        
        contentView.addSubview(self.switch)
        self.switch.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        self.switch.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        
        setNeedsDisplay()
    }
    
    public func setValue(isOn: Bool, color: UIColor = ColorTheme.red.uiColor) {
        self.switch.isOn = isOn
        self.switch.tintColor = color
        self.switch.onTintColor = color
    }
    
    // MARK: - Selectors
    
    @objc private func switchValueChanged(_ sender: UISwitch) {
        actionCallBack?(sender.isOn)
    }
}
