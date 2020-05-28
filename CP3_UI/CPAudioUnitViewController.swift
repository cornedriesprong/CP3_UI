//
//  CPAudioUnitViewController.swift
//  CP3_UI
//
//  Created by Corné on 23/05/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

import CoreAudioKit

open class CPAudioUnitViewController: AUViewController {
    
    public var audioUnit: AUAudioUnit? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.configureViewController()
            }
        }
    }
    
    open func configureViewController() {
    }
    
    public func setViewController(_ viewController: UIViewController) {
        
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        viewController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        viewController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        viewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        viewController.didMove(toParent: self)
    }
}
