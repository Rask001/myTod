//
//  Coordinator.swift
//  ToDo
//
//  Created by Антон on 20.07.2022.
//

import Foundation
import UIKit

final class Coordinator: NewTaskOutput {
	
	
	private let builder: Builder
	
	init(builder: Builder) {
		self.builder = builder
	}
	
	private var newTaskView = UIViewController()
	private var mainView = UIViewController()
	private var seconvVC = UIViewController()
	private var settingVC = UIViewController()
	private var detailVC = UIViewController()
	private var recordSheetVC = UIViewController()
	private var tabBarVC = UITabBarController()
	
	func start(window: UIWindow) {
		mainView = builder.makeMain(output: self)
		seconvVC = builder.makeSecondVC(output: self)
		settingVC = builder.makeSettingVC(output: self)
		detailVC = builder.makeDetailVC(output: self)
		recordSheetVC = builder.makeRecordSheetVC(output: self)
		tabBarVC = builder.makeTabBarVC(output: self, rootVC1: mainView, rootVC2: seconvVC, rootVC3: settingVC)
		window.rootViewController = tabBarVC
		window.makeKeyAndVisible()
		window.overrideUserInterfaceStyle = MTUserDefaults.shared.theme.getUserIntefaceStyle() //определение пользовательской темы
	}
}

extension Coordinator: MainOutput {
	
	func goToNewTask() {
		let newTaskVC = builder.makeNewTaskVC(output: self)
		mainView.showDetailViewController(newTaskVC, sender: self)
	}
	
	func goToDetail() {
		let detailVC = builder.makeDetailVC(output: self)
		mainView.show(detailVC, sender: self)
		print("goToDetail")
	}
}

extension Coordinator: TabBarOutput, SecondVCOutput, SettingOutput, DetailOutput {
	
	func goToRecordSheet() {
		let recordSheetVC = builder.makeRecordSheetVC(output: self)
		if let sheet = recordSheetVC.sheetPresentationController {
			sheet.detents = [.medium(), .large()]
		}
		mainView.present(recordSheetVC, animated: true)
		print("goToRecordSheetVC")
	}
	
	func goToDetailSecond() {
		let detailVC = builder.makeDetailVC(output: self)
		seconvVC.show(detailVC, sender: self)
		print("goToNewTaskSecond")
	}
	
	func goToNewTaskSecond() {
		let newTaskVC = builder.makeNewTaskVC(output: self)
		seconvVC.showDetailViewController(newTaskVC, sender: self)
	}
}