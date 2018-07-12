//
//  Extensions.swift
//  MVVMReminders
//
//  Created by ysoftware on 07.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

extension Bool {
	
	mutating func toggle() {
		self = !self
	}
}

extension UIView {

	@discardableResult
	func fromNib<T : UIView>() -> T? {
		guard let view = Bundle.main
			.loadNibNamed(String(describing: type(of: self)),
						  owner: self, options: nil)?[0] as? T else { return nil }
		view.translatesAutoresizingMaskIntoConstraints = false
		addSubview(view)
		NSLayoutConstraint.activate([
			view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			view.topAnchor.constraint(equalTo: self.topAnchor)
			])
		return view
	}
}

extension UIViewController {

	func call(title:String = "Внимание!",
			  message:String? = nil,
			  buttonTitle:String = "ОК",
			  completion: (()->Void)? = nil) {
		guard message != nil else { return }

		let string = message
		let alert = UIAlertController(title: title, message: string, preferredStyle: .alert)
		let action = UIAlertAction(title: buttonTitle, style: .default) { _ in
			completion?()
			alert.dismiss(animated: true)
		}
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}
}

extension Array where Element:Equatable {

	@discardableResult
	mutating func remove(object:Element) -> Element {
		let i:Int = index(of: object)!
		return remove(at: i)
	}
}
