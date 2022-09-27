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
	
	private var newTaskView = UIViewController()
	private var mainView = UIViewController()
	private var seconvVC = UIViewController()
	private var settingVC = UIViewController()
	private var detailVC = UIViewController()
	private var tabBarVC = UITabBarController()
	

	

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
		mainView.showDetailViewController(newTaskVC, sender: self)
	}
	func goToDetail() {
		let detailVC = assembly.makeDetailVC(output: self)
		mainView.show(detailVC, sender: self)
		print("goToDetail")
	}
}

extension Coordinator: TabBarOutput, SecondVCOutput, SettingOutput, DetailOutput {
	
	func goToNewTaskSecond() {
		let detailVC = assembly.makeDetailVC(output: self)
		seconvVC.show(detailVC, sender: self)
		print("goToNewTaskSecond")
	}
}
