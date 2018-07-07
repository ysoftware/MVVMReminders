//
//  Single.swift
//  MVVMReminders
//
//  Created by ysoftware on 07.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM

class ReminderViewModel: ViewModel<Reminder> {

	/// Reminder can be used inside of an array view model
	var reminderArrayViewModel:ReminderArrayViewModel?

	// MARK: - Methods

	func updateTaskCount(added:Bool) {
		guard let model = model else { return }

		// update viewModel
		model.tasksCount += added ? 1 : -1

		// save to storage
		Database.updateReminder(model)

		// notify
		notifyUpdated()
		reminderArrayViewModel?.notifyUpdated(self)
	}

	// MARK: - Properties

	var name:String {
		return model?.name ?? "Загрузка..."
	}

	var tasksCount:String {
		let count = model?.tasksCount ?? 0
		return "Количество задач: \(count)"
	}
}
