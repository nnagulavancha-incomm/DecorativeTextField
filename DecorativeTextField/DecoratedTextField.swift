//
//  DecoratedTextField.swift
//  DecorativeTextField
//
//  Created by Naresh Kumar Nagulavancha on 11/7/18.
//  Copyright © 2018 incomm. All rights reserved.
//

import UIKit
@IBDesignable

class DecoratedTextField: UITextField {

	@objc dynamic open var titleFont: UIFont = .systemFont(ofSize: 13) {
		didSet {
			updateTitleLabel()
		}
	}

	@IBInspectable dynamic open var titleColor: UIColor = .gray {
		didSet {
			updateTitleColor()
		}
	}

	@IBInspectable dynamic open var lineHeight: CGFloat = 1{
		didSet {
			updateLineView()
		}
	}

	@IBInspectable dynamic open var lineColor: UIColor = .lightGray {
		didSet {
			updateColors()
		}
	}


	@IBInspectable dynamic open var errorColor: UIColor = .red {
		didSet {
			updateColors()
		}
	}

	@IBInspectable open var hasErrorMessage: Bool = false {
		didSet {
			updateColors()
			updateTitleLabel()
		}
	}

	@IBInspectable open var errorMessage: String? {
		didSet {
			updateColors()
			updateTitleLabel()
		}
	}

	@IBInspectable var placeHolderTextColor: UIColor? {
		set {
			let placeholderText = self.placeholder != nil ? self.placeholder! : ""
			attributedPlaceholder = NSAttributedString(string:placeholderText, attributes:[NSAttributedString.Key.foregroundColor: newValue!])
		}
		get{
			//TODO: Change with attributed placeholder color
			return UIColor.lightGray
		}
	}


	@IBInspectable dynamic var leftImageScale: CGFloat = 0.7 {
		didSet {
			updateLeftImageView()
		}
	}

	@IBInspectable dynamic var rightViewScale: CGFloat = 0.7{
		didSet {
			updateRightView()
		}
	}

	@IBInspectable dynamic var inputIndent: CGFloat = 1 {
		didSet {
			setNeedsLayout()
		}
	}

	@IBInspectable dynamic var imagePadding: CGFloat = 3 {
		didSet {
			setNeedsLayout()
		}
	}

	@IBInspectable dynamic var leftImage: UIImage? = nil {
		didSet {
			updateLeftImageView()
		}
	}

	@IBInspectable dynamic var rightAccessoryView: UIView? = nil {
		didSet {
			updateRightView()
		}
	}

	// TODO: implement right accessory image

	@IBInspectable dynamic var rightActionImage: UIImage? = nil

	@objc dynamic open var titleFadeInDuration: TimeInterval = 0.2

	@objc dynamic open var titleFadeOutDuration: TimeInterval = 0.3

	@IBInspectable dynamic var shouldDisablePlaceholderAnimation: Bool = false {
		didSet {
			updateTitleLabel()
		}
	}

	open var lineView: UIView!

	open var titleLabel: UILabel!

	open var leftImageView:UIImageView!

	open var accessoryView: UIView!

	override init(frame: CGRect) {
		super.init(frame: frame)
		init_DecorativeTextField()
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		init_DecorativeTextField()
	}

	func init_DecorativeTextField() {
		borderStyle = .none
		createTitleLabel()
		createLineView()
		addEditingChangedObserver()
		createLeftImageView()
		createAccessoryView()
	}

	override func draw(_ rect: CGRect) {
		super.draw(rect)
		updateLeftImageView()
		updateRightView()
	}

	fileprivate func addEditingChangedObserver() {
		self.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
	}

	@objc open func editingChanged() {
		updateTitleLabel(true)
	}


	func createLeftImageView() {
		let leftImageView = UIImageView()
		leftImageView.contentMode = .scaleAspectFit
		addSubview(leftImageView)
		self.leftImageView = leftImageView
	}
	func createAccessoryView() {
		let accessoryView = UIView()
		accessoryView.backgroundColor = .clear
		addSubview(accessoryView)
		self.accessoryView = accessoryView
	}

	fileprivate func createTitleLabel() {
		if titleLabel == nil {
			let titleLabel = UILabel()
			titleLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
			titleLabel.font = titleFont
			titleLabel.alpha = 0.0
			titleLabel.textColor = titleColor
			addSubview(titleLabel)
			self.titleLabel = titleLabel
		}
	}

	fileprivate func createLineView() {

		if lineView == nil {
			let lineView = UIView()
			lineView.isUserInteractionEnabled = false
			lineView.frame = CGRect(x: 0, y: bounds.size.height - lineHeight
				, width: bounds.size.width, height: lineHeight)
			lineView.backgroundColor = lineColor
			self.lineView = lineView
		}

		lineView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
		addSubview(lineView)
	}

	open func titleHeight() -> CGFloat {
		if let titleLabel = titleLabel,
			let font = titleLabel.font {
			return font.lineHeight
		}
		return 15.0
	}

	fileprivate func updateTitleColor() {
		guard let titleLabel = titleLabel else {
			return
		}
		titleLabel.textColor = titleColor
	}

	fileprivate func updateTitleLabel(_ animated: Bool = false) {

		if shouldDisablePlaceholderAnimation {
			titleLabel = nil
		} else {
			createTitleLabel()
		}

		guard let titleLabel = titleLabel else {
			return
		}

		if let errorMessage = errorMessage, errorMessage.count > 0 && hasErrorMessage {
			titleLabel.text = errorMessage
		} else {
			titleLabel.text = placeholder
		}
		titleLabel.font = titleFont
		titleLabel.frame.origin = CGPoint(x: getCurrentX(), y: 0)

		updateTitleVisibility(animated)
	}

	open func updateColors() {

		if let titleLabel = titleLabel {
			if  let errorMessage = errorMessage, errorMessage.count > 0  && hasErrorMessage {
				titleLabel.textColor = errorColor
			} else {
				titleLabel.textColor = placeHolderTextColor
			}
		}


		guard let lineView = lineView else {
			return
		}

		lineView.backgroundColor = hasErrorMessage ? errorColor : lineColor
	}

	open func updateLineView() {


		guard let lineView = lineView else {
			return
		}

		lineView.frame = CGRect(x: 0, y: bounds.size.height - lineHeight
			, width: bounds.size.width, height: lineHeight)
		updateColors()
	}

	func updateLeftImageView() {

		if let leftImage = leftImage{
			let iconSize = self.bounds.height * leftImageScale
			leftImageView.image = leftImage
			leftImageView.frame = CGRect(x: inputIndent, y: viewHeight.half - iconSize.half - 1, width: iconSize, height: iconSize);
			leftImageView.isHidden = false
		} else {
			leftImageView.isHidden = true
		}
	}

	func updateRightView() {
		guard let rightAccessoryView = rightAccessoryView else {
			accessoryView.isHidden = true
			return
		}
		for sv in accessoryView.subviews {
			sv.removeFromSuperview()
		}

		let iconSize = self.bounds.height * rightViewScale

		let rightFrame = CGRect(x: viewWidth - iconSize, y: viewHeight.half - iconSize.half - lineHeight, width: iconSize, height: iconSize)
		accessoryView.frame = rightFrame
		rightAccessoryView.frame = accessoryView.bounds
		accessoryView.addSubview(rightAccessoryView)
		accessoryView.isHidden = false
	}

	open func isTitleVisible() -> Bool {
		return hasText
	}


	fileprivate func updateTitleVisibility(_ animated: Bool = false, completion: ((_ completed: Bool) -> Void)? = nil) {
		let alpha: CGFloat = isTitleVisible() ? 1.0 : 0.0
		let frame: CGRect = titleLabelRectForBounds(bounds, editing: isTitleVisible())
		let updateBlock = { () -> Void in
			self.titleLabel.alpha = alpha
			self.titleLabel.frame = frame
		}
		if animated {
			let animationOptions: UIView.AnimationOptions = .curveEaseOut
			let duration = isTitleVisible() ? 0.3 : 0.3
			UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: { () -> Void in
				updateBlock()
			}, completion: completion)
		} else {
			updateBlock()
			completion?(true)
		}
	}

	open func titleLabelRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {
		if editing {
			return CGRect(x: getCurrentX(), y: 0, width: bounds.size.width - getCurrentX() - getXfromEnd(), height: titleHeight())
		}
		return CGRect(x: getCurrentX(), y: titleHeight(), width: bounds.size.width - getCurrentX() - getXfromEnd(), height: titleHeight())
	}

	override open func textRect(forBounds bounds: CGRect) -> CGRect {
		let superRect = super.textRect(forBounds: bounds)
		let titleHeight = self.titleHeight()

		let rect = CGRect(
			x: superRect.origin.x + getCurrentX(),
			y: titleHeight,
			width: superRect.size.width - getCurrentX() - getXfromEnd(),
			height: superRect.size.height - titleHeight - lineHeight
		)
		return rect
	}

	override open func editingRect(forBounds bounds: CGRect) -> CGRect {
		let superRect = super.editingRect(forBounds: bounds)
		let titleHeight = self.titleHeight()

		let rect = CGRect(
			x: superRect.origin.x + getCurrentX(),
			y: titleHeight,
			width: superRect.size.width - getCurrentX() - getXfromEnd(),
			height: superRect.size.height - titleHeight - lineHeight
		)
		return rect
	}

	override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {

		let rect = CGRect(
			x: bounds.origin.x + getCurrentX(),
			y: titleHeight(),
			width: bounds.size.width - getCurrentX() - getXfromEnd(),
			height: bounds.size.height - titleHeight() - lineHeight
		)
		return rect
	}

	func getXfromEnd() -> CGFloat {
		if let _ = rightAccessoryView {
			return accessoryView.viewWidth
		}
		return 0
	}

	func getCurrentX() -> CGFloat {
		var currentX : CGFloat = inputIndent

		if let _ = leftImage {
			currentX = inputIndent + leftImageView.viewWidth + imagePadding
		}

		return currentX
	}
}

extension UIView {
	var ending: CGPoint { return CGPoint(x: frame.origin.x + frame.width, y: frame.origin.y + frame.height) }
	var viewWidth: CGFloat { return frame.width }
	var viewHeight: CGFloat { return frame.height }
}

extension CGFloat {
	var half: CGFloat { return self / 2 }
	var double: CGFloat { return self * 2 }
}
