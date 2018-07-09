//
//  Reminder.swift
//  MVVMReminders
//
//  Created by ysoftware on 06.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

class Reminder: Codable {

	var id:String
	var name:String
	var tasksCount:Int

	init(with name:String) {
		self.name = name
		id = UUID().uuidString
		tasksCount = 0
	}
}

extension Reminder: Equatable {

	static func == (lhs: Reminder, rhs: Reminder) -> Bool {
		return lhs.id == rhs.id
	}
}

extension Reminder: CustomDebugStringConvertible {

	var debugDescription: String {
		return "Reminder \(name) with \(tasksCount) task(s) (\(id))"
	}
}
