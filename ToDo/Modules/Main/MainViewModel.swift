//
//  MainViewModel.swift
//  ToDo
//
//  Created by Антон on 20.07.2022.
//
import UIKit
import Foundation

//MARK: - MainViewModelProtocol

protocol MainViewModelProtocol {
	func reloadTable()
	func goToNewTaskVC()
	var coreDataModel: [Tasks] { get }
	var todayTasksArray: [Tasks] { get }
	var overdueArray: [Tasks] { get }
	var currentArray: [Tasks] { get }
	//var sectionIndex: Int { get }
	var selectionStructArray: [SectionStruct] { get }
	func coreDataDeleteCell(indexPath: IndexPath, presentedViewController: UIViewController, taskModel: [Tasks])
	func coreDataFetch()
	func visualViewCell(items: Tasks, cell: CustomCell, indexPath: IndexPath)
}




//MARK: - MainViewModel

class MainViewModel {
	var sectionIndex: Int?
	private weak var output: MainOutput?
	let coreDataMethods = CoreDataMethods()
	let visualViewCell = VisualViewCell()
	let taptic = TapticFeedback()
	weak var view: Main?
	init(output: MainOutput) {
		self.output = output
	}
}

extension MainViewModel: MainViewModelProtocol {
	
//	{
//		get {
//			0
//		} set {
//
//		}
//	}
	
	func tableViewReload() {
		DispatchQueue.main.async { [weak self] in
			self!.reloadTable()
		}
	}
	
	func reloadTable() {
		view?.tableView.reloadData()
	}
	
	func visualViewCell(items: Tasks, cell: CustomCell, indexPath: IndexPath) {
		visualViewCell.visualViewCell(items: items, cell: cell, indexPath: indexPath)
		let button = cell.buttonCell
		sectionIndex = indexPath.section
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
	
	var overdueArray: [Tasks] {
		get {
			coreDataMethods.overdueArray
		}
	}
	
	var currentArray: [Tasks] {
		get {
			coreDataMethods.currentArray
		}
	}
	
	var coreDataModel: [Tasks] {
		get {
			coreDataMethods.coreDataModel
		}
	}
	
	var selectionStructArray: [SectionStruct] {
		get {
			coreDataMethods.selectionStructArray
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
		let model: Tasks
		guard currentArray.count >= sender.tag else { return }
		guard overdueArray.count >= sender.tag else { return }
		switch sectionIndex {
		case 0: model = currentArray[sender.tag]
		case 1: model = overdueArray[sender.tag]
		default: model = coreDataModel[sender.tag]
		}
		print(sectionIndex ?? "nil")
//			let model = coreDataModel[sender.tag]
			model.check.toggle()
			do {
				try context.save()
			} catch let error as NSError {
				print(error.localizedDescription)
			}
			NotificationCenter.default.post(name: Notification.Name("TableViewReloadData"), object: .none)
		}
	}
