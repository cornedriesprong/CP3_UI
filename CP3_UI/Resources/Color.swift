//
//  Color.swift
//  CP3_UI
//
//  Created by Corné on 16/04/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

import UIKit

public final class Color {
    
    public static let allColors = [red, orange, darkOrange, yellowish, mint, grass, green, turqoise, blue, purple, lightPurple, pink]
    
    public static var red: UIColor {
        return UIColor(red: 0.831, green: 0.416, blue: 0.416, alpha: 1.000)
    }
    
    public static var orange: UIColor {
        return UIColor(red: 0.831, green: 0.604, blue: 0.416, alpha: 1.000)
    }
    
    public static var darkOrange: UIColor {
        return UIColor(red: 0.831, green: 0.694, blue: 0.416, alpha: 1.000)
    }
    
    public static var yellowish: UIColor {
        return UIColor(red: 0.831, green: 0.761, blue: 0.416, alpha: 1.000)
    }
    
    public static var mint: UIColor {
        return UIColor(red: 0.831, green: 0.831, blue: 0.416, alpha: 1.000)
    }
    
    public static var grass: UIColor {
        return UIColor(red: 0.647, green: 0.776, blue: 0.388, alpha: 1.000)
    }
    
    public static var green: UIColor {
        return UIColor(red: 0.333, green: 0.667, blue: 0.333, alpha: 1.000)
    }
    
    public static var turqoise: UIColor {
        return UIColor(red: 0.251, green: 0.498, blue: 0.498, alpha: 1.000)
    }
    
    public static var blue: UIColor {
        return UIColor(red: 0.310, green: 0.384, blue: 0.557, alpha: 1.000)
    }
    
    public static var purple: UIColor {
        return UIColor(red: 0.380, green: 0.318, blue: 0.573, alpha: 1.000)
    }
    
    public static var lightPurple: UIColor {
        return UIColor(red: 0.463, green: 0.294, blue: 0.557, alpha: 1.000)
    }
    
    public static var pink: UIColor {
        return UIColor(red: 0.667, green: 0.333, blue: 0.522, alpha: 1.000)
    }
    
    public static var darkGray: UIColor {
        return UIColor(red: 0.149, green: 0.149, blue: 0.149, alpha: 1.000)
    }
    
    public static var darkestGray: UIColor {
        return UIColor(red: 0.0745, green: 0.0745, blue: 0.0745, alpha: 1.000)
    }
}
