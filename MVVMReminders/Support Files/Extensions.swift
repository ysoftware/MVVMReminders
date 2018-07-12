//
//  Extensions.swift
//  MVVMReminders
//
//  Created by ysoftware on 07.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

extension Bool {
	
	mutating func toggle() {
		self = !self
	}
}

extension Array where Element:Equatable {

	@discardableResult
	mutating func remove(object:Element) -> Element {
		let i:Int = index(of: object)!
		return remove(at: i)
	}
}
