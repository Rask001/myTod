//
//  MainViewModelProtocol.swift
//  ToDo
//
//  Created by Антон on 10.11.2022.
//

import Foundation
import UIKit

//MARK: - MainViewModelProtocol
protocol MainViewModelProtocol {
	func goToNewTaskVC()
	func goToDetail()
	func createNavController(_ viewController: UIViewController)
	var coreDataMethods: CoreDataMethods { get }
	var coreDataModel: [Tasks] { get }
	var todayTasksArray: [Tasks] { get }
	var overdueArray: [Tasks] { get }
	var currentArray: [Tasks] { get }
	var completedArray: [Tasks] { get }
	var sectionIndex: Int { get set }
	var selectionStructArray: [SectionStruct] { get }
	func passData(cellTag: Int)
	func coreDataDeleteCell(indexPath: IndexPath, presentedViewController: UIViewController, taskModel: [Tasks])
	func visualViewCell(items: Tasks, cell: CustomCell, indexPath: IndexPath)
	func editingStyleBody(indexPath: IndexPath, view: UIViewController)
	func cellForRowAtBody(items: Tasks, key: Int, indexPath: IndexPath) -> Tasks
}
