//
//  Pitch+color.swift
//  CP3_UI
//
//  Created by Corné on 22/05/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

import UIKit
import CP3Music

public extension Pitch.Class {
    
    var color: UIColor {
        return Color.allColors[rawValue]
    }
}
