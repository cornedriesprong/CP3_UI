//
//  AddItemCell.swift
//  CP3_UI
//
//  Created by Corné on 16/04/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

#if canImport(UIKit)
import UIKit

public final class CPAddItemCell: UICollectionViewCell {

    // MARK: - Properties
    
    public static let reuseIdentifier = String(describing: CPAddItemCell.self)
    
    private lazy var imageView: UIImageView = {
        
        let bundle = Bundle(for: type(of: self))
        let image = UIImage(named: "plus", in: bundle, compatibleWith: nil)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    private func configure() {
        
        backgroundColor = .clear
        
        addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
#endif
