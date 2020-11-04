//
//  SliderCollectionViewCell.swift
//  cykle
//
//  Created by Corné on 25/01/2019.
//  Copyright © 2019 CP3. All rights reserved.
//

import UIKit

public protocol SliderCollectionViewCellDelegate: class {
    func setSliderValue(fromCell cell: SliderCollectionViewCell, to value: CGFloat)
    func didLongPress(fromCell cell: SliderCollectionViewCell, with value: CGFloat)
}

public class SliderCollectionViewCell: UICollectionViewCell {

    // MARK: - Private properties

    private lazy var sliderView = UIView()

    // MARK: - Properties

    override public var isHighlighted: Bool {
        didSet {
            sliderView.backgroundColor = isHighlighted ? UIColor.white : self.color
            backgroundColor = isHighlighted ? UIColor.white.withAlphaComponent(0.25) : self.color.withAlphaComponent(0.25)
        }
    }

    public var value: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    public var color: UIColor! {
        didSet {
            backgroundColor = color.withAlphaComponent(0.25)
            sliderView.backgroundColor = color
        }
    }

    public weak var delegate: SliderCollectionViewCellDelegate?

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
        addSubview(sliderView)
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress))
        addGestureRecognizer(longPressGestureRecognizer)
    }
    
    @objc private func didLongPress(_ sender: UILongPressGestureRecognizer) {
        delegate?.didLongPress(fromCell: self, with: value)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        let height = value * bounds.height
        sliderView.frame = CGRect(
            x: 0,
            y: bounds.height - height,
            width: bounds.width,
            height: height)
    }

    // MARK: - Helpers

    private func setValue(forYPosition yPosition: CGFloat) {

        let newValue = (1 / bounds.height) * (bounds.height - yPosition)
        value = max(0, min(1, newValue))

        delegate?.setSliderValue(fromCell: self, to: value)
    }

    private func toggleScrollLock(isOn: Bool) {

        NotificationCenter.default.post(
            name: Notification.Name("scroll-lock"),
            object: isOn)
    }

    // MARK: - Touches

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let location = touches.first?.location(in: self) else {
            return
        }

        toggleScrollLock(isOn: true)

        setValue(forYPosition: location.y)
    }

    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let location = touches.first?.location(in: self) else {
            return
        }

        setValue(forYPosition: location.y)
    }

    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        toggleScrollLock(isOn: false)
    }

    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        toggleScrollLock(isOn: false)
    }
}
