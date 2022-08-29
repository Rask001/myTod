//
//  TabBarController.swift
//  ToDo
//
//  Created by Антон on 26.08.2022.
//

//
import UIKit
protocol TabBarOutput: AnyObject {}

final class TabBarController: UITabBarController {
	let dateNow = Date.now
	
	func createTabBarController(rootVC1: UIViewController, rootVC2: UIViewController, rootVC3: UIViewController) -> UITabBarController {
		let tabBarVC = UITabBarController()
		let firstPic = UIImage(systemName: "list.bullet.rectangle.fill")
		let todayPic = UIImage(systemName: calendarDate())
		let settingPic = UIImage(systemName: "gear")
		
		tabBarVC.setViewControllers([generationNavigationController(rootVC: rootVC1, title: "all tasks", image: firstPic!, tag: 0),
																generationNavigationController(rootVC: rootVC2, title: "today", image: todayPic!, tag: 1),
																 generationNavigationController(rootVC: rootVC3, title: "settings", image: settingPic!, tag: 2)], animated: true)
		
		func generationNavigationController(rootVC: UIViewController, title: String, image: UIImage, tag: Int) -> UINavigationController {
			let navigationVC = UINavigationController(rootViewController: rootVC)
			let item = UITabBarItem(title: title, image: image, tag: tag)
			navigationVC.tabBarItem = item
			return navigationVC
		}
		rootVC1.loadViewIfNeeded()  //подгружает значек таб бара при запуске
		rootVC2.loadViewIfNeeded()  //подгружает значек таб бара при запуске
		rootVC3.loadViewIfNeeded()  //подгружает значек таб бара при запуске
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

