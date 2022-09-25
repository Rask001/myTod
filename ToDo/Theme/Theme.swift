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
		switch MTUserDefaults.shared.theme {
		case .lightTheme:
			CAGradientLayer.light(gradient: gradient, view: view)
		case .darkTheme:
			CAGradientLayer.dark(gradient: gradient, view: view)
		case .system:
			if traitCollection.userInterfaceStyle == .light {
				CAGradientLayer.light(gradient: gradient, view: view)
			} else if traitCollection.userInterfaceStyle == .dark {
				CAGradientLayer.dark(gradient: gradient, view: view)
			}
		}
	}
}
