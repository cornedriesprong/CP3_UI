//
//  Color.swift
//  CP3_UI
//
//  Created by Corné on 16/04/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

import UIKit
import SwiftUI

public enum ColorTheme: String, CaseIterable {
    case red
    case orange
    case yellow
    case lime
    case green
    case cyan
    case turquoise
    case blue
    case azure
    case purple
    case lilac
    case pink
    
    init(_ name: String) {
        switch name {
        case "red":
            self = .red
        case "orange":
            self = .orange
        case "yellow":
            self = .yellow
        case "lime":
            self = .lime
        case "green":
            self = .green
        case "cyan":
            self = .cyan
        case "turquoise":
            self = .turquoise
        case "blue":
            self = .blue
        case "azure":
            self = .azure
        case "purple":
            self = .purple
        case "lilac":
            self = .lilac
        case "pink":
            self = .pink
        default:
            fatalError("unrecognized color!")
        }
    }
    
    public var color: Color {
        return Color(uiColor)
    }
    
    public var uiColor: UIColor {
        switch self {
        case .red:
            return UIColor(rgb: 0xED5C55)
        case .orange:
            return UIColor(rgb: 0xE4924D)
        case .yellow:
            return UIColor(rgb: 0xFFC836)
        case .lime:
            return UIColor(rgb: 0xACD44F)
        case .green:
            return UIColor(rgb: 0x41B153)
        case .cyan:
            return UIColor(rgb: 0x31C093)
        case .turquoise:
            return UIColor(rgb: 0x51C8C8)
        case .blue:
            return UIColor(rgb: 0x2E9CC6)
        case .azure:
            return UIColor(rgb: 0x6A91D4)
        case .purple:
            return UIColor(rgb: 0xA67CD8)
        case .lilac:
            return UIColor(rgb: 0xC773C0)
        case .pink:
            return UIColor(rgb: 0xE25B9D)
        }
    }
    
    public static var darkGray: UIColor {
        return UIColor(red: 0.149, green: 0.149, blue: 0.149, alpha: 1.000)
    }
    
    public static var darkerGrey: UIColor {
        return UIColor(red: 30, green: 30, blue: 30)
    }
    
    public static var darkestGray: UIColor {
        return UIColor(red: 0.0745, green: 0.0745, blue: 0.0745, alpha: 1.000)
    }
}
