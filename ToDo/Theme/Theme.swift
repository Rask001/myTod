//
//  ThemeProtocol.swift
//  ToDo
//
//  Created by Антон on 09.09.2022.
//

import Foundation
import UIKit

final class Theme {
	class func switchTheme(gradient: CAGradientLayer, view: UIView, traitCollection: UITraitCollection) {
		let style = resolvedInterfaceStyle(for: traitCollection)
		view.backgroundColor = backgroundBottomColor(for: style)
		gradient.frame = view.bounds
		
		switch style {
		case .light:
			CAGradientLayer.light(gradient: gradient, view: view)
		case .dark:
			CAGradientLayer.dark(gradient: gradient, view: view)
		default:
			CAGradientLayer.light(gradient: gradient, view: view)
		}
	}
	
	class func resolvedInterfaceStyle(for traitCollection: UITraitCollection) -> UIUserInterfaceStyle {
		switch MTUserDefaults.shared.theme {
		case .lightTheme:
			return .light
		case .darkTheme:
			return .dark
		case .system:
			let systemStyle = UIScreen.main.traitCollection.userInterfaceStyle
			return systemStyle == .dark ? .dark : .light
		}
	}
	
	class func configureBars(for viewController: UIViewController) {
		let style = resolvedInterfaceStyle(for: viewController.traitCollection)
		let navColor = navigationColor(for: style)
		let tabColor = backgroundBottomColor(for: style)
		let textColor = (UIColor.blackWhite ?? .label).resolvedColor(with: viewController.traitCollection)
		
		let navAppearance = UINavigationBarAppearance()
		navAppearance.configureWithOpaqueBackground()
		navAppearance.backgroundColor = navColor
		navAppearance.shadowColor = .clear
		navAppearance.titleTextAttributes = [
			.font: UIFont.systemFont(ofSize: 17, weight: .semibold),
			.foregroundColor: textColor
		]
		
		viewController.navigationController?.navigationBar.standardAppearance = navAppearance
		viewController.navigationController?.navigationBar.compactAppearance = navAppearance
		viewController.navigationController?.navigationBar.scrollEdgeAppearance = navAppearance
		viewController.navigationController?.navigationBar.isTranslucent = false
		
		let tabAppearance = UITabBarAppearance()
		tabAppearance.configureWithOpaqueBackground()
		tabAppearance.backgroundColor = tabColor
		tabAppearance.shadowColor = .clear
		
		if let tabBar = viewController.tabBarController?.tabBar {
			tabBar.standardAppearance = tabAppearance
			tabBar.scrollEdgeAppearance = tabAppearance
			tabBar.isTranslucent = false
			tabBar.backgroundColor = tabColor
			viewController.tabBarController?.view.backgroundColor = tabColor
			viewController.navigationController?.view.backgroundColor = navColor
			if #available(iOS 26.0, *) {
				viewController.tabBarController?.tabBarMinimizeBehavior = .never
			}
		}
	}
	
	private class func navigationColor(for style: UIUserInterfaceStyle) -> UIColor {
		switch style {
		case .dark:
			return UIColor(named: "BackgroundColorDarkTop") ?? .systemGray6
		default:
			return UIColor(named: "blue") ?? .systemBackground
		}
	}
	
	private class func backgroundBottomColor(for style: UIUserInterfaceStyle) -> UIColor {
		switch style {
		case .dark:
			return UIColor(named: "BackgroundColorDarkBottom") ?? .systemGray5
		default:
			return .white
		}
	}
}
