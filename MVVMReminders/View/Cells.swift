//
//  Extensions.swift
//  MVVMReminders
//
//  Created by ysoftware on 06.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

extension UITableViewCell {

	func setup(with viewModel:ReminderViewModel) {
		textLabel?.text = viewModel.name
		detailTextLabel?.text = viewModel.tasksCount
	}

	func setup(with viewModel:TaskViewModel) {
		textLabel?.text = viewModel.name
		detailTextLabel?.text = viewModel.isFinished
	}
}
