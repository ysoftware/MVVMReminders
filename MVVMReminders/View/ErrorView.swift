//
//  ErrorView.swift
//  MVVMReminders
//
//  Created by ysoftware on 12.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

@IBDesignable
final public class ErrorView: UIView {

	@IBOutlet weak var errorLabel: UILabel!
	@IBOutlet weak var actionButton: UIButton!

	private var block:(()->Void)?

	@IBAction func act(_ sender: Any) {
		block?()
	}

	public func setup(withMessage message:String,
			   buttonTitle title:String? = nil,
			   _ action: (()->Void)? = nil) {
		errorLabel.text = message
		if let title = title, let action = action {
			self.block = action
			actionButton.isHidden = false
			actionButton.setTitle(title, for: .normal)
		}
		else {
			block = nil
			actionButton.isHidden = true
		}
	}

	// MARK: - Initialization

	override public init(frame: CGRect) {
		super.init(frame: frame)
		fromNib()
	}

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		fromNib()
	}
}
