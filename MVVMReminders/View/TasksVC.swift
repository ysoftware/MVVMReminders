//
//  TasksVC.swift
//  MVVMReminders
//
//  Created by ysoftware on 06.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit
import MVVM

class TasksViewController: UIViewController {

	@IBOutlet weak var tableView:UITableView!
	
	var viewModel:TaskArrayViewModel!
	var editButton:UIBarButtonItem!

	override func viewDidLoad() {
		super.viewDidLoad()

		let addButton = UIBarButtonItem(barButtonSystemItem: .add,
										target: self,
										action: #selector(add))

		editButton = UIBarButtonItem(title: "Править",
									 style: .plain,
									 target: self,
									 action: #selector(toggleEditMode))

		navigationItem.rightBarButtonItems = [addButton, editButton]
		navigationItem.title = viewModel.reminderViewModel?.name ?? "Задачи"

		viewModel.delegate = self
		viewModel.reloadData()
	}

	@objc func toggleEditMode(_ sender:Any) {

		tableView.isEditing.toggle()
		editButton.title = tableView.isEditing ? "Готово" : "Править" 

		if let indexes = tableView.indexPathsForVisibleRows {
			tableView.reloadRows(at: indexes, with: .automatic)
		}

		// save
		if !tableView.isEditing {

		}
	}

	@objc func add(_ sender:Any) {
		let alert = UIAlertController(title: "Название новой задачи",
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
			self.viewModel.createTask(withName: name)
		})
		alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
		present(alert, animated: true, completion: nil)
	}
}

extension TasksViewController: ArrayViewModelDelegate {

	func didAddElements(at indexes: [Int]) {
		tableView.insertRows(at: indexes.map { IndexPath(row: $0, section: 0) }, with: .automatic)
	}

	func didUpdateElements(at indexes: [Int]) {
		tableView.reloadRows(at: indexes.map { IndexPath(row: $0, section: 0) }, with: .automatic)
	}

	func didDeleteElements(at indexes: [Int]) {
		tableView.deleteRows(at: indexes.map { IndexPath(row: $0, section: 0) }, with: .automatic)
	}

	func didMoveElement(at startIndex: Int, to endIndex: Int) {
		tableView.reloadData()
		// TO-DO: что происходит? почему раньше работало с этим, но теперь с Firebase - нет?
//		tableView.moveRow(at: IndexPath(row: startIndex, section: 0),
//						  to: IndexPath(row: endIndex, section: 0))
	}

	func didUpdateData() {
		tableView.reloadData()
	}
}

extension TasksViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView,
				   numberOfRowsInSection section: Int) -> Int {
		return viewModel.numberOfItems
	}

	func tableView(_ tableView: UITableView,
				   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
												 for: indexPath)
		let reminder = viewModel.item(at: indexPath.row)
		cell.setup(with: reminder)
		return cell
	}
}

extension TasksViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		viewModel.item(at: indexPath.row).toggleFinished()
	}

	func tableView(_ tableView: UITableView,
				   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
		-> UISwipeActionsConfiguration? {

			let deleteAction = UIContextualAction(
				style: .destructive,
				title: "Удалить") { _, _, completionHandler in
					self.viewModel.deleteTask(at: indexPath.row)
					completionHandler(true)
			}
			return UISwipeActionsConfiguration(actions: [deleteAction])
	}

	func tableView(_ tableView: UITableView,
				   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
		return .none
	}

	func tableView(_ tableView: UITableView,
				   moveRowAt sourceIndexPath: IndexPath,
				   to destinationIndexPath: IndexPath) {
		viewModel.moveTask(at: sourceIndexPath.row, to: destinationIndexPath.row)
	}

	func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		return true
	}
}
