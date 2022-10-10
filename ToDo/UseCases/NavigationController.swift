//
//  NavigationController.swift
//  ToDo
//
//  Created by Антон on 01.09.2022.
//

import Foundation
import UIKit


struct NavigationController {
	 
	 func createNavigationController(viewController: UIViewController, title: String?, font: UIFont, textColor: UIColor, backgroundColor: UIColor, leftItemText: String, rightItemText: String, itemColor: UIColor) {
		let control = viewController
		control.navigationItem.title = title
		let textAttributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: textColor]
		control.navigationController?.navigationBar.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
		
				let navBarAppearance = UINavigationBarAppearance()
				navBarAppearance.configureWithOpaqueBackground()
				navBarAppearance.largeTitleTextAttributes = [.foregroundColor: textColor]
				navBarAppearance.titleTextAttributes = textAttributes
			  navBarAppearance.backgroundColor = backgroundColor
			  navBarAppearance.shadowColor = backgroundColor

			control.navigationController?.navigationBar.standardAppearance = navBarAppearance
			control.navigationController?.navigationBar.compactAppearance = navBarAppearance
			control.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance

			control.navigationController?.navigationBar.prefersLargeTitles = false
			control.navigationController?.navigationBar.isTranslucent = false

	
		let leftButtonItem = UIBarButtonItem(title: leftItemText, style: .plain, target: nil, action: nil)
		leftButtonItem.tintColor = itemColor
//		 leftButtonItem.image = UIImage(systemName: image ?? "plus")
		control.navigationItem.leftBarButtonItems = [leftButtonItem]
		let rightButtonItem = UIBarButtonItem(title: rightItemText, style: .plain, target: nil, action: nil)
		rightButtonItem.tintColor = itemColor
		control.navigationItem.rightBarButtonItems = [rightButtonItem]
		
		
	}
}
