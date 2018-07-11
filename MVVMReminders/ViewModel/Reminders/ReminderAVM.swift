//
//  Reminders.swift
//  MVVMReminders
//
//  Created by ysoftware on 06.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM

class ReminderArrayViewModel: ArrayViewModel<Reminder, ReminderViewModel, ReminderQuery> {

	override init() {
		super.init()
		query = ReminderQuery()
	}

	// MARK: - Methods

	@discardableResult
	func createReminder(withName name:String) -> ReminderViewModel {

		// create
		let reminder = Reminder(with: name)
		let reminderViewModel = ReminderViewModel(reminder)

		// save to storage
		Database.addReminder(reminder)

		// add to viewModel
		append(reminderViewModel)

		return reminderViewModel
	}

	func deleteReminder(at index:Int) {
		
		// find
		let reminderViewModel = item(at: index)
		guard let model = reminderViewModel.model else { return }

		// delete from storage
		Database.deleteReminder(model)

		// delete in viewModel
		delete(at: index)
	}

	// MARK: - Data fetching

	override func fetchData(_ query: ReminderQuery?,
							_ block: @escaping ([Reminder]) -> Void) {
		guard let query = query else { return block([]) }
		Database.getReminders(with: query) { reminders, cursor in
			query.cursor = cursor
			block(reminders)
		}
	}
}
