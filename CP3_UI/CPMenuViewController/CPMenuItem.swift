//
//  CPMenuItem.swift
//  CP3_UI
//
//  Created by Corné on 15/05/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

import UIKit

public enum CPMenuItem: CPTableViewItem {
    
    case manual
    case about
    case contact
    case www
    case rate
    case otherApps
    
    public var image: UIImage? {
        switch self {
        case .manual:
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "questionmark.circle")
            } else {
                return nil
            }
        case .about:
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "info.circle")
            } else {
                return nil
            }
        case .contact:
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "envelope")
            } else {
                return nil
            }
        case .www:
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "globe")
            } else {
                return nil
            }
        case .rate:
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "star")
            } else {
                return nil
            }
        case .otherApps:
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "app")
            } else {
                return nil
            }
        }
    }
    
    public var accessoryType: UITableViewCell.AccessoryType {
        switch self {
        case .about:
            return .disclosureIndicator
        default:
            return .none
        }
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
        case .otherApps:
            return "Other apps"
        }
    }
    
    public var detailDescription: String? {
        switch self {
        case .otherApps:
            return "Other music apps by this developer"
        default:
            return nil
        }
    }
}
