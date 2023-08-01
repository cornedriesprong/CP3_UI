//
//  Font.swift
//  CP3_UI
//
//  Created by Corné on 16/04/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

import UIKit

public enum Font {
    
    public static func header(ofSize size: CGFloat = 15) -> UIFont {
        return UIFont.systemFont(ofSize: size)
    }
    
    public static func font(ofSize size: CGFloat = 15) -> UIFont {
        return UIFont.systemFont(ofSize: size)
    }
    
    public static func fontMedium(ofSize size: CGFloat = 15) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .medium)
    }
    
    public static func fontBold(ofSize size: CGFloat = 15) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .bold)
    }
}
