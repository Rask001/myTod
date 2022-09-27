//
//  CAGradientLayer+ext.swift
//  ToDo
//
//  Created by Антон on 27.09.2022.
//
import UIKit
import Foundation

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
}
