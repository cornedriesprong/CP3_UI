//
//  CPContainerViewController.swift
//  CP3_UI
//
//  Created by Corné on 29/04/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

#if canImport(UIKit)
import UIKit

public enum PanelState {
    case expand, collapse
    
    public var opposite: PanelState {
        switch self {
        case .collapse: return .expand
        case .expand: return .collapse
        }
    }
}

open class CPContainerViewController: UIViewController {
    
    // MARK: - Properties
    
    public lazy var menuNavigationController: UINavigationController = {
        
        let navigationController = UINavigationController()
        navigationController.navigationBar.barStyle = .black
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: Font.font(ofSize: 16)
        ]
        
        return navigationController
    }()

    public lazy var navigationViewController: UINavigationController = {
        
        let navigationController = UINavigationController()
        navigationController.navigationBar.barStyle = .black
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: Font.font(ofSize: 16)
        ]
        
        return navigationController
    }()
    
    private let dimView: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .black
        view.alpha = 0
        
        return view
    }()
    
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        gestureRecognizer.isEnabled = false
        gestureRecognizer.cancelsTouchesInView = true
        
        return gestureRecognizer
    }()
    
    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        gestureRecognizer.isEnabled = false
        gestureRecognizer.cancelsTouchesInView = true
        
        return gestureRecognizer
    }()
    
    private var animator: UIViewPropertyAnimator?
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Life cycle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorTheme.darkGray
        
        addChild(navigationViewController)
        view.addSubview(navigationViewController.view)
        navigationViewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        navigationViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navigationViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        navigationViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        navigationViewController.didMove(toParent: self)
        
        view.addSubview(dimView)
        dimView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        dimView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        dimView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        dimView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        dimView.addGestureRecognizer(panGestureRecognizer)
        dimView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - Selectors
    
    @objc private func didTap(_ sender: UITapGestureRecognizer) {
        collapseMenu()
    }
    
    @objc private func didPan(_ sender: UIPanGestureRecognizer) {
        
        switch sender.state {
        case .began:
            animator = propertyAnimator(forAnimationType: .collapse)
            animator?.startAnimation()
            animator?.pauseAnimation()
            
        case .changed:
            let fraction = (sender.translation(in: self.view).x / CPMenuViewController.width) * -1
            animator?.fractionComplete = fraction
            
        case .ended, .cancelled:
            if sender.velocity(in: self.view).x > 0 || animator!.fractionComplete < 0.2 {
                animator?.isReversed = true
                animator?.continueAnimation(withTimingParameters: nil, durationFactor: 0.5)
            } else {
                let timingParameters = UISpringTimingParameters(dampingRatio: 0.6)
                animator?.continueAnimation(withTimingParameters: timingParameters, durationFactor: 1)
            }
            
        default:
            break
        }
    }
    
    // MARK: - Helpers
    
    private func propertyAnimator(forAnimationType animationType: PanelState) -> UIViewPropertyAnimator {
        
        switch animationType {
        case .expand:
            let animator = UIViewPropertyAnimator(
                duration: 0.2,
                curve: .easeOut,
                animations: { [unowned self] in
                    self.menuNavigationController.view.transform = CGAffineTransform.identity.translatedBy(
                        x: CPMenuViewController.width,
                        y: 0)
                    self.dimView.alpha = 0.6
            })
            
            animator.addCompletion { position in
                
                if position == .end {
                    self.menuNavigationController.didMove(toParent: self)
                    self.panGestureRecognizer.isEnabled = true
                    self.tapGestureRecognizer.isEnabled = true
                }
            }
            
            return animator
            
        case .collapse:
            
            let animator = UIViewPropertyAnimator(
                duration: 0.2,
                curve: .easeOut,
                animations: { [unowned self] in
                    self.menuNavigationController.view.transform = CGAffineTransform.identity
                    self.dimView.alpha = 0
            })
            
            animator.addCompletion { position in
                
                if position == .end {
                    self.menuNavigationController.view.removeFromSuperview()
                    self.menuNavigationController.removeFromParent()
                    self.panGestureRecognizer.isEnabled = false
                    self.tapGestureRecognizer.isEnabled = false
                    self.menuNavigationController.popToRootViewController(animated: false)
                }
            }
            
            return animator
        }
    }
    
    public func expandMenu() {
        
        addChild(menuNavigationController)
        view.addSubview(menuNavigationController.view)
        
        menuNavigationController.view.frame = CGRect(
            x: -CPMenuViewController.width,
            y: 0,
            width: CPMenuViewController.width,
            height: view.frame.height)
        
        animator = propertyAnimator(forAnimationType: .expand)
        animator?.startAnimation()
    }
    
    public func collapseMenu() {
        
        self.menuNavigationController.willMove(toParent: nil)
        
        animator = propertyAnimator(forAnimationType: .collapse)
        animator?.startAnimation()
    }
}
#endif
