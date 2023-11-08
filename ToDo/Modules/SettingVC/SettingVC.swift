//
//  SecondVC.swift
//  ToDo
//
//  Created by Антон on 28.08.2022.
//

import UIKit

//MARK: - Static Property
fileprivate enum Constants {
	static var buttonLanguageTitle: String { NSLocalizedString("Change language", comment: "") }
	static var buttonPasswordTitle: String { NSLocalizedString("Password settings", comment: "") }
	static var buttonFont: UIFont { UIFont(name: "Helvetica Neue", size: 18)!}
	static var buttonBackgroundColor: UIColor { UIColor.newTaskButtonColor ?? .white }
}

//MARK: - SettingVC
final class SettingVC: UIViewController {
	
	//MARK: - Properties
	private var segmentedControllerTheme = UISegmentedControl()
	private var buttonChangeLanguage = UIButton()
	private var passwordChange = UIButton()
	private var gradient = CAGradientLayer()
	var viewModel: SettingViewModelProtocol
	
	//MARK: - Init
	init(viewModel: SettingViewModelProtocol) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: - liveCycles
	override func viewDidLoad() {
		super.viewDidLoad()
		Theme.switchTheme(gradient: gradient, view: view, traitCollection: traitCollection)
		viewModel.createNavController(view: self)
		segmentedControllerSetup()
		languageControllerSetup()
		passwordChangeSetup()
		addSubviewAndConfigure()
		setConstraits()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(false)
		CurrentTabBar.number = 3
	}
	
	//MARK: - Setup
	
	private func passwordChangeSetup() {
		passwordChange = UIButton(title: Constants.buttonPasswordTitle, font: Constants.buttonFont)
		passwordChange.layer.cornerRadius = 8
		passwordChange.backgroundColor = Constants.buttonBackgroundColor
		passwordChange.setTitleColor(.label, for: .normal)
		passwordChange.addTarget(self, action: #selector(goToChangePassword), for: .touchUpInside)
	}
    
	private func languageControllerSetup() {
		buttonChangeLanguage = UIButton(title: Constants.buttonLanguageTitle, font: Constants.buttonFont)
		buttonChangeLanguage.layer.cornerRadius = 8
		buttonChangeLanguage.backgroundColor = Constants.buttonBackgroundColor
		buttonChangeLanguage.setTitleColor(.label, for: .normal)
		buttonChangeLanguage.addTarget(self, action: #selector(changeLanguage), for: .touchUpInside)
	}
    
	private func segmentedControllerSetup() {
		segmentedControllerTheme = UISegmentedControl(items: viewModel.getSegmentedItems())
		segmentedControllerTheme.selectedSegmentIndex = MTUserDefaults.shared.theme.rawValue //SegmIndex = themeEnumIndex
		segmentedControllerTheme.addTarget(self, action: #selector(changeTheme(paramTheme:)), for: .valueChanged)
	}
	
	//MARK: - Actions
	@objc private func changeTheme(paramTheme: UISegmentedControl) {
		MTUserDefaults.shared.theme = ThemeEnum(rawValue: paramTheme.selectedSegmentIndex) ?? .system
		view.window?.overrideUserInterfaceStyle = MTUserDefaults.shared.theme.getUserIntefaceStyle()
		Theme.switchTheme(gradient: gradient, view: view, traitCollection: view.traitCollection)
	}
	
	@objc private func changeLanguage() {
		viewModel.changeLanguage()
	}
	
	@objc private func goToChangePassword() {
		viewModel.goToChangePassword()
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		Theme.switchTheme(gradient: gradient, view: view, traitCollection: view.traitCollection)
	}
	
	//MARK: - addSubviewAndConfigure
	private func addSubviewAndConfigure(){
		self.view.addSubview(segmentedControllerTheme)
		self.view.addSubview(passwordChange)
		self.view.addSubview(buttonChangeLanguage)
	}
	
	//MARK: - SetConstraits
	private func setConstraits() {
		segmentedControllerTheme.translatesAutoresizingMaskIntoConstraints = false
		segmentedControllerTheme.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
		segmentedControllerTheme.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
		segmentedControllerTheme.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120).isActive = true
		
		passwordChange.translatesAutoresizingMaskIntoConstraints = false
		passwordChange.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
		passwordChange.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
		passwordChange.heightAnchor.constraint(equalToConstant: 35).isActive = true
		passwordChange.bottomAnchor.constraint(equalTo: buttonChangeLanguage.topAnchor, constant: -30).isActive = true
		
		buttonChangeLanguage.translatesAutoresizingMaskIntoConstraints = false
		buttonChangeLanguage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
		buttonChangeLanguage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
		buttonChangeLanguage.heightAnchor.constraint(equalToConstant: 35).isActive = true
		buttonChangeLanguage.bottomAnchor.constraint(equalTo: segmentedControllerTheme.topAnchor, constant: -30).isActive = true
	}
}
