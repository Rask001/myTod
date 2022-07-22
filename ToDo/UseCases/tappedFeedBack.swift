//
//  tappedFeedBack.swift
//  ToDo
//
//  Created by Антон on 22.07.2022.
//
import UIKit
import Foundation

protocol TappedRigidProtocol {
	func tappedRigid()
}

protocol TappedSoftProtocol {
	func tappedSoft()
}

class TappedFeedBack {
	
	
}

extension TappedFeedBack: TappedRigidProtocol, TappedSoftProtocol {
	
	func tappedSoft() {
		let generator = UIImpactFeedbackGenerator(style: .soft)
		generator.impactOccurred()
	}
	
	func tappedRigid() {
		let generator = UIImpactFeedbackGenerator(style: .rigid)
		generator.impactOccurred()
	}
}
