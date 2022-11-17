//
//  PasswordSettingsVC.swift
//  ToDo
//
//  Created by Антон on 17.11.2022.
//


protocol PasswordSettingsVCOutput: AnyObject { }

protocol PasswordSettingsVCInput: AnyObject { }

import UIKit

//MARK: - VIEW
class PasswordSettingsVC: UIViewController {
	
	//MARK: - PROPERTY
	private let tableView = UITableView()
	private let gradient = CAGradientLayer()
	private let usePasswordLabel = UILabel()
	private let infoPasswordLabel = UILabel()
	private let passwordSwitch = UISwitch()
	private let oldPasswordTextField = UITextField()
	private let newPasswordTextField = UITextField()
	private let confirmPasswordTextField = UITextField()
	private let textFieldStackView = UIStackView()
	private let keyboardToolbarNew = UIToolbar()
	private let keyboardToolbarOld = UIToolbar()
	private let keyboardToolbarConfirm = UIToolbar()
	
	
	var viewModel: PasswordSettingsVCViewModelProtocol?
	
	//MARK: - LIVECYCLE
	override func viewDidLoad() {
		super.viewDidLoad()
		Theme.switchTheme(gradient: gradient, view: view, traitCollection: traitCollection)
		usePasswordLabelSetup()
		infoPasswordLabelSetup()
		usePasswordSwitchSetup()
		textFieldStackViewSetup()
		newPasswordTextFieldSetup()
		oldPasswordTextFieldSetup()
		confirmPasswordTextFieldSetup()
		setupTextFieldToolBar(title: NSLocalizedString("next", comment: ""), toolBar: keyboardToolbarOld, action: #selector(nextOldAction))
		setupTextFieldToolBar(title: NSLocalizedString("next", comment: ""), toolBar: keyboardToolbarNew, action: #selector(nextNewAction))
		setupTextFieldToolBar(title: NSLocalizedString("save", comment: ""), toolBar: keyboardToolbarConfirm, action: #selector(saveAction))
		addSubview()
		layout()
	}
	
	var password = ""
	var confirmPassword = ""
	var newPassword = ""
	var oldPassword = ""
	//MARK: - SETUP
	
	private func infoPasswordLabelSetup() {
		infoPasswordLabel.text = ""
		infoPasswordLabel.textAlignment = .center
		infoPasswordLabel.numberOfLines = 2
		
	}
	
	private func usePasswordLabelSetup() {
		usePasswordLabel.text = "Passcode & FaceID"
	}
	private func usePasswordSwitchSetup() {
		passwordSwitch.addTarget(self, action: #selector(turnPassword(sender:)), for: .valueChanged)
	}
	
	private func oldPasswordTextFieldSetup() {
		oldPasswordTextField.isHidden = true
		oldPasswordTextField.placeholder = "...enter the old password"
		oldPasswordTextField.keyboardType = .numberPad
		oldPasswordTextField.isSecureTextEntry = true
		oldPasswordTextField.inputAccessoryView = keyboardToolbarOld
		oldPasswordTextField.addTarget(self, action: #selector(enterOldPassword), for: .valueChanged)
	}
	@objc func enterOldPassword() {
		
	}
	private func newPasswordTextFieldSetup() {
		newPasswordTextField.isHidden = true
		newPasswordTextField.placeholder = "...enter the new password"
		newPasswordTextField.keyboardType = .numberPad
		newPasswordTextField.isSecureTextEntry = true
		newPasswordTextField.inputAccessoryView = keyboardToolbarNew
		newPasswordTextField.addTarget(self, action: #selector(enterNewPassword), for: .valueChanged)
	}
	
	@objc func enterNewPassword() {
		guard newPasswordTextField.text!.count < 4 else { return }
		guard newPasswordTextField.text!.count == 4 else { return }
		password = newPasswordTextField.text!
	}
	
	private func confirmPasswordTextFieldSetup() {
		confirmPasswordTextField.isHidden = true
		confirmPasswordTextField.placeholder = "...confirm the new password"
		confirmPasswordTextField.keyboardType = .numberPad
		confirmPasswordTextField.isSecureTextEntry = true
		confirmPasswordTextField.inputAccessoryView = keyboardToolbarConfirm
		confirmPasswordTextField.addTarget(self, action: #selector(confirmNewPassword), for: .valueChanged)
	}
	
	@objc func confirmNewPassword() {
		guard confirmPasswordTextField.text!.count < 4 else { return }
		guard confirmPasswordTextField.text!.count == 4 else { return }
		confirmPassword = confirmPasswordTextField.text!
	}
	
	
	private func textFieldStackViewSetup() {
		textFieldStackView.isHidden = false
		textFieldStackView.axis = .vertical
		textFieldStackView.spacing = 40
		textFieldStackView.alignment = .fill
		textFieldStackView.distribution = .fillEqually
		textFieldStackView.addArrangedSubview(oldPasswordTextField)
		textFieldStackView.addArrangedSubview(newPasswordTextField)
		textFieldStackView.addArrangedSubview(confirmPasswordTextField)
	}
	
	
	private func setupTextFieldToolBar(title: String, toolBar: UIToolbar, action: Selector?) {
		toolBar.barStyle = .default
		toolBar.items=[
			UIBarButtonItem(title: NSLocalizedString("cancel", comment: ""), style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissKeyb)),
			UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil),
			UIBarButtonItem(title: title, style: UIBarButtonItem.Style.plain, target: self, action: action)
		]
		toolBar.sizeToFit()
	}
	
	@objc func dismissKeyb() {
		view.endEditing(true)
	}
	
	@objc func nextOldAction() {
		newPasswordTextField.becomeFirstResponder()
	}
	
	@objc func nextNewAction() {
		newPassword = newPasswordTextField.text!
		confirmPasswordTextField.becomeFirstResponder()
	}
	
	@objc func saveAction() {
		if oldPasswordTextField.isHidden == false {
			guard oldPasswordTextField.text == password else { print("wrong old password"); return }
			oldPasswordTextField.isHidden = true
		}
		guard oldPasswordTextField.isHidden == true else { return }
		guard newPassword == confirmPassword else { print("wrong confirm password"); return }
		password = newPassword
		print("Success")
		view.endEditing(true)
		infoPasswordLabel.text = "The password is set!\n You can change your password"
		oldPasswordTextField.text = ""
		newPasswordTextField.text = ""
		confirmPasswordTextField.text = ""
		oldPasswordTextField.isHidden = false
		newPasswordTextField.isHidden = false
		confirmPasswordTextField.isHidden = false
		//	viewModel.saveDescription(description: textView.text, descriptionSize: stepper.value, view: view)
	}
	
	@objc func turnPassword(sender: UISwitch) {
		print(#function)
		if sender.isOn == true {
			infoPasswordLabel.text = "Create and confirm your new password"
			oldPasswordTextField.isHidden = true
			newPasswordTextField.isHidden = false
			confirmPasswordTextField.isHidden = false
		} else {
			print("else")
			infoPasswordLabel.text = "To confirm, enter your old password"
			oldPasswordTextField.isHidden = false
			newPasswordTextField.isHidden = true
			confirmPasswordTextField.isHidden = true
		}
	}
	
}

//MARK: - LAYOUT
extension PasswordSettingsVC {
	private func addSubview() {
		view.addSubview(tableView)
		view.addSubview(usePasswordLabel)
		view.addSubview(passwordSwitch)
		view.addSubview(infoPasswordLabel)
		view.addSubview(textFieldStackView)
	}
	
	private func layout() {
		usePasswordLabel.translatesAutoresizingMaskIntoConstraints = false
		usePasswordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
		usePasswordLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
		usePasswordLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
		
		passwordSwitch.translatesAutoresizingMaskIntoConstraints = false
		passwordSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
		passwordSwitch.centerYAnchor.constraint(equalTo: usePasswordLabel.centerYAnchor).isActive = true
		
		infoPasswordLabel.translatesAutoresizingMaskIntoConstraints = false
		infoPasswordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
		infoPasswordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
		infoPasswordLabel.topAnchor.constraint(equalTo: usePasswordLabel.bottomAnchor, constant: 40).isActive = true
		infoPasswordLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
		
		textFieldStackView.translatesAutoresizingMaskIntoConstraints = false
		textFieldStackView.widthAnchor.constraint(equalToConstant: 335).isActive = true
		textFieldStackView.bottomAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: view.bottomAnchor, multiplier: -400).isActive = true //view.bottomAnchor, constant: -335).isActive = true
		textFieldStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		textFieldStackView.topAnchor.constraint(equalTo: infoPasswordLabel.bottomAnchor, constant: 40).isActive = true
	}
}
