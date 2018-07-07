//
//  Database.swift
//  MVVM
//
//  Created by ysoftware on 06.07.2018.
//

import UIKit

class Database {

	fileprivate static let remindersFile = "Reminders.dat"
	fileprivate static let tasksFile = "Tasks.data"

	// MARK: - Tasks

	static func getTasks() -> [Task] {
		guard let dictionary = UserDefaults.standard.array(forKey: tasksFile) as? [[String:Any]]
			else { return [] }
		return dictionary.compactMap { $0.parse() }.sorted()
	}

	static func updateTask(_ task:Task) {
		var all = getTasks()
		let index = all.index(of: task)!
		all[index] = task
		saveTasks(all)
	}

	static func addTask(_ task:Task) {
		var all = getTasks()
		let some = all.filter { $0.reminderId == task.reminderId }
		task.order = some.count
		all.append(task)
		saveTasks(all)
	}

	static func deleteTask(_ task:Task) {
		var all = getTasks()
		all.remove(object: task)

		// update order
		var i = 0
		all = all.map { t in
				if t.reminderId == task.reminderId {
					t.order = i
					i += 1
				}
				return t
		}
		saveTasks(all)
	}

	static func moveTask(_ task:Task, to newIndex:Int) {
		var all = getTasks()
		all.insert(all.remove(object: task), at: newIndex)

		// update order
		var i = 0
		all = all.map { t in
				if t.reminderId == task.reminderId {
					t.order = i
					i += 1
				}
				return t
		}
		saveTasks(all)
	}

	fileprivate static func saveTasks(_ tasks:[Task]) {
		UserDefaults.standard.setValue(tasks.map { $0.dictionary }, forKey: tasksFile)
		UserDefaults.standard.synchronize()
	}

	// MARK: - Reminders

	static func getReminders() -> [Reminder] {
		guard let dictionary = UserDefaults.standard.array(forKey: remindersFile) as? [[String:Any]]
			else { return [] }
		return dictionary.compactMap { $0.parse() }
	}

	static func addReminder(_ reminder:Reminder) {
		var all = getReminders()
		all.append(reminder)
		saveReminders(all)
	}

	static func deleteReminder(_ reminder:Reminder) {
		var all = getReminders()
		all.remove(object: reminder)
		saveReminders(all)
	}

	static func updateReminder(_ reminder:Reminder) {
		var all = getReminders()
		let index = all.index(of: reminder)!
		all[index] = reminder
		saveReminders(all)
	}

	fileprivate static func saveReminders(_ reminders:[Reminder]) {
		UserDefaults.standard.setValue(reminders.map { $0.dictionary }, forKey: remindersFile)
		UserDefaults.standard.synchronize()
	}
}
