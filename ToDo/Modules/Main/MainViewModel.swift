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
	func goToNewTaskVC()
	func tappedSoft()
	func tappedRigid()
	var coreDataModel: [Tasks] { get }
	func coreDataDeleteCell(indexPath: IndexPath, presentedViewController: UIViewController)
	func coreDataFetch()
	func visualViewCell(items: Tasks, cell: CustomCell, indexPath: IndexPath)
}


//MARK: - MainViewModel

class MainViewModel {
	private weak var output: MainOutput?
	let tappedFeedBack = TappedFeedBack()
	let coreDataMethods = CoreDataMethods()
	let visualViewCell = VisualViewCell()
	weak var view: Main?
	init(output: MainOutput) {
		self.output = output
	}
}

extension MainViewModel: MainViewModelProtocol {
	func visualViewCell(items: Tasks, cell: CustomCell, indexPath: IndexPath) {
		visualViewCell.visualViewCell(items: items, cell: cell, indexPath: indexPath)
		let button = cell.buttonCell
		button.tag = indexPath.row
		button.addTarget(self, action: #selector(saveCheckmark(sender:)), for: .touchUpInside)
	}
	
	func coreDataFetch() {
		coreDataMethods.fetchRequest()
	}
	
	var coreDataModel: [Tasks] {
		get {
			coreDataMethods.coreDataModel
		}
	}
	
	
	func coreDataDeleteCell(indexPath: IndexPath, presentedViewController: UIViewController) {
		coreDataMethods.deleteCell(indexPath: indexPath, presentedViewController: presentedViewController)
	}
	
	
	func tappedSoft() {
		tappedFeedBack.tappedSoft()
	}
	
	func tappedRigid() {
		tappedFeedBack.tappedRigid()
	}
	
	func goToNewTaskVC() {
		output?.goToNewTask()
		}
	
		@objc private func saveCheckmark(sender: UIButton) {
			tappedSoft()
			let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
			let model = coreDataModel[sender.tag]
			model.check.toggle()
			do {
				try context.save()
			} catch let error as NSError {
				print(error.localizedDescription)
			}
			NotificationCenter.default.post(name: Notification.Name("TableViewReloadData"), object: .none)
		}
	}
