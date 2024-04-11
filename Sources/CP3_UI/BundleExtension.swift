//
//  BundleExtension.swift
//
//
//  Created by Corné on 4/11/24.
//

import Foundation

public class CP3_UIBundle {
    public static let bundle: Bundle = {
        let bundleName = "CP3_UI_CP3_UI"
        let candidates = [
            Bundle.main.resourceURL,
            Bundle(for: CP3_UIBundle.self).resourceURL,
            Bundle.main.bundleURL,
        ]
        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }
        fatalError("Unable to find bundle named \(bundleName)")
    }()
}
