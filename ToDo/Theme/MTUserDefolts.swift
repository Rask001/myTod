//
//  MTUserDefolts.swift
//  ToDo
//
//  Created by Антон on 09.09.2022.
//

import Foundation
import UIKit

struct MTUserDefaults {
	static var shared = MTUserDefaults()
	var theme: ThemeEnum {
		get {
			ThemeEnum(rawValue: UserDefaults.standard.integer(forKey: "selectedTheme")) ?? .system
		} set {
			UserDefaults.standard.set(newValue.rawValue, forKey: "selectedTheme")
		}
	}
}

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
