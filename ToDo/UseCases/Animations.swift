//
//  Animations.swift
//  ToDo
//
//  Created by Антон on 27.09.2022.
//

import Foundation
import UIKit

class Animations {
	
	 func shake(text: UILabel, duration: CFTimeInterval) {
		UINotificationFeedbackGenerator().notificationOccurred(.error)
		let animation = CAKeyframeAnimation()
		animation.keyPath = "position.x"
		animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
		//animation.values = [-10.0, 10.0, -8.0, 8.0, -5.0, 5.0, -3.0, 3.0, 0.0 ] //-15.0, 15.0, -13.0, 13.0, //не попадает в таптик фидбэк((
		animation.values = [-10.0, 10.0, -5.0, 5.0, 0.0 ]
		animation.duration = duration
		animation.isAdditive = true
		text.layer.add(animation, forKey: "shake")
		text.layer.animation(forKey: "shake")
	}
	
	
  //	var differenceInSize = CGFloat() // объявить в классе!
	
	func animSet(smallLb: UILabel, bigLb: UILabel, differenceInSize: inout CGFloat) {  // добавить во viewDidLoad
		bigLb.center = smallLb.center
		differenceInSize = bigLb.font.pointSize / smallLb.font.pointSize
		smallLb.alpha = 1
		bigLb.alpha = 0
		bigLb.transform = CGAffineTransform(scaleX: 1/differenceInSize, y: 1/differenceInSize)
	}

	func animateImageView(smallLb: UILabel, bigLb: UILabel, differenceInSize: CGFloat) { // вызывать по мере необходимости
		UIView.animate(withDuration: 1, delay: 0.2) {
		  smallLb.layer.shadowRadius = 5
		  smallLb.layer.shadowOpacity = 0.4
		  smallLb.layer.shadowOffset = CGSize(width: 0, height: 6)
			bigLb.layer.shadowRadius = 5
			bigLb.layer.shadowOpacity = 0.4
			bigLb.layer.shadowOffset = CGSize(width: 0, height: 6)
		  smallLb.alpha = 0
			bigLb.alpha = 1
		  smallLb.transform = CGAffineTransform(scaleX: differenceInSize, y: differenceInSize)
			bigLb.transform = CGAffineTransform.identity
		}
	}
	
	func animateDownImageView(smallLb: UILabel, bigLb: UILabel, differenceInSize: CGFloat) { // вызывать по мере необходимости
		UIView.animate(withDuration: 1, delay: 0.3) {
			//smallLb.font = UIFont(name: "Helvetica Neue Medium", size: 40)
			smallLb.layer.shadowRadius = 2
			smallLb.layer.shadowOpacity = 0.4
			smallLb.layer.shadowOffset = CGSize(width: 0, height: 3)
			bigLb.layer.shadowRadius = 2
			bigLb.layer.shadowOpacity = 0.4
			bigLb.layer.shadowOffset = CGSize(width: 0, height: 3)
			smallLb.alpha = 1
			bigLb.alpha = 0
			bigLb.transform = CGAffineTransform(scaleX: 1/differenceInSize, y: 1/differenceInSize)
			smallLb.transform = CGAffineTransform.identity
		}
	}
	
	 enum CurtainUpDown {
		case down
		case up
	}
	
	func curtain(color: UIColor, alpha: CGFloat = 0.3, alfaZero: CGFloat = 0, superView: UIView, upDown: CurtainUpDown, curtainView: UIView) {
		curtainView.backgroundColor = color
		switch upDown {
		case .down:
			curtainView.frame = CGRect(x: 0, y: -10, width: superView.frame.width, height: 10)
			curtainView.alpha = alfaZero
			UIView.animate(withDuration: 1, delay: 0.2) {
				curtainView.alpha = alpha
				curtainView.frame = CGRect(x: 0, y: -10, width: superView.frame.width, height: 800)
			}
		case .up:
			UIView.animate(withDuration: 1, delay: 0.2) {
				curtainView.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.0)
				curtainView.frame = CGRect(x: 0, y: -10, width: superView.frame.width, height: 10)
			}
		}
	}
}
