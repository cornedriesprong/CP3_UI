//
//  ShowErrorAlert.swift
//  CP3_UI
//
//  Created by Corné on 29/04/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

#if canImport(UIKit)
import UIKit

public protocol ShowErrorAlert {
    func showAlert(withError error: Error)
}

extension ShowErrorAlert where Self: UIViewController {
    
    public func showAlert(withText text: String) {
        
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    public func showAlert(withError error: Error) {
        
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    public func showAlert(withTitle title: String, message: String) {
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    public func showWarningAlert(withText text: String, completion: @escaping (_ isConfirmed: Bool) -> Void) {
        
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .destructive) { _ in
            completion(true)
            alert.dismiss(animated: true)
        }
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel) { _ in
            completion(false)
            alert.dismiss(animated: true)
        }
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}
#endif
