//
//  Coordinator.swift
//  ToDo
//
//  Created by Антон on 20.07.2022.
//

import Foundation
import UIKit

final class Coordinator: NewTaskOutput {
	
	
	private let assembly: Assembly

	init(assembly: Assembly) {
		self.assembly = assembly
	}
	
	var newTaskView = UIViewController()
	var mainView = UIViewController()
	var seconvVC = UIViewController()
	var settingVC = UIViewController()
	var detailVC = UIViewController()
  var tabBarVC = UITabBarController()

	

	func start(window: UIWindow) {
		mainView = assembly.makeMain(output: self)
		seconvVC = assembly.makeSecondVC(output: self)
		settingVC = assembly.makeSettingVC(output: self)
		detailVC = assembly.makeDetailVC(output: self)
		tabBarVC = assembly.makeTabBarVC(output: self, rootVC1: mainView, rootVC2: seconvVC, rootVC3: settingVC)
		window.rootViewController = tabBarVC
		window.makeKeyAndVisible()
		window.overrideUserInterfaceStyle = MTUserDefaults.shared.theme.getUserIntefaceStyle() //определение пользовательской темы
	}
}

extension Coordinator: MainOutput {
	
	func goToNewTask() {
		let newTaskVC = assembly.makeNewTaskVC(output: self)
		mainView.present(newTaskVC, animated: true, completion: nil)
	}
	func goToDetail() {
		let detailVC = assembly.makeDetailVC(output: self)
		mainView.navigationController?.pushViewController(detailVC, animated: true)
	}
}

extension Coordinator: TabBarOutput, SecondVCOutput, SettingOutput, DetailOutput {
	
}
