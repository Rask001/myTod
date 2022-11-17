//
//  SecondViewModel.swift
//  ToDo
//
//  Created by Антон on 28.08.2022.
//

import Foundation
import UIKit

//MARK: - Static Property
fileprivate enum Constants {
	static var navigationTitleFont: UIFont { UIFont(name: "Futura", size: 20)!}
	static var navigationTitle: String { NSLocalizedString("settings", comment: "")}
}

fileprivate enum SegmentedItems {
	static var system: String { NSLocalizedString("System", comment: "") }
	static var light: String { NSLocalizedString("Light", comment: "") }
	static var dark: String { NSLocalizedString("Dark", comment: "") }
}

//MARK: - SecondViewModel
final class SettingViewModel {
	private weak var output: SettingOutput?
	let navController = NavigationController()
	init(output: SettingOutput) {
		self.output = output
	}
}

extension SettingViewModel: SettingViewModelProtocol {
	func goToChangePassword() {
		output?.goToChangePassword()
	}
	

	func changeLanguage() {
		UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
	}
	
	func getSegmentedItems() -> [String] {
		let segmentedItems = [SegmentedItems.system, SegmentedItems.light, SegmentedItems.dark]
		return segmentedItems
	}
	
	func createNavController(view: UIViewController) {
		navController.createNavigationController(viewController: view, title: Constants.navigationTitle, font: Constants.navigationTitleFont, textColor: .label, backgroundColor: .backgroundColor ?? .systemBackground, leftItemText: "", rightItemText: "", itemColor: .label)
	}
}
