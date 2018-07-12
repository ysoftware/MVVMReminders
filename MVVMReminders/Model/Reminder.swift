//
//  Reminder.swift
//  MVVMReminders
//
//  Created by ysoftware on 06.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

class Reminder: Codable {

	var name:String
	
	var tasksCount = 0
	var id = UUID().uuidString
	var timestamp = Date().timeIntervalSince1970

	init(with name:String) {
		self.name = name
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
