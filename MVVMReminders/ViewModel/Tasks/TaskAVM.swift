//
//  ViewModel.swift
//  MVVMReminders
//
//  Created by ysoftware on 06.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM
import Result

final class TaskArrayViewModel: SimpleArrayViewModel<Task, TaskViewModel> {

	// tasks depend on reminders in this example
	weak var reminderViewModel:ReminderViewModel?

	required init(_ reminderViewModel:ReminderViewModel) {
		self.reminderViewModel = reminderViewModel
	}

	// MARK: - Methods

	@discardableResult
	func createTask(withName name:String) -> TaskViewModel? {
		guard let model = reminderViewModel?.model else { return nil }

		// create
		let task = Task(with: name, reminderId: model.id)
		task.order = reminderViewModel?.model?.tasksCount ?? 0
		let taskViewModel = TaskViewModel(task)

		// save to storage
		Database.addTask(task)

		// update reminder viewModel
		reminderViewModel?.updateTaskCount(added: true)

		// add to viewModel
		append(taskViewModel)

		return taskViewModel
	}

	func moveTask(at index:Int, to newIndex:Int) {

		// find
		let taskViewModel = item(at: index)
		guard let model = taskViewModel.model else { return }

		// update in viewModel
		move(at: index, to: newIndex)

		// update storage
		Database.moveTask(model, to: newIndex)
	}

	func deleteTask(at index:Int) {

		// find
		let taskViewModel = item(at: index)
		guard let model = taskViewModel.model else { return }

		// delete from storage
		Database.deleteTask(model)

		// delete in viewModel
		delete(at: index)

		// update reminder viewModel
		reminderViewModel?.updateTaskCount(added: false)
	}

	// MARK: - Data fetching

	override func fetchData(_ block: @escaping (Result<[Task], AnyError>) -> Void) {
		guard let model = reminderViewModel?.model else {
			return block(.failure(AnyError(TasksError.noReminderModel)))
		}
		
		Database.getTasks(forReminderId: model.id) { tasks, error in
			if let error = error {
				block(.failure(AnyError(TasksError.other(error))))
			}
			else {
				block(.success(tasks))
			}
		}
	}
}

enum TasksError:Error {

	case other(Error)

	case noReminderModel
}
