//
//  MTUserDefolts.swift
//  ToDo
//
//  Created by Антон on 09.09.2022.
//

import Foundation

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
