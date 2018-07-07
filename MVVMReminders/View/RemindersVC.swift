//
//  ViewController.swift
//  MVVMReminders
//
//  Created by ysoftware on 06.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit
import MVVM

class RemindersViewController: UIViewController {

	@IBOutlet weak var tableView:UITableView!

	let viewModel = ReminderArrayViewModel()
	var reminderViewModelToOpenInSegue:ReminderViewModel?

	override func viewDidLoad() {
		super.viewDidLoad()

		let addButton = UIBarButtonItem(barButtonSystemItem: .add,
										target: self,
										action: #selector(add))
		navigationItem.rightBarButtonItem = addButton
		
		viewModel.delegate = self
		viewModel.reloadData()
	}

	@objc func add(_ sender:Any) {
		let alert = UIAlertController(title: "Название нового напоминания",
									   message: nil, preferredStyle: .alert)
		var nameField:UITextField!
		alert.addTextField { textField in
			nameField = textField
			nameField.autocapitalizationType = .sentences
		}
		alert.addAction(UIAlertAction(title: "Добавить", style: .default) { _ in
			guard let name = nameField.text?.trimmingCharacters(in: .whitespaces),
				name.count > 2
				else { return }
			self.viewModel.createReminder(withName: name)
		})
		alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
		present(alert, animated: true, completion: nil)
	}

	func openReminder(_ reminderViewModel:ReminderViewModel) {
		reminderViewModelToOpenInSegue = reminderViewModel
		performSegue(withIdentifier: "TasksViewController", sender: self)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let viewController = segue.destination as? TasksViewController,
			let (reminderViewModelToOpenInSegue) = reminderViewModelToOpenInSegue
			else { return }
		viewController.viewModel = TaskArrayViewModel(reminderViewModelToOpenInSegue)
		self.reminderViewModelToOpenInSegue = nil
	}
}

extension RemindersViewController: ArrayViewModelDelegate {

	func didAddElements(at indexes: [Int]) {
		tableView.insertRows(at: indexes.map { IndexPath(row: $0, section: 0) }, with: .automatic)
	}

	func didUpdateElements(at indexes: [Int]) {
		tableView.reloadRows(at: indexes.map { IndexPath(row: $0, section: 0) }, with: .automatic)
	}

	func didDeleteElements(at indexes: [Int]) {
		tableView.deleteRows(at: indexes.map { IndexPath(row: $0, section: 0) }, with: .automatic)
	}

	func didUpdateData() {
		tableView.reloadData()
	}
}

extension RemindersViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView,
				   numberOfRowsInSection section: Int) -> Int {
		return viewModel.numberOfItems
	}

	func tableView(_ tableView: UITableView,
				   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
												 for: indexPath)
		let reminder = viewModel.item(at: indexPath.row, shouldLoadMore: true)
		cell.setup(with: reminder)
		return cell
	}
}

extension RemindersViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		openReminder(viewModel.item(at: indexPath.row))
	}

	func tableView(_ tableView: UITableView,
				   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
		-> UISwipeActionsConfiguration? {

			let deleteAction = UIContextualAction(
				style: .destructive,
				title: "Удалить") { _, _, completionHandler in
					self.viewModel.deleteReminder(at: indexPath.row)
					completionHandler(true)
			}
			return UISwipeActionsConfiguration(actions: [deleteAction])
	}
}
