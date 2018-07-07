//
//  Extensions.swift
//  MVVMReminders
//
//  Created by ysoftware on 07.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

public extension Encodable {

	public var dictionary:[String:Any] {
		do {
			let data = try JSONEncoder().encode(self)
			let value = try JSONDecoder().decode(JSONAny.self, from: data)
			if let value_ = value.value as? [String:Any] {
				return value_
			}
			else {
				print("encodable.dictionary: something went wrong and needs debugging")
				return [:]
			}
		}
		catch let error {
			print("encodable.dictionary: \(error)")
			return [:]
		}
	}
}

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

extension Dictionary where Key == String {

	func parse<T:Decodable>(object class:T.Type) -> T? {
		return parse()
	}

	func parse<T:Decodable>() -> T? {
		do {
			let data = try JSONSerialization.data(withJSONObject: self)
			return try JSONDecoder().decode(T.self, from: data)
		}
		catch {
			print("search: parse \(T.self): \(error)")
			return nil
		}
	}
}
