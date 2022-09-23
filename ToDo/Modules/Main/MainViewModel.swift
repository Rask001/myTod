//
//  MainViewModel.swift
//  ToDo
//
//  Created by Антон on 20.07.2022.
//
import UIKit
import Foundation

fileprivate enum Constants {
	static var navigationTitleFont: UIFont { UIFont(name: "Futura", size: 20)!}
}

//MARK: - MainViewModelProtocol

protocol MainViewModelProtocol {
	func reloadTable()
	func goToNewTaskVC()
	func goToDetail()
	func createNavController()
	var coreDataMethods: CoreDataMethods { get }
	var coreDataModel: [Tasks] { get }
	var todayTasksArray: [Tasks] { get }
	var overdueArray: [Tasks] { get }
	var currentArray: [Tasks] { get }
	var completedArray: [Tasks] { get }
	var sectionIndex: Int { get set }
	var selectionStructArray: [SectionStruct] { get }
	func coreDataDeleteCell(indexPath: IndexPath, presentedViewController: UIViewController, taskModel: [Tasks])
	func visualViewCell(items: Tasks, cell: CustomCell, indexPath: IndexPath)
	func editingStyleBody(indexPath: IndexPath)
	func cellForRowAtBody(items: Tasks, key: Int, indexPath: IndexPath) -> Tasks
}




//MARK: - MainViewModel

final class MainViewModel {
	private weak var output: MainOutput?
	internal let coreDataMethods = CoreDataMethods()
	private let visualViewCell = VisualViewCell()
	private let navController = NavigationController()
	private let taptic = TapticFeedback()
	weak var view: Main?
	init(output: MainOutput) {
		self.output = output
	}
}

extension MainViewModel: MainViewModelProtocol {

	internal func createNavController() {
		navController.createNavigationController(viewController: view!, title: "my tasks", font: Constants.navigationTitleFont, textColor: .blackWhite!, backgroundColor: .backgroundColor!, leftItemText: "", rightItemText: "", itemColor: .blackWhite!)
	}
	
	
	var sectionIndex: Int {
		get {
			coreDataMethods.sectionIndex ?? 0
		} set {
			coreDataMethods.sectionIndex = newValue
		}
	}
	
	private func tableViewReload() {
		DispatchQueue.main.async { [weak self] in
			self!.reloadTable()
		}
	}
	
	internal func reloadTable() {
		view?.tableView.reloadData()
	}
	
	internal func visualViewCell(items: Tasks, cell: CustomCell, indexPath: IndexPath) {
		visualViewCell.visualViewCell(items: items, cell: cell)
		let buttonCell = cell.buttonCell
		buttonCell.tag = Helper.createShortIntWithoutStrChar(fromItemsId: items.id)
		sectionIndex = buttonCell.tag
		buttonCell.addTarget(self, action: #selector(saveCheckmark(sender:)), for: .touchUpInside)
	}
	
	internal var todayTasksArray: [Tasks] {
		coreDataMethods.todayTasksArray
	}
	
	internal var overdueArray: [Tasks] {
		coreDataMethods.overdueArray
	}
	
	internal var currentArray: [Tasks] {
		coreDataMethods.currentArray
	}
	
	internal var completedArray: [Tasks] {
		coreDataMethods.completedArray
	}
	
	internal var coreDataModel: [Tasks] {
		coreDataMethods.coreDataModel
	}
	
	internal var selectionStructArray: [SectionStruct] {
		coreDataMethods.selectionStructArray
	}
	
	internal func coreDataDeleteCell(indexPath: IndexPath, presentedViewController: UIViewController, taskModel: [Tasks]) {
		coreDataMethods.deleteCell(indexPath: indexPath, presentedViewController: presentedViewController, tasksModel: taskModel)
	}
	
	internal func goToNewTaskVC() {
		output?.goToNewTask()
	}
	
	internal func goToDetail() {
		output?.goToDetail()
	}
	
	
	@objc private func saveCheckmark(sender: UIButton) {
		taptic.soft
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		let model = coreDataModel
		for items in model {
			let itemsId = Helper.createShortIntWithoutStrChar(fromItemsId: items.id)
			if sender.tag == itemsId {
				items.check.toggle()
			}
		}
		do {
			try context.save()
		} catch let error as NSError {
			print(error.localizedDescription)
		}
		print(sender.tag)
		NotificationCenter.default.post(name: Notification.Name("TableViewReloadData"), object: .none)
	}
	
	internal func editingStyleBody(indexPath: IndexPath) {
		taptic.warning
		coreDataMethods.fetchRequest()
		switch indexPath.section {
		case 0:
			if  coreDataMethods.selectionStructArray[0].header == "current tasks" {
				coreDataDeleteCell(indexPath: indexPath, presentedViewController: view!, taskModel: currentArray)
			} else if coreDataMethods.selectionStructArray[0].header == "overdue tasks" {
				coreDataDeleteCell(indexPath: indexPath, presentedViewController: view!, taskModel: overdueArray)
			} else if coreDataMethods.selectionStructArray[0].header == "completed tasks" {
				coreDataDeleteCell(indexPath: indexPath, presentedViewController: view!, taskModel: completedArray)
			}
		case 1:
			if coreDataMethods.selectionStructArray[1].header == "current tasks" {
				coreDataDeleteCell(indexPath: indexPath, presentedViewController: view!, taskModel: currentArray)
			} else if coreDataMethods.selectionStructArray[1].header == "overdue tasks" {
				coreDataDeleteCell(indexPath: indexPath, presentedViewController: view!, taskModel: overdueArray)
			} else if coreDataMethods.selectionStructArray[1].header == "completed tasks" {
				coreDataDeleteCell(indexPath: indexPath, presentedViewController: view!, taskModel: completedArray)
			}
		case 2:
			if coreDataMethods.selectionStructArray[2].header == "current tasks" {
				coreDataDeleteCell(indexPath: indexPath, presentedViewController: view!, taskModel: currentArray)
			} else if coreDataMethods.selectionStructArray[2].header == "overdue tasks" {
				coreDataDeleteCell(indexPath: indexPath, presentedViewController: view!, taskModel: overdueArray)
			} else if coreDataMethods.selectionStructArray[2].header == "completed tasks" {
				coreDataDeleteCell(indexPath: indexPath, presentedViewController: view!, taskModel: completedArray)
			}
		default:
			break
		}
	}
	
	internal func cellForRowAtBody(items: Tasks, key: Int, indexPath: IndexPath) -> Tasks{
		var items: Tasks = coreDataModel[indexPath.row]
		let currentEmpty = { self.currentArray.isEmpty }
		let overEmpty = { self.overdueArray.isEmpty }
		let completedEmpty = { self.completedArray.isEmpty }
		
		if currentEmpty(), overEmpty(), completedEmpty() {
			items = coreDataModel[indexPath.row]
			
		} else if currentEmpty(), overEmpty(), !completedEmpty() {
			items = completedArray[indexPath.row]
			
		} else if currentEmpty(), !overEmpty(), completedEmpty() {
			items = overdueArray[indexPath.row]
			
		} else if !currentEmpty(), overEmpty(), completedEmpty() {
			items = currentArray[indexPath.row]
			
		} else if currentEmpty(), !overEmpty(), !completedEmpty() {
			switch key {
			case 0: items = overdueArray[indexPath.row]
			case 1: items = completedArray[indexPath.row]
			default: items = coreDataModel[indexPath.row]
			}
			
		} else if !currentEmpty(), !overEmpty(), completedEmpty() {
			switch key {
			case 0: items = currentArray[indexPath.row]
			case 1: items = overdueArray[indexPath.row]
			default: items = coreDataModel[indexPath.row]
			}
			
		} else if !currentEmpty(), overEmpty(), !completedEmpty() {
			switch key {
			case 0: items = currentArray[indexPath.row]
			case 1: items = completedArray[indexPath.row]
			default: items = coreDataModel[indexPath.row]
			}
			
		} else if !currentEmpty(), !overEmpty(), !completedEmpty() {
			switch key {
			case 0: items = currentArray[indexPath.row]
			case 1: items = overdueArray[indexPath.row]
			case 2: items = completedArray[indexPath.row]
			default: items = coreDataModel[indexPath.row]
			}
		}
		return items
	}
	
	
}
