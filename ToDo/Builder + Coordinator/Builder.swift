//
//  Assembly.swift
//  ToDo
//
//  Created by Антон on 20.07.2022.
//

import Foundation
import UIKit

final class Builder {
	
	func makeMain(output: MainOutput) -> UIViewController {
		let view = Main()
		let coreDataMethods = CoreDataMethods()
		let visualViewCell = VisualViewCell()
		let navController = NavigationController()
		let taptic = TapticFeedback()
		
		let viewModel = MainViewModel(coreDataMethods: coreDataMethods,
																	visualViewCell: visualViewCell,
																	navController: navController,
																	taptic: taptic,
																	output: output)
			view.viewModel = viewModel
		return view
	}
	
	func makeSecondVC(output: SecondVCOutput) -> UIViewController {
		let viewModel = SecondViewModel(output: output)
		let view = SecondVC(viewModel: viewModel)
		viewModel.view = view
		return view
	}
	
	func makeSettingVC(output: SettingOutput) -> UIViewController {
		let viewModel = SettingViewModel(output: output)
		let view = SettingVC(viewModel: viewModel)
		//viewModel.view = view
		return view
	}
	
	func makeDetailVC(output: DetailOutput) -> UIViewController {
		let view = DetailVC()
		let data = localTaskStruct.taskStruct
		let infoAllert = InfoAlert()
		let viewModel = DetailViewModel(data: data,
																		infoAlert: infoAllert,
																		output: output)
		view.viewModel = viewModel
		return view
	}
	
	func makeRecordSheetVC(output: DetailOutput) -> UIViewController {
		let view = RecordSheetVC()
		let viewModel = RecordSheetViewModel()
		view.viewModel = viewModel
		return view
	}
	
	func makeNewTaskVC(output: NewTaskOutput) -> UIViewController {
		let view = NewTask()
		let presenter = NewTaskPresenter(view: view)
		view.presenter = presenter
		return view
	}
	
	func makeTabBarVC(output: TabBarOutput, rootVC1: UIViewController, rootVC2: UIViewController, rootVC3: UIViewController) -> UITabBarController {
		let tabBar = TabBarController()
		let result = tabBar.createTabBarController(rootVC1: rootVC1, rootVC2: rootVC2, rootVC3: rootVC3)
		return result
	}
	
}
