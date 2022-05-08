//
//  UILabel+e.swift
//  ToDo
//
//  Created by Антон on 08.05.2022.
//

import Foundation
import UIKit

extension UILabel {
	convenience init(font: UIFont, textColor: UIColor) {
		self.init()
		self.font = font
		self.textColor = textColor
	}
}
