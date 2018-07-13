//
//  Single.swift
//  MVVMReminders
//
//  Created by ysoftware on 07.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM

final class TaskViewModel: ViewModel<Task> {

	// MARK: - Methods

	func toggleFinished() {
		guard let model = model else { return }

		// update model
		model.isFinished.toggle()

		// save to storage
		Database.updateTask(model)

		// notify updated
		notifyUpdated()
	}

	// MARK: - Properties

	var name:String {
		return model?.name ?? "Загрузка..."
	}

	var isFinished:String {
		let value = model?.isFinished ?? false
		return value ? "Готово" : "Ожидание"
	}
}
