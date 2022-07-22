//
//  Coordinator.swift
//  ToDo
//
//  Created by Антон on 20.07.2022.
//

import Foundation
import UIKit

class Coordinator {
	
	
	private let assembly: Assembly
	private var navigationViewController: UINavigationController?
	
	init(assembly: Assembly) {
		self.assembly = assembly
	}
	
	func start(window: UIWindow) {
		let mainView = assembly.makeMain(output: self)
		navigationViewController = UINavigationController(rootViewController: mainView)
		window.rootViewController = navigationViewController
		window.makeKeyAndVisible()
	}
}

extension Coordinator: MainOutput {
	func goToNewTask() {
		let newTaskVC = assembly.makeNewTaskVC(output: self)
		navigationViewController?.present(newTaskVC, animated: true, completion: nil)
	}
}

extension Coordinator: NewTaskOutput {
}
