//
//  CPTableViewItem.swift
//  CP3_UI
//
//  Created by Corné on 15/05/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

import UIKit

public protocol CPTableViewItem: CustomStringConvertible {
    
    @available(iOS 13.0, *)
    var image: UIImage? { get }
    
    var accessoryType: UITableViewCell.AccessoryType { get }
    var cellHeight: CGFloat { get }
    var detailDescription: String? { get }
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
