//
//  Font.swift
//  CP3_UI
//
//  Created by Corné on 16/04/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

import UIKit

enum Font {
    
    static func font(ofSize size: CGFloat = 15) -> UIFont {
        return UIFont.systemFont(ofSize: size)
    }
    
    static func fontBold(ofSize size: CGFloat = 15) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .bold)
    }
}
