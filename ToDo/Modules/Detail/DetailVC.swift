//
//  DetailVC.swift
//  ToDo
//
//  Created by Антон on 07.11.2022.
//

import Foundation
import UIKit

//MARK: - VIEW
final class DetailVC: UIViewController {
	static var shared = DetailVC()
	//MARK: - PROPERTY
	private let textView = UITextView()
	private	var infoLaber = UILabel()
	private let stepper = UIStepper()
	private let keyboardToolbar = UIToolbar()
	private let voiceButton = UIButton(type: .system)
	private	var rightButtonItem = UIBarButtonItem()
	private let navigationBar = UINavigationBar()
	private let gradient = CAGradientLayer()
	var viewModel: DetailViewModelProtocol!
	

	
	//MARK: - LIVECYCLE
	override func viewDidLoad() {
		super.viewDidLoad()
		Theme.switchTheme(gradient: gradient, view: view, traitCollection: traitCollection)
		setupTextView()
		setupInfoLaber()
		setupStepper()
		createNavInfo()
		setupButton()
		setupTextFieldToolBar()
		addSubview()
		layout()
	}
	
	//MARK: - SETUP
	private func setupTextView() {
		textView.inputAccessoryView = keyboardToolbar
		textView.backgroundColor = .white
		textView.layer.cornerRadius = 8
		textView.font = UIFont(name: Constants.descriptionFont, size: viewModel.data.descriptSize)
		textView.text = viewModel.data.descript
	}
	
	
	private func setupInfoLaber() {
		infoLaber.backgroundColor = .clear
		infoLaber.numberOfLines = 0
		infoLaber.textAlignment = .center
		infoLaber.text = Title.infoLabelText
	}
	
	private func createNavInfo()  {
		rightButtonItem = UIBarButtonItem(image: Constants.infoLabelImage,
																			style: .plain,
																			target: self,
																			action: #selector(goToInfo))
		navigationItem.rightBarButtonItem = rightButtonItem
		navigationBar.items               = [navigationItem]
	}
	
	@objc func goToInfo() {
		present(viewModel.infoAlert, animated: true)
	}
	
	
	
	private func setupStepper() {
		stepper.value = viewModel.data.descriptSize
		stepper.minimumValue = Constants.minimumTextSize
		stepper.maximumValue = Constants.maximumTextSize
		stepper.addTarget(self, action: #selector(textSizeChange(sender:)), for: .allEvents)
	}
	
	@objc func textSizeChange(sender: UIStepper) {
		viewModel.textSizeChange(textView, Constants.descriptionFont, sender.value)
	}
	
	private func setupTextFieldToolBar() {
		keyboardToolbar.barStyle = .default
		keyboardToolbar.items=[
			UIBarButtonItem(title: Title.leftNumToolBar, style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissKeyb)),
			UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil),
			UIBarButtonItem(title: Title.rightNumToolBar, style: UIBarButtonItem.Style.plain, target: self, action: #selector(okAction))
		]
		keyboardToolbar.sizeToFit()
	}
	
	@objc func dismissKeyb() {
		view.endEditing(true)
	}
	
	@objc func okAction() {
		viewModel.saveDescription(description: textView.text, descriptionSize: stepper.value, view: view)
	}
	
	private func setupButton() {
		voiceButton.backgroundColor = .clear
		voiceButton.setImage(UIImage(systemName: Constants.voiceButtonImage,
																 withConfiguration: Constants.config)?.withTintColor(Constants.recordButtonColor,
																																										 renderingMode: .alwaysOriginal), for: .normal)
		voiceButton.contentMode = .scaleToFill
		voiceButton.layer.shadowColor = UIColor.black.cgColor
		voiceButton.layer.shadowRadius = 3
		voiceButton.layer.shadowOpacity = 0.2
		voiceButton.layer.shadowOffset = CGSize(width: 0, height: 3 )
		voiceButton.addTarget(self, action: #selector(goToRecord), for: .touchUpInside)
	}
	
	@objc func goToRecord() {
		viewModel.goToRecord()
		super.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
	}
}


//MARK: - LAYOUT
extension DetailVC {
	
	private func addSubview() {
		view.addSubview(textView)
		view.addSubview(infoLaber)
		view.addSubview(stepper)
		view.addSubview(voiceButton)
	}
	
	private func layout() {
		textView.translatesAutoresizingMaskIntoConstraints = false
		textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
		textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
		textView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		textView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
		
		stepper.translatesAutoresizingMaskIntoConstraints = false
		stepper.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: 0).isActive = true
		stepper.bottomAnchor.constraint(equalTo: textView.topAnchor, constant: -10).isActive = true
		
		infoLaber.translatesAutoresizingMaskIntoConstraints = false
		infoLaber.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
		infoLaber.bottomAnchor.constraint(equalTo: textView.topAnchor, constant: -30).isActive = true
		infoLaber.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
		infoLaber.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -120).isActive = true
		
		voiceButton.translatesAutoresizingMaskIntoConstraints = false
		voiceButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
		voiceButton.leadingAnchor.constraint(equalTo: infoLaber.trailingAnchor, constant: 30).isActive = true
		voiceButton.bottomAnchor.constraint(equalTo: stepper.topAnchor, constant: -10).isActive = true
		voiceButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
	}
}


fileprivate enum Constants {
	static var minimumTextSize: Double = 15
	static var maximumTextSize: Double = 30
	static var recordButtonColor: UIColor = .white
	static var config: UIImage.SymbolConfiguration { UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .medium) }
	static var infoLabelImage: UIImage { UIImage(systemName: "info.circle")! }
	static var descriptionFont = "Helvetica Neue Medium"
	static var voiceButtonImage = "mic"
}

fileprivate enum Title{
	static var leftNumToolBar = NSLocalizedString("cancel", comment: "")
	static var rightNumToolBar = NSLocalizedString("save", comment: "")
	static var infoLabelText = NSLocalizedString("you can add a description and create a voice note", comment: "")
}
