//
//  TabBarController.swift
//  ToDo
//
//  Created by Антон on 26.08.2022.
//

//
fileprivate enum Constants {
	static var mainTitle: String { NSLocalizedString("my tasks", comment: "") }
	static var allTasksTitle: String { NSLocalizedString("all tasks", comment: "") }
	static var todayTitle: String { NSLocalizedString("today", comment: "") }
	static var settingsTitle: String { NSLocalizedString("settings", comment: "") }
	static var buttonTitle: String { "+" }
	static var buttonTitleColor = UIColor.blackWhite
	static var buttonBackgroundColor = UIColor.newTaskButtonColor
	static var buttonCornerRadius: CGFloat { 35 }
	static var tableViewRowHeight: CGFloat { 60 }
	static var buttonFont: UIFont { UIFont(name: "Helvetica Neue Medium", size: 10)!}
}



import UIKit
protocol TabBarOutput: AnyObject {}

final class TabBarController: UITabBarController {
	let dateNow = Date.now
	
	func createTabBarController(rootVC1: UIViewController, rootVC2: UIViewController, rootVC3: UIViewController) -> UITabBarController {
		
		UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue], for: .selected)
		UITabBar.appearance().tintColor = .systemBlue
		let tabBarVC = UITabBarController()
		let firstPic = UIImage(systemName: "list.bullet.rectangle.fill")
		
		
		let todayPic = UIImage(systemName: calendarDate())
		let settingPic = UIImage(systemName: "gear")
	
		
		
		tabBarVC.viewControllers = [generationNavigationController(rootVC: rootVC1, title: Constants.allTasksTitle, image: firstPic!, tag: 0),
																generationNavigationController(rootVC: rootVC2, title: Constants.todayTitle, image: todayPic!, tag: 1),
																generationNavigationController(rootVC: rootVC3, title: Constants.settingsTitle, image: settingPic!, tag: 2)]
		
		
		func generationNavigationController(rootVC: UIViewController, title: String, image: UIImage, tag: Int) -> UINavigationController {
			let navigationVC = UINavigationController(rootViewController: rootVC)
			let item = UITabBarItem(title: title, image: image, tag: tag)
			navigationVC.tabBarItem = item
			navigationVC.navigationBar.setValue(true, forKey: "hidesShadow")
			return navigationVC
		}
		return tabBarVC
	}
	
	private func calendarDate() -> String {
		let day = Calendar.current.dateComponents([.day], from: dateNow)
		let componentsForm = DateComponentsFormatter()
		let componentsStr = componentsForm.string(from: day)
		let numDayStr = componentsStr!.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
		let date = "\(numDayStr).square.fill"
		return date
	}
	
	
	
}

