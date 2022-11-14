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
	static var navigationTitle: String { NSLocalizedString("today", comment: "")}
}

//MARK: - SecondViewModelProtocol

protocol SecondViewModelProtocol {
	//func reloadTable()
	func goToNewTaskSecond()
	func createNavController(_ viewController: UIViewController)
	var taptic: TapticFeedback! { get }
	var coreDataModel: [Tasks] { get }
	var todayTasksArray: [Tasks] { get }
	var coreDataMethods: CoreDataMethods { get }
	func coreDataDeleteCell(indexPath: IndexPath, presentedViewController: UIViewController, taskModel: [Tasks])
	func visualViewCell(items: Tasks, cell: CustomCell, indexPath: IndexPath)
}

//MARK: - MainViewModel

final class SecondViewModel {
	private weak var output: SecondVCOutput?
	let navController: NavigationController!
	var coreDataMethods: CoreDataMethods
	let visualViewCell: VisualViewCell!
	let taptic: TapticFeedback!
	
	required init(navController: NavigationController,
								coreDataMethods: CoreDataMethods,
								taptic: TapticFeedback,
								output: SecondVCOutput,
								visualViewCell: VisualViewCell) {
		self.navController = navController
		self.coreDataMethods = coreDataMethods
		self.taptic = taptic
		self.output = output
		self.visualViewCell = visualViewCell
	}
}

extension SecondViewModel: SecondViewModelProtocol {
	
	func createNavController(_ viewController: UIViewController) {
		navController.createNavigationController(viewController: viewController,
																						 title: Constants.navigationTitle,
																						 font: Constants.navigationTitleFont,
																						 textColor: .blackWhite!,
																						 backgroundColor: .backgroundColor!,
																						 leftItemText: "",
																						 rightItemText: "",
																						 itemColor: .blackWhite!)
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
	
	internal func goToNewTaskSecond() {
		output?.goToNewTaskSecond()
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
