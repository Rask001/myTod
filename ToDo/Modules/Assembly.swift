//
//  Assembly.swift
//  ToDo
//
//  Created by Антон on 20.07.2022.
//

import Foundation
import UIKit

class Assembly {
	
	func makeMain(output: MainOutput) -> UIViewController {
		let viewModel = MainViewModel(output: output)
		let view = Main(viewModel: viewModel)
		viewModel.view = view
		return view
	}
	
	func makeNewTaskVC(output: NewTaskOutput) -> UIViewController {
		let view = NewTask()
		let presenter = NewTaskPresenter(view: view)
		view.presenter = presenter
		return view
	}
	
}
