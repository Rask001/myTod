//
//  SecondViewModel.swift
//  ToDo
//
//  Created by Антон on 28.08.2022.
//

import UIKit
import Foundation

//MARK: - SecondViewModelProtocol

protocol SecondViewModelProtocol {
	func reloadTable()
	func goToNewTaskVC()
	var coreDataModel: [Tasks] { get }
	var todayTasksArray: [Tasks] { get }
	func coreDataDeleteCell(indexPath: IndexPath, presentedViewController: UIViewController, taskModel: [Tasks])
	func coreDataFetch()
	func visualViewCell(items: Tasks, cell: CustomCell, indexPath: IndexPath)
}




//MARK: - MainViewModel

final class SecondViewModel {
	private weak var output: SecondVCOutput?
	let coreDataMethods = CoreDataMethods()
	let visualViewCell = VisualViewCell()
	let taptic = TapticFeedback()
	weak var view: SecondVC?
	init(output: SecondVCOutput) {
		self.output = output
	}
}

extension SecondViewModel: SecondViewModelProtocol {
	 
	func tableViewReload() {
		DispatchQueue.main.async { [weak self] in
			self!.reloadTable()
		}
	}
	
	func reloadTable() {
		view?.tableView.reloadData()
	}
	
	func visualViewCell(items: Tasks, cell: CustomCell, indexPath: IndexPath) {
		visualViewCell.visualViewCell(items: items, cell: cell)
		let button = cell.buttonCell
		button.tag = indexPath.row
		button.addTarget(self, action: #selector(saveCheckmark(sender:)), for: .touchUpInside)
	}
	
	func coreDataFetch() {
		coreDataMethods.fetchRequest()
	}
	
	var todayTasksArray: [Tasks] {
		get {
			coreDataMethods.todayTasksArray
		}
	}
	
	var coreDataModel: [Tasks] {
		get {
			coreDataMethods.coreDataModel
		}
	}
	
	
	func coreDataDeleteCell(indexPath: IndexPath, presentedViewController: UIViewController, taskModel: [Tasks]) {
		coreDataMethods.deleteCell(indexPath: indexPath, presentedViewController: presentedViewController, tasksModel: taskModel)
	}
	
	func goToNewTaskVC() {
		output?.goToNewTask()
		}
	
		@objc private func saveCheckmark(sender: UIButton) {
			taptic.soft
			let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
			let model = todayTasksArray[sender.tag]
			model.check.toggle()
			do {
				try context.save()
			} catch let error as NSError {
				print(error.localizedDescription)
			}
			NotificationCenter.default.post(name: Notification.Name("TableViewReloadData"), object: .none)
		}
	}
