//
//  CPValueControl.swift
//  cykle
//
//  Created by Corné on 24/05/2019.
//  Copyright © 2019 CP3. All rights reserved.
//

#if canImport(UIKit)
import UIKit

public final class CPValueControl: UIControl {

    // MARK: - Private properties

    private lazy var decreaseButton: UIButton = {

        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false

        let image = UIImage(named: "back", in: Bundle.module, compatibleWith: nil)
        button.setImage(image, for: .normal)

        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true

        button.addTarget(
            self,
            action: #selector(decreaseButtonTapped),
            for: .touchUpInside)

        return button
    }()

    private lazy var valueLabel: UILabel = {

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        label.font = Font.font()
        label.textColor = .white

        return label
    }()

    private lazy var increaseButton: UIButton = {

        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false

        let image = UIImage(named: "back", in: Bundle.module, compatibleWith: nil)
        button.setImage(image, for: .normal)
        button.transform = CGAffineTransform.identity.rotated(by: .pi)

        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true

        button.addTarget(
            self,
            action: #selector(increaseButtonTapped),
            for: .touchUpInside)

        return button
    }()

    private var previousDragOffset = 0
    private let feedbackGenerator = UISelectionFeedbackGenerator()

    // MARK: - Properties

    public var value = 0 {
        didSet {
            valueLabel.text = "\(value)"
            actionCallback?(value)
        }
    }

    public var minimumValue = 1
    public var maximumValue = 16
    public var increment = 1
    public var actionCallback: ((Int) -> Void)?

    // MARK: - Initialization

    public override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    private func configure() {

        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: 126).isActive = true
        heightAnchor.constraint(equalToConstant: 44).isActive = true

        addSubview(valueLabel)
        valueLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        let arrowMargin: CGFloat = 38
        addSubview(decreaseButton)
        decreaseButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -arrowMargin).isActive = true
        decreaseButton.centerYAnchor.constraint(equalTo: valueLabel.centerYAnchor).isActive = true

        addSubview(increaseButton)
        increaseButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: arrowMargin).isActive = true
        increaseButton.centerYAnchor.constraint(equalTo: valueLabel.centerYAnchor).isActive = true

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        addGestureRecognizer(panGestureRecognizer)
    }

    // MARK: - Selectors

    @objc private func decreaseButtonTapped(_ sender: UIButton) {

        guard value > minimumValue else {
            return
        }

        value -= increment
    }

    @objc private func increaseButtonTapped(_ sender: UIButton) {

        guard value <= maximumValue - 1 else {
            return
        }

        value += increment
    }

    @objc private func didPan(_ sender: UIPanGestureRecognizer) {

        switch sender.state {
        case .began:
            feedbackGenerator.prepare()

        case .changed:

            let dragOffset = Int(ceil(sender.translation(in: self).x / 25))

            guard previousDragOffset != dragOffset else {
                return
            }

            if sender.velocity(in: self).x > 0 {
                
                guard value < maximumValue else { return }
                
                feedbackGenerator.selectionChanged()
                increaseButtonTapped(increaseButton)
                previousDragOffset += 1
                
            } else if sender.velocity(in: self).x < 0 {
                
                guard value > minimumValue else { return }
                
                feedbackGenerator.selectionChanged()
                decreaseButtonTapped(decreaseButton)
                previousDragOffset -= 1
            }

        default:
            previousDragOffset = 0
        }
    }
}
#endif
