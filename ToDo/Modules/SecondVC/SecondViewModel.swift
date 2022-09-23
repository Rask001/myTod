//
//  SecondViewModel.swift
//  ToDo
//
//  Created by Антон on 28.08.2022.
//

import UIKit
import Foundation

fileprivate enum Constants {
	static var navigationTitleFont: UIFont { UIFont(name: "Futura", size: 20)!}
}

//MARK: - SecondViewModelProtocol

protocol SecondViewModelProtocol {
	func reloadTable()
	func goToNewTaskVC()
	func createNavController()
	var coreDataModel: [Tasks] { get }
	var todayTasksArray: [Tasks] { get }
	var coreDataMethods: CoreDataMethods { get }
	func coreDataDeleteCell(indexPath: IndexPath, presentedViewController: UIViewController, taskModel: [Tasks])
	func visualViewCell(items: Tasks, cell: CustomCell, indexPath: IndexPath)
}




//MARK: - MainViewModel

final class SecondViewModel {
	private weak var output: SecondVCOutput?
	internal let coreDataMethods = CoreDataMethods()
	private let NavController = NavigationController()
	private let visualViewCell = VisualViewCell()
	private let taptic = TapticFeedback()
	weak var view: SecondVC?
	init(output: SecondVCOutput) {
		self.output = output
	}
}

extension SecondViewModel: SecondViewModelProtocol {
	
	internal func createNavController() {
		NavController.createNavigationController(viewController: view!, title: "today", font: Constants.navigationTitleFont, textColor: .blackWhite!, backgroundColor: .backgroundColor!, leftItemText: "", rightItemText: "", itemColor: .blackWhite!)
	}
	
	
	
	internal func tableViewReload() {
		DispatchQueue.main.async { [weak self] in
			self!.reloadTable()
		}
	}
	
	internal func reloadTable() {
		view?.tableView.reloadData()
	}
	
	internal func visualViewCell(items: Tasks, cell: CustomCell, indexPath: IndexPath) {
		visualViewCell.visualViewCell(items: items, cell: cell)
		let button = cell.buttonCell
		button.tag = indexPath.row
		button.addTarget(self, action: #selector(saveCheckmark(sender:)), for: .touchUpInside)
	}
	
	internal var todayTasksArray: [Tasks] {
		get {
			coreDataMethods.todayTasksArray
		}
	}
	
	internal var coreDataModel: [Tasks] {
		get {
			coreDataMethods.coreDataModel
		}
	}
	
	
	internal func coreDataDeleteCell(indexPath: IndexPath, presentedViewController: UIViewController, taskModel: [Tasks]) {
		coreDataMethods.deleteCell(indexPath: indexPath, presentedViewController: presentedViewController, tasksModel: taskModel)
	}
	
	internal func goToNewTaskVC() {
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
