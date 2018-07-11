//
//  Queries.swift
//  MVVMReminders
//
//  Created by ysoftware on 07.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM
import FirebaseFirestore

class ReminderQuery:MVVM.Query {

	var cursor:DocumentSnapshot?

	// MARK: - Query protocol

	func resetPosition() {
		cursor = nil
	}
}
