//
//  TabBarController.swift
//  ToDo
//
//  Created by Антон on 26.08.2022.
//

//
import UIKit
protocol TabBarOutput: AnyObject {}

class TabBarController: UITabBarController {
	
	
//	override func viewDidLoad() {
//		super.viewDidLoad()
//	}
//
	
	
	func createTabBarController(rootVC1: UIViewController, rootVC2: UIViewController, rootVC3: UIViewController) -> UITabBarController {
		let tabBarVC = UITabBarController()
		let xmrk = UIImage(systemName: "22.square.fill")
		let chckmrk = UIImage(systemName: "22.square")
		let settings = UIImage(systemName: "gear")
		
		tabBarVC.setViewControllers([generationNavigationController(rootVC: rootVC1, title: "all", image: xmrk!, tag: 0),
																generationNavigationController(rootVC: rootVC2, title: "today", image: chckmrk!, tag: 1),
																 generationNavigationController(rootVC: rootVC3, title: "settings", image: settings!, tag: 2)], animated: true)
		
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
}

