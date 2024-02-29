//
//  Reusable.swift
//  CP3_UI
//
//  Created by Corné Driesprong on 10/04/2022.
//  Copyright © 2022 cp3.io. All rights reserved.
//

import Foundation

#if canImport(UIKit)
import UIKit

public protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable where Self: UICollectionViewCell {
    
    public static var reuseIdentifier: String {
        return String(describing: (type(of: Self.self)))
    }
}
#endif
