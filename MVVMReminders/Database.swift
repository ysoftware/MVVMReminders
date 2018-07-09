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

	static func getTasks(forReminderId reminderId: String,
						 _ completion: @escaping ([Task])->Void) {

	}

	static func updateTask(_ task:Task) {

	}

	static func addTask(_ task:Task) {

	}

	static func deleteTask(_ task:Task) {

	}

	static func moveTask(_ task:Task, to newIndex:Int) {

	}

	fileprivate static func updateTasks(_ tasks:[Task]) {

	}

	// MARK: - Reminders

	static func getReminders(offset: Int,
							 size: Int,
							 _ completion: @escaping ([Reminder])->Void) {

	}

	static func addReminder(_ reminder:Reminder) {

	}

	static func deleteReminder(_ reminder:Reminder) {

	}

	static func updateReminder(_ reminder:Reminder) {

	}

	fileprivate static func updateTasks(_ reminders:[Reminder]) {

	}
}
