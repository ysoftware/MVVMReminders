//
//  Queries.swift
//  MVVMReminders
//
//  Created by ysoftware on 07.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM

class ReminderQuery:Query {

	var page = 0

	// MARK: - Query protocol

	func resetPosition() {
		page = 0
	}

	func advance() {
		page += 1
	}
}
