//
//  Tickable.swift
//  CP3_UI
//
//  Created by Corné on 04/09/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

import Foundation

public protocol Tickable {
    func tick(withPlayheadPosition playheadPosition: Int)
}
