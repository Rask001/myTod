//
//  MainViewModel.swift
//  ToDo
//
//  Created by Антон on 20.07.2022.
//
import UIKit
import Foundation

//MARK: - MainViewModel

final class MainViewModel {
	private weak var output: MainOutput?
	let coreDataMethods: CoreDataMethods
	let visualViewCell: VisualViewCell!
	let navController: NavigationController!
	let taptic: TapticFeedback!
	
	required init(coreDataMethods: CoreDataMethods, visualViewCell: VisualViewCell, navController: NavigationController, taptic: TapticFeedback, output: MainOutput) {
		self.coreDataMethods = coreDataMethods
		self.visualViewCell = visualViewCell
		self.navController = navController
		self.taptic = taptic
		self.output = output
	}
}

extension MainViewModel: MainViewModelProtocol {
	
	internal func createNavController(_ viewController: UIViewController) {
		navController.createNavigationController(viewController:  viewController,
																						 title:           Constants.title,
																						 font:            Constants.navigationTitleFont,
																						 textColor:       .blackWhite!,
																						 backgroundColor: .backgroundColor!,
																						 leftItemText:    "",
																						 rightItemText:   "",
																						 itemColor:       .blackWhite!)
	}
	
	var sectionIndex: Int {
		get {
			coreDataMethods.sectionIndex ?? 0
		} set {
			coreDataMethods.sectionIndex = newValue
		}
	}

	internal func visualViewCell(items: Tasks, cell: CustomCell, indexPath: IndexPath) {
		visualViewCell.visualViewCell(items: items, cell: cell)
		let buttonCell = cell.buttonCell
		buttonCell.tag = try! Helper.createShortIntWithoutStrChar(fromItemsId: items.id)
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
		print(#function)
		taptic.soft
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		let model = coreDataModel
		for items in model {
			let itemsId = try? Helper.createShortIntWithoutStrChar(fromItemsId: items.id)
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
	
	internal func editingStyleBody(indexPath: IndexPath, view: UIViewController) {
		taptic.warning
		coreDataMethods.fetchRequest()
		switch indexPath.section {
		case 0:
			if  coreDataMethods.selectionStructArray[0].header == Constants.currentTasks {
				coreDataDeleteCell(indexPath: indexPath, presentedViewController: view, taskModel: currentArray)
			} else if coreDataMethods.selectionStructArray[0].header == Constants.overdueTasks {
				coreDataDeleteCell(indexPath: indexPath, presentedViewController: view, taskModel: overdueArray)
			} else if coreDataMethods.selectionStructArray[0].header == Constants.completedTasks {
				coreDataDeleteCell(indexPath: indexPath, presentedViewController: view, taskModel: completedArray)
			}
		case 1:
			if coreDataMethods.selectionStructArray[1].header == Constants.currentTasks {
				coreDataDeleteCell(indexPath: indexPath, presentedViewController: view, taskModel: currentArray)
			} else if coreDataMethods.selectionStructArray[1].header == Constants.overdueTasks {
				coreDataDeleteCell(indexPath: indexPath, presentedViewController: view, taskModel: overdueArray)
			} else if coreDataMethods.selectionStructArray[1].header == Constants.completedTasks {
				coreDataDeleteCell(indexPath: indexPath, presentedViewController: view, taskModel: completedArray)
			}
		case 2:
			if coreDataMethods.selectionStructArray[2].header == Constants.currentTasks {
				coreDataDeleteCell(indexPath: indexPath, presentedViewController: view, taskModel: currentArray)
			} else if coreDataMethods.selectionStructArray[2].header == Constants.overdueTasks {
				coreDataDeleteCell(indexPath: indexPath, presentedViewController: view, taskModel: overdueArray)
			} else if coreDataMethods.selectionStructArray[2].header == Constants.completedTasks {
				coreDataDeleteCell(indexPath: indexPath, presentedViewController: view, taskModel: completedArray)
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



fileprivate enum Constants {
	static var navigationTitleFont: UIFont { UIFont(name: "Futura", size: 20)!}
	static var title: String { NSLocalizedString("my tasks", comment: "") }
	static var currentTasks: String { NSLocalizedString("current tasks", comment: "") }
	static var overdueTasks: String { NSLocalizedString("overdue tasks", comment: "") }
	static var completedTasks: String { NSLocalizedString("completed tasks", comment: "") }
}
