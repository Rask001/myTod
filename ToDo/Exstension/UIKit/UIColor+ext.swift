//
//  UIColor+ext.swift
//  ToDo
//
//  Created by Антон on 03.07.2022.
//

import UIKit

extension UIColor {
	
		// MARK: Private
		fileprivate static func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor {
				return UIColor(red: r/255, green: g/255, blue: b/255, alpha: a)
		}
		
		fileprivate static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
				return rgba(r, g, b, 1.0)
		}
		
		// MARK: Public
	static let backgroundColor = UIColor(named: "BackgroundColor")
	static let backgroundColorClear = UIColor(named: "BackgroundColorClear")
	static let whiteBlack = UIColor(named: "WhiteBlack")
	static let blackWhite = UIColor(named: "BlackWhite")
	static let cellColor = UIColor(named: "CellColor")
	static let newTaskButtonColor = UIColor(named: "NewTaskButtonColor")
	static let backgroundColorDark = UIColor(named: "BackgroundColorDark")
	
	

	static let dynamicColorTop = UIColor { (traitCollection: UITraitCollection) -> UIColor in
		if traitCollection.userInterfaceStyle == .light {
			return .systemBlue
		} else {
			return .gray
		}
	}
	static let dynamicColorBottom = UIColor { (traitCollection: UITraitCollection) -> UIColor in
		if traitCollection.userInterfaceStyle == .light {
			return .systemYellow
		} else {
			return .white
		}
	}

	  static let offWhite = rgb(255, 225, 235)
}
