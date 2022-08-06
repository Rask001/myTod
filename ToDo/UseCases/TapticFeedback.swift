//
//  TapticFeedback.swift
//  ToDo
//
//  Created by Антон on 05.08.2022.
//
import UIKit
import Foundation

 class TapticFeedback {
	 static var shared = TapticFeedback()
	  var soft: Void { UIImpactFeedbackGenerator(style: .soft).impactOccurred() }
	  var light: Void { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
	  var medium: Void { UIImpactFeedbackGenerator(style: .medium).impactOccurred() }
	  var rigid: Void { UIImpactFeedbackGenerator(style: .rigid).impactOccurred() }
	  var heavy: Void { UIImpactFeedbackGenerator(style: .heavy).impactOccurred() }
	  var warning: Void { UINotificationFeedbackGenerator().notificationOccurred(.warning) }
	  var success: Void { UINotificationFeedbackGenerator().notificationOccurred(.success) }
	  var error: Void { UINotificationFeedbackGenerator().notificationOccurred(.error) }
}
