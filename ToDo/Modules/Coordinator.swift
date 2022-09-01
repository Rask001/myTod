//
//  Coordinator.swift
//  ToDo
//
//  Created by Антон on 20.07.2022.
//

import Foundation
import UIKit

final class Coordinator {
	
	
	private let assembly: Assembly

	init(assembly: Assembly) {
		self.assembly = assembly
	}
	
	var mainView = UIViewController()
	var seconvVC = UIViewController()
	var settingVC = UIViewController()
  var tabBarVC = UITabBarController()

	

	func start(window: UIWindow) {
		mainView = assembly.makeMain(output: self)
		seconvVC = assembly.makeSecondVC(output: self)
		settingVC = assembly.makeSettingVC(output: self)
		tabBarVC = assembly.makeTabBarVC(output: self, rootVC1: mainView, rootVC2: seconvVC, rootVC3: settingVC)
		window.rootViewController = tabBarVC
		window.makeKeyAndVisible()
	}
}

extension Coordinator: MainOutput {
	func goToNewTask() {
		let newTaskVC = assembly.makeNewTaskVC(output: self)
		mainView.present(newTaskVC, animated: true, completion: nil)
	}
}

extension Coordinator: NewTaskOutput, TabBarOutput, SecondVCOutput, SettingOutput {
}
