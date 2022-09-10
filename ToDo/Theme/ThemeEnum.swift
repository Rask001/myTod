//
//  Theme.swift
//  ToDo
//
//  Created by Антон on 09.09.2022.
//

import Foundation
import UIKit

//class Theme {
//	static var current: ThemeProtocol = LightTheme()
//	
//	enum Theme {
//		case LightTheme
//		case DarkTheme
//		case System
//	}
//}
//
//
//

enum ThemeEnum: Int {
	case system
	case lightTheme
	case darkTheme
	
	func getUserIntefaceStyle() -> UIUserInterfaceStyle {
		
		switch self {
		case .system:
			return .unspecified
		case .lightTheme:
			return .light
		case .darkTheme:
			return .dark
		}
	}
}



extension CAGradientLayer {
	
	static func light(gradient: CAGradientLayer, view: UIView) {
	gradient.frame = view.bounds
		gradient.colors = [UIColor(named: "blue")!.cgColor, UIColor.white.cgColor]
		gradient.startPoint = CGPoint(x: 0.5, y: 0)
		gradient.endPoint = CGPoint(x: 0.5, y: 1)
	view.layer.insertSublayer(gradient, at: 0)
	}
	
	static func dark(gradient: CAGradientLayer, view: UIView) {
	gradient.frame = view.bounds
		gradient.colors = [UIColor(named: "BackgroundColorDarkTop")!.cgColor, UIColor(named: "BackgroundColorDarkBottom")!.cgColor]
		gradient.startPoint = CGPoint(x: 0.5, y: 0)
		gradient.endPoint = CGPoint(x: 0.5, y: 1)
	view.layer.insertSublayer(gradient, at: 0)
	}
	
//	static func gradientLayer(for style: UIUserInterfaceStyle, in frame: CGRect) -> Self {
//				let layer = Self()
//				layer.colors = colors(for: style)
//				layer.frame = frame
//				return layer
//		}
//
//	private static func colors(for style: UIUserInterfaceStyle) -> [CGColor] {
//		var beginColor: UIColor
//		var endColor: UIColor
//
//		switch style {
//		case .unspecified:
//			beginColor = .white
//			endColor = .black
//		case .light:
//			beginColor = .blue
//			endColor = .white
//		case .dark:
//			beginColor = .gray
//			endColor = .white
//		@unknown default:
//			beginColor = .white
//			endColor = .red
//		}
//		return [beginColor.cgColor, endColor.cgColor]
// }
}


