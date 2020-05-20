//
//  GridResizingCell.swift
//  cykle
//
//  Created by Corné on 28/09/2018.
//  Copyright © 2018 CP3. All rights reserved.
//

import UIKit

public protocol GridResizingCellDelegate: class {
    func addStep()
    func removeStep()
}

final public class GridResizingCell: UICollectionReusableView {

    // MARK: - Static properties

    public static let width: CGFloat = 22

    // MARK: - Private properties

    private lazy var draggerImageView: UIImageView = {

        let bundle = Bundle(for: type(of: self))
        let image = UIImage(named: "dragger", in: bundle, compatibleWith: nil)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private var previousDragOffset = 0
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)

    // MARK: - Properties

    public var draggingThreshold: CGFloat!

    public weak var delegate: GridResizingCellDelegate?

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
        
        addSubview(draggerImageView)
        draggerImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        draggerImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        let panGestureRecognizer = UIPanGestureRecognizer(
            target: self,
            action: #selector(didPan))
        addGestureRecognizer(panGestureRecognizer)
    }

    // MARK: - Selectors

    @objc private func didPan(_ sender: UIPanGestureRecognizer) {

        switch sender.state {
        case .began:
            feedbackGenerator.prepare()

        case .changed:

            let dragOffset = Int(ceil(sender.translation(in: self).x / draggingThreshold))

            guard previousDragOffset != dragOffset else {
                return
            }

            if sender.velocity(in: self).x > 0 {
                feedbackGenerator.impactOccurred()
                delegate?.addStep()
                previousDragOffset += 1
            } else {
                feedbackGenerator.impactOccurred()
                delegate?.removeStep()
                previousDragOffset -= 1
            }
            
        default:
            previousDragOffset = 0
        }
    }
}
