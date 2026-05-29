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
		configure(gradient: gradient,
				  view: view,
				  colors: [UIColor(named: "blue") ?? .systemBlue, .white])
	}

	static func dark(gradient: CAGradientLayer, view: UIView) {
		configure(gradient: gradient,
				  view: view,
				  colors: [UIColor(named: "BackgroundColorDarkTop") ?? .systemGray6,
						   UIColor(named: "BackgroundColorDarkBottom") ?? .systemGray5])
	}
	
	private static func configure(gradient: CAGradientLayer, view: UIView, colors: [UIColor]) {
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		gradient.frame = view.bounds
		gradient.colors = colors.map { $0.resolvedColor(with: view.traitCollection).cgColor }
		gradient.startPoint = CGPoint(x: 0.5, y: 0)
		gradient.endPoint = CGPoint(x: 0.5, y: 1)
		if gradient.superlayer == nil {
			view.layer.insertSublayer(gradient, at: 0)
		}
		CATransaction.commit()
	}
}
