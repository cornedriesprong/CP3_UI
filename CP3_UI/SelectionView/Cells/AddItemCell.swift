//
//  AddItemCell.swift
//  CP3_UI
//
//  Created by Corné on 16/04/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

import UIKit

final class AddItemCell: UICollectionViewCell {

    // MARK: - Properties
    
    static let reuseIdentifier = String(describing: AddItemCell.self)
    
    private lazy var imageView: UIImageView = {
        
        let image = UIImage(named: "plus")
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
