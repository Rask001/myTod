//
//  PasswordVC.swift
//  ToDo
//
//  Created by Антон on 15.11.2022.
//

import Foundation
import UIKit
import LocalAuthentication

fileprivate enum Constants {
	static var deleteButtonImage: String { "delete.left" }
	static var faceIdButtonImage: String { "faceid" }
	static var buttonsNumberFont: UIFont { UIFont.systemFont(ofSize: 40, weight: .ultraLight) }
	static var passwordFont: UIFont { UIFont.systemFont(ofSize: 40, weight: .ultraLight) }
	static var statusPasswordLabel = NSLocalizedString("enter password", comment: "")
	static var statusPasswordLabelFont: UIFont { UIFont.systemFont(ofSize: 20, weight: .ultraLight) }
	static var statusWrongPasswordLabel = NSLocalizedString("wrong password", comment: "")
	static var config: UIImage.SymbolConfiguration { UIImage.SymbolConfiguration(pointSize: 40, weight: .ultraLight, scale: .large) }
	static var passwordColor: UIColor { .systemGray }
	static var buttonsDeleteColor: UIColor { .systemGray }
	static var buttonsFacrIdColor: UIColor { .systemGray }
	static var buttonsNumberColor: UIColor { .systemGray }
}

//MARK: - VIEW
final class PasswordVC: UIViewController {
	
	//MARK: - PROPERTY
	private var buttonNumber = UIButton()
	private var buttonFaceID = UIButton()
	private var buttonZero = UIButton()
	private var buttonDelete = UIButton()
	private var buttonStackView = UIStackView()
	private var buttonStackViewH = UIStackView()
	private var buttonStackViewH2 = UIStackView()
	private var buttonStackViewH3 = UIStackView()
	private var buttonStackBottom = UIStackView()
	private var statusPassword = UILabel()
	private var password = UITextField()
	var viewModel: PasswordVCViewModelProtocol!
	
	//MARK: - LIVECYCLE
	override func viewDidLoad() {
		super.viewDidLoad()
		addSubview()
		layout()
		setupEnterPassword()
		setupPassword()
		setupVerticalStackView()
		createMonthButton()
		buttonFaceID = createBottomButtons(10, Constants.faceIdButtonImage, Constants.buttonsFacrIdColor)
		buttonDelete = createBottomButtons(11, Constants.deleteButtonImage, Constants.buttonsDeleteColor)
		setupZeroButton()
		setupButtonStackBottom()
	}
	
	//MARK: - SETUP
	private func setupEnterPassword() {
		statusPassword.text = Constants.statusPasswordLabel
		statusPassword.font = Constants.statusPasswordLabelFont
		statusPassword.textAlignment = .center
		statusPassword.numberOfLines = 0
	}
	
	private func setupPassword() {
		password.text = ""
		password.textColor = Constants.passwordColor
		password.font = Constants.passwordFont
		password.isSecureTextEntry = true
		password.textAlignment = .center
	}
	
	private func createBottomButtons(_ tag: Int, _ imageSystemName: String, _ color: UIColor) -> UIButton {
		let button = UIButton(backrounColor: .clear,
													title: "",
													isShadow: true,
													font: UIFont.systemFont(ofSize: 20, weight: .light),
													cornerRaadius: 0)
		button.setTitleColor(UIColor.systemGray, for: .normal)
		button.tag = tag
		button.addTarget(self, action: #selector(touchButtonMonth(sender:)), for: .touchUpInside)
		button.setImage(UIImage(systemName: imageSystemName,
														withConfiguration: Constants.config)?.withTintColor(color,
																																								renderingMode: .alwaysOriginal), for: .normal)
		return button
	}
	
	private func setupZeroButton() {
		buttonZero = UIButton(backrounColor: .clear, title: "0", isShadow: true, font: Constants.buttonsNumberFont, cornerRaadius: 0)
		buttonZero.setTitleColor(Constants.buttonsNumberColor, for: .normal)
		buttonZero.tag = 0
		buttonZero.addTarget(self, action: #selector(touchButtonMonth(sender:)), for: .touchUpInside)
	}
	
	private func goToMainViewPassword() {
		guard password.text?.count == 4 else { return }
		guard password.text == "4565" else {
			TapticFeedback.shared.error
			statusPassword.text = Constants.statusWrongPasswordLabel
			password.text = ""
			viewModel.animations.shake(text: statusPassword, duration: 0.5)
			return
		}
		viewModel.goToMainViewPassword()
	}
	
	private func goToMainViewFaceId() {
		viewModel.checkFaceId(view: self)
	}
}


//MARK: - CREATE BUTTONS
extension PasswordVC {
	
	private func createMonthButton() {
		var monthButtonArray = [Int]()
		for num in 1...9 {
			monthButtonArray.append(num)
		}
		var buttonTag = 0
		let buttonArrStr = monthButtonArray.map{"\($0)"}
		for i in buttonArrStr {
			buttonNumber = UIButton(title: i, isShadow: true, font: Constants.buttonsNumberFont, cornerRaadius: 0)
			buttonTag += 1
			buttonNumber.tag = buttonTag
			buttonNumber.setTitleColor(Constants.buttonsNumberColor, for: .normal)
			buttonNumber.backgroundColor = .clear
			buttonNumber.addTarget(self, action: #selector(touchButtonMonth(sender:)), for: .touchUpInside)
			buttonNumber.heightAnchor.constraint(equalTo: buttonNumber.widthAnchor).isActive = true
			addMonthButtonInStackView(buttonNumber)
		}
		buttonStackView.addArrangedSubview(buttonStackViewH)
		buttonStackView.addArrangedSubview(buttonStackViewH2)
		buttonStackView.addArrangedSubview(buttonStackViewH3)
		buttonStackView.addArrangedSubview(buttonStackBottom)
		buttonStackViewSetup()
	}
	
	private func addMonthButtonInStackView(_ button: UIButton) {
		switch button.tag {
		case 1...3: buttonStackViewH.addArrangedSubview(button)
		case 4...6: buttonStackViewH2.addArrangedSubview(button)
		case 7...9: buttonStackViewH3.addArrangedSubview(button)
		default:
			break
		}
	}
	
	private func setupVerticalStackView() {
		let arrStackView = [buttonStackViewH,
												buttonStackViewH2,
												buttonStackViewH3,
												buttonStackBottom,
		]
		for stackView in arrStackView {
			stackView.isHidden = false
			stackView.axis = .horizontal
			stackView.spacing = 20
			stackView.alignment = .fill
			stackView.distribution = .fillEqually
		}
	}
	
	private func buttonStackViewSetup() {
		buttonStackView.isHidden = false
		buttonStackView.axis = .vertical
		buttonStackView.spacing = 15
		buttonStackView.alignment = .fill
		buttonStackView.distribution = .fillEqually
	}
	
	private func setupButtonStackBottom() {
		buttonStackBottom.addArrangedSubview(buttonFaceID)
		buttonStackBottom.addArrangedSubview(buttonZero)
		buttonStackBottom.addArrangedSubview(buttonDelete)
	}
	
	@objc func touchButtonMonth(sender: UIButton) {
		if sender.tag == 11 {
			guard password.text != "" else { return }
			password.text?.removeLast()
		}
		guard password.text!.count < 4 else { return }
		statusPassword.text = Constants.statusPasswordLabel
		TapticFeedback.shared.soft
		let button = sender
		switch button.tag {
		case 0: password.text! += "0"
		case 1: password.text! += "1"
		case 2: password.text! += "2"
		case 3: password.text! += "3"
		case 4: password.text! += "4"
		case 5: password.text! += "5"
		case 6: password.text! += "6"
		case 7: password.text! += "7"
		case 8: password.text! += "8"
		case 9: password.text! += "9"
		case 10: goToMainViewFaceId()
		default:
			break
		}
		goToMainViewPassword()
	}
}


//MARK: - LAYOUT
extension PasswordVC {
	private func addSubview() {
		view.backgroundColor = .secondarySystemBackground
		view.addSubview(buttonStackView)
		view.addSubview(statusPassword)
		view.addSubview(password)
	}
	
	private func layout() {
		buttonStackView.translatesAutoresizingMaskIntoConstraints = false
		buttonStackView.widthAnchor.constraint(equalToConstant: 280).isActive = true
		buttonStackView.heightAnchor.constraint(equalToConstant: 365).isActive = true
		buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		buttonStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
		
		statusPassword.translatesAutoresizingMaskIntoConstraints = false
		statusPassword.widthAnchor.constraint(equalToConstant: 200).isActive = true
		statusPassword.heightAnchor.constraint(equalToConstant: 60).isActive = true
		statusPassword.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		statusPassword.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -100).isActive = true
		
		password.translatesAutoresizingMaskIntoConstraints = false
		password.widthAnchor.constraint(equalToConstant: 200).isActive = true
		password.heightAnchor.constraint(equalToConstant: 60).isActive = true
		password.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		password.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -50).isActive = true
	}
}
