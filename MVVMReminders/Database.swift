//
//  Database.swift
//  MVVM
//
//  Created by ysoftware on 06.07.2018.
//

import FirebaseFirestore
import FirestoreHelper

class Database {

	fileprivate static let remindersRef = "reminders"
	fileprivate static let tasksRef = "tasks"

	fileprivate static let remindersFile = "Reminders.dat"
	fileprivate static let tasksFile = "Tasks.data"

	// MARK: - Tasks

	static func getTasks(forReminderId reminderId: String,
						 _ completion: @escaping ([Task])->Void) {
		let ref = Firestore.ref(remindersRef)
			.document(reminderId).collection(tasksRef)
			.order(by: "order", descending: false)
		Firestore.getList(from: ref) { tasks in
			completion(tasks)
		}
	}

	static func updateTask(_ task:Task) {
		ref(for: task).update(with: task)
	}

	static func addTask(_ task:Task) {
		ref(for: task).set(object: task)
	}

	static func deleteTask(_ task:Task) {
		// delete task
		ref(for: task).delete { _ in

			// get remaining tasks
			getTasks(forReminderId: task.reminderId) { tasks in

				// change order
				let ordered = reorder(tasks)

				// save all tasks
				updateTasks(ordered)
			}
		}
	}

	static func moveTask(_ task:Task, to newIndex:Int) {
		// get all tasks
		getTasks(forReminderId: task.reminderId) { tasks in

			guard let currentIndex = tasks.index(of: task) else { return }

			// update task in array
			tasks.forEach { t in
				if newIndex > currentIndex, t.order <= newIndex {
					t.order -= 1
				}
				else if newIndex < currentIndex, t.order >= newIndex {
					t.order += 1
				}
			}
			guard let index = tasks.index(of: task) else { return }
			tasks[index].order = newIndex

			// change order
			let ordered = reorder(tasks)

			// save all tasks
			updateTasks(ordered)
		}
	}

	fileprivate static func reorder(_ tasks:[Task]) -> [Task] {
		var i = 0
		return tasks.sorted().map { t in
			t.order = i
			i += 1
			return t
		}
	}

	fileprivate static func ref(for task:Task) -> DocumentReference {
		return Firestore.ref(remindersRef).document(task.reminderId)
			.collection(tasksRef).document(task.id)
	}

	fileprivate static func updateTasks(_ tasks:[Task]) {
		tasks.forEach { task in
			updateTask(task)
		}
	}

	// MARK: - Reminders

	static func getReminders(with query: ReminderQuery,
							 _ completion: @escaping ([Reminder])->Void) {
		let ref = Firestore.ref(remindersRef)
		Firestore.getList(from: ref,
						  cursor: query.cursor,
						  limit: query.size) { (reminders:[Reminder], cursor) in
			query.cursor = cursor
			completion(reminders)
		}
	}

	static func addReminder(_ reminder:Reminder) {
		ref(for: reminder).set(object: reminder)
	}

	static func deleteReminder(_ reminder:Reminder) {
		ref(for: reminder).delete()
	}

	static func updateReminder(_ reminder:Reminder) {
		ref(for: reminder).update(with: reminder)
	}

	fileprivate static func ref(for reminder:Reminder) -> DocumentReference {
		return Firestore.ref(remindersRef).document(reminder.id)
	}

	fileprivate static func updateReminders(_ reminders:[Reminder]) {
		reminders.forEach { reminder in
			updateReminder(reminder)
		}
	}
}
