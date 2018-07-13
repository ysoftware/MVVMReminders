//
//  Reminders.swift
//  MVVMReminders
//
//  Created by ysoftware on 06.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM

final class ReminderArrayViewModel: ArrayViewModel<Reminder, ReminderViewModel, ReminderQuery> {

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

	// firestore doesn't have op cancel, this will do for test
	var loadCount = 0

	override func fetchData(_ query: ReminderQuery?,
							_ block: @escaping ([Reminder], Error?) -> Void) {
		guard let query = query else { return block([], nil) }

		loadCount += 1 // cancel operation hax for test

		Database.getReminders(with: query) { reminders, cursor, error in

			// cancel operation hax for test
			guard self.loadCount > 0 else { return }
			self.loadCount -= 1

			query.cursor = cursor
			block(reminders, error)
		}
	}

	override func cancelLoadOperation() -> Bool {
		loadCount -= 1
		return true
	}
}
