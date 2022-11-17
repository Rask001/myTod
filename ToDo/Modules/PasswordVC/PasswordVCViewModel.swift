//
//  PasswordVCViewModel.swift
//  ToDo
//
//  Created by Антон on 16.11.2022.
//

import Foundation
import LocalAuthentication
import UIKit

protocol PasswordVCViewModelProtocol {
	func checkFaceId(view: UIViewController)
	var animations: Animations! { get }
	func goToMainViewPassword()
}

final class PasswordVCViewModel: PasswordVCViewModelProtocol {
	
	//MARK: - PROPERTY
	
	private weak var output: PasswordVCOutput?
	var animations: Animations!
	
	required init(output: PasswordVCOutput, animations: Animations) {
		self.animations = animations
		self.output = output
	}

	func checkFaceId(view: UIViewController) {
		let context = LAContext()
		var error: NSError?
		if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
			let reason = NSLocalizedString("Pleace autorize with Face/Touch ID", comment: "")
			context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
														 localizedReason: reason) { [weak self] success, error in
				DispatchQueue.main.async {
					guard success, error == nil else { return }
					self?.output?.goToMainView()
				}
			}
		} else {
			if let error {
				noAccessAlert(error: error, view: view)
			}
		}
	}
	
	func goToMainViewPassword() {
		self.output?.goToMainView()
	}
}

extension PasswordVCViewModel {
	private func noAccessAlert(error: NSError, view: UIViewController) {
		let allert = createAlert(title: NSLocalizedString("No access", comment: ""), message: "\(error.localizedDescription)")
		view.present(allert, animated: true)
	}
	
	private func createAlert(title: String, message: String) -> UIAlertController {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let dismissAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel)
		alert.addAction(dismissAction)
		return alert
	}
}
