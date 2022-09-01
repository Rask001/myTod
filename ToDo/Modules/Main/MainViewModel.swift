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
	func createNavController()
	var coreDataModel: [Tasks] { get }
	var todayTasksArray: [Tasks] { get }
	var overdueArray: [Tasks] { get }
	var currentArray: [Tasks] { get }
	var sectionIndex: Int { get set }
	var selectionStructArray: [SectionStruct] { get }
	func coreDataDeleteCell(indexPath: IndexPath, presentedViewController: UIViewController, taskModel: [Tasks])
	func coreDataFetch()
	func visualViewCell(items: Tasks, cell: CustomCell, indexPath: IndexPath)
}




//MARK: - MainViewModel

final class MainViewModel {
	private weak var output: MainOutput?
	let coreDataMethods = CoreDataMethods()
	let visualViewCell = VisualViewCell()
	let NavController = NavigationController()
	let taptic = TapticFeedback()
	weak var view: Main?
	init(output: MainOutput) {
		self.output = output
	}
}

extension MainViewModel: MainViewModelProtocol {
	
	func createNavController() {
		NavController.createNavigationController(viewController: view!, title: "my tasks", font: .futura20()!, textColor: .blackWhite!, backgroundColor: .backgroundColor!, leftItemText: "menu", rightItemText: "in dev", itemColor: .blackWhite!)
	}
	
	
	var sectionIndex: Int {
		get {
			coreDataMethods.sectionIndex ?? 0
		} set {
			coreDataMethods.sectionIndex = newValue
		}
	}
	
	func tableViewReload() {
		DispatchQueue.main.async { [weak self] in
			self!.reloadTable()
		}
	}
	
	func reloadTable() {
		view?.tableView.reloadData()
	}
	
	private func createShortIntWithoutStrChar(fromItemsId itemsId: String) -> Int {
		var resultInt = 0
		var resultString = ""
		for num in itemsId {
			if resultString.count < 7 {
				if let chr = Int(String(num)) {
					resultString += String(chr)
				}
			}
		}
		resultInt = Int(resultString) ?? 777
		return resultInt
	}
	
	func visualViewCell(items: Tasks, cell: CustomCell, indexPath: IndexPath) {
		visualViewCell.visualViewCell(items: items, cell: cell)
		
		let button = cell.buttonCell
		
		
		button.tag = createShortIntWithoutStrChar(fromItemsId: items.id)
		
		print("button tag = \(button.tag)")
		sectionIndex = button.tag
		
		button.addTarget(self, action: #selector(saveCheckmark(sender:)), for: .touchUpInside)
	}
	
	func coreDataFetch() {
		coreDataMethods.fetchRequest()
	}
	
	var todayTasksArray: [Tasks] {
		coreDataMethods.todayTasksArray
	}
	
	var overdueArray: [Tasks] {
		coreDataMethods.overdueArray
	}
	
	var currentArray: [Tasks] {
		coreDataMethods.currentArray
	}
	
	var coreDataModel: [Tasks] {
		coreDataMethods.coreDataModel
	}
	
	var selectionStructArray: [SectionStruct] {
		coreDataMethods.selectionStructArray
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
		
		let model = coreDataModel
		for items in model {
			let itemsId = createShortIntWithoutStrChar(fromItemsId: items.id)
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
}
