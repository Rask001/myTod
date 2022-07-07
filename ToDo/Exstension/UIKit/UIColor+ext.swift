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
		static let borderColor = rgb(254, 250, 236)
		static let backgroundColor = rgb(0, 66, 37)
		static let scoreColor = rgb(255, 193, 45)
		static let textColor = UIColor.white
		static let playerBackgroundColor = rgb(84, 77, 126)
		static let brightPlayerBackgroundColor = rgba(101, 88, 156, 0.5)
}
