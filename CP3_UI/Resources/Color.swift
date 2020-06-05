//
//  Color.swift
//  CP3_UI
//
//  Created by Corné on 16/04/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

import UIKit

public final class Color {
    
    public static let allColors = [red, orange, yellow, lime, green, cyan, turqoise, blue, azure, purple, lilac, pink]
    
    public static var red: UIColor {
        return UIColor(rgb: 0xED5C55)
    }
    
    public static var orange: UIColor {
        return UIColor(rgb: 0xE4924D)
    }
    
    public static var yellow: UIColor {
        return UIColor(rgb: 0xFFC836)
    }

    public static var lime: UIColor {
        return UIColor(rgb: 0xACD44F)
    }
    
    public static var green: UIColor {
        return UIColor(rgb: 0x41B153)
    }
    
    public static var cyan: UIColor {
        return UIColor(rgb: 0x31C093)
    }
    
    public static var turqoise: UIColor {
        return UIColor(rgb: 0x51C8C8)
    }
    
    public static var blue: UIColor {
        return UIColor(rgb: 0x2E9CC6)
    }
    
    public static var azure: UIColor {
        return UIColor(rgb: 0x6A91D4)
    }
    
    public static var purple: UIColor {
        return UIColor(rgb: 0xA67CD8)
    }
    
    public static var lilac: UIColor {
        return UIColor(rgb: 0xC773C0)
    }
    
    public static var pink: UIColor {
        return UIColor(rgb: 0xE25B9D)
    }
    
    public static var darkGray: UIColor {
        return UIColor(red: 0.149, green: 0.149, blue: 0.149, alpha: 1.000)
    }
    
    public static var darkestGray: UIColor {
        return UIColor(red: 0.0745, green: 0.0745, blue: 0.0745, alpha: 1.000)
    }
}
