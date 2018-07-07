//
//  Model.swift
//  MVVMReminders
//
//  Created by ysoftware on 06.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

class Task: Codable {

	var order:Int! = 0
	var id:String
	var name:String
	var isFinished:Bool = false
	var reminderId:String

	init(with name:String, reminderId:String) {
		self.id = UUID().uuidString
		self.reminderId = reminderId
		self.name = name
	}
}

extension Task: Comparable {

	static func < (lhs: Task, rhs: Task) -> Bool {
		return lhs.order < rhs.order
	}
}

extension Task: Equatable {
	
	static func == (lhs: Task, rhs: Task) -> Bool {
		return lhs.id == rhs.id
	}
}

extension Task: CustomDebugStringConvertible {

	var debugDescription: String {
		return "Task (\(order!)): \"\(name)\", finished: \(isFinished))"
	}
}
