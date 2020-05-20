//
//  CPMenuItem.swift
//  CP3_UI
//
//  Created by Corné on 15/05/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

import UIKit
import CP3Music

public enum CPMenuItem: CPTableViewItem {
    case scale(Scale)
    case key(Key)
    case midiOutputChannel(Int, callback: (Int) -> Void)
    case manual
    case about
    case contact
    case www
    case rate
    
    public var image: UIImage? {
        return nil
    }
    
    public var accessoryType: UITableViewCell.AccessoryType {
        return .none
    }
    
    public var cellHeight: CGFloat {
        return 44
    }
    
    public func cell(with color: UIColor) -> CPTableViewCell {
        
        let cell = CPTableViewCell()
        cell.textLabel?.text = self.description
        cell.accessoryType = self.accessoryType
        cell.backgroundColor = .clear
        cell.imageView?.image = self.image
        
        return cell
    }
    
    public var description: String {
        switch self {
        case .scale:
            return "Scale"
        case .key:
            return "Key"
        case .midiOutputChannel:
            return "Output channel"
        case .manual:
            return "User Manual"
        case .about:
            return "About"
        case .contact:
            return "Email developer"
        case .www:
            return "Website"
        case .rate:
            return "Rate in app store"
        }
    }
}
