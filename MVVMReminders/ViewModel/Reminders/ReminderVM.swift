//
//  Single.swift
//  MVVMReminders
//
//  Created by ysoftware on 07.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM

final class ReminderViewModel: ViewModel<Reminder> {

	// MARK: - Methods

	func updateTaskCount(added:Bool) {
		guard let model = model else { return }

		// update viewModel
		model.tasksCount += added ? 1 : -1

		// save to storage
		Database.updateReminder(model)

		// notify
		notifyUpdated()
	}

	// MARK: - Properties

	var name:String {
		return model?.name ?? "Загрузка..."
	}

	var tasksCount:String {
		let count = model?.tasksCount ?? 0
		return "Задач: \(count)"
	}
}
