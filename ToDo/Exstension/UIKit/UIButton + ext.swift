//
//  UIButton + ext.swift
//  ToDo
//
//  Created by Антон on 30.07.2022.
//

import Foundation
import UIKit

extension UIButton {
	convenience init(backrounColor: UIColor = .white,
									 titleColor: UIColor = .lightGray,
									 title: String,
									 isShadow: Bool = false,
									 font: UIFont? = .avenir20(),
									 cornerRaadius: CGFloat = 4) {
		self.init(type: .system)
		self.setTitle(title, for: .normal)
		self.setTitleColor(titleColor, for: .normal)
		self.backgroundColor = backrounColor
		self.titleLabel?.font = font
		self.layer.cornerRadius = cornerRaadius
		
		if isShadow == true {
			self.layer.shadowColor = UIColor.black.cgColor
			self.layer.shadowRadius = 4
			self.layer.shadowOpacity = 0.1
			self.layer.shadowOffset = CGSize(width: 0, height: 4 )
		}
	}
}
