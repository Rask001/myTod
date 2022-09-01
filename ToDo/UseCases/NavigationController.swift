//
//  NavigationController.swift
//  ToDo
//
//  Created by Антон on 01.09.2022.
//

import Foundation
import UIKit


final class NavigationController {
	func createNavigationController(viewController: UIViewController, title: String, font: UIFont, textColor: UIColor, backgroundColor: UIColor, leftItemText: String, rightItemText: String, itemColor: UIColor) {
		
		let control = viewController
		control.navigationItem.title = title
		let textAttributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: textColor]
		control.navigationController?.navigationBar.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
		control.navigationController?.navigationBar.barTintColor = backgroundColor
		control.navigationController?.navigationBar.backgroundColor = backgroundColor
		control.navigationController?.toolbar.backgroundColor = backgroundColor
		UINavigationBar.appearance().shadowImage = UIImage() //убирает полоску под нав контроллером
		let leftButtonItem = UIBarButtonItem(title: leftItemText, style: .plain, target: nil, action: nil)
		leftButtonItem.tintColor = itemColor
		control.navigationItem.leftBarButtonItems = [leftButtonItem]
		let rightButtonItem = UIBarButtonItem(title: rightItemText, style: .plain, target: nil, action: nil)
		rightButtonItem.tintColor = itemColor
		control.navigationItem.rightBarButtonItems = [rightButtonItem]
	}
}
