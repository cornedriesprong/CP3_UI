//
//  CPTableViewItem.swift
//  CP3_UI
//
//  Created by Corné on 15/05/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

import UIKit

public protocol CPTableViewItem: CustomStringConvertible {
    var image: UIImage? { get }
    var accessoryType: UITableViewCell.AccessoryType { get }
    var cellHeight: CGFloat { get }
    
    func cell(with color: UIColor) -> CPTableViewCell
}

extension CPTableViewItem {
    
    var image: UIImage? {
        return nil
    }
    
    var accessoryType: UITableViewCell.AccessoryType {
        return .none
    }
    
    var cellHeight: CGFloat {
        return 44
    }
}
