//
//  SecondVC.swift
//  ToDo
//
//  Created by Антон on 28.08.2022.
//

import UIKit

//MARK: - Static Property
fileprivate enum Constants {
	static var buttonTitle: String { NSLocalizedString("Change language", comment: "") }
	static var buttonFont: UIFont { UIFont(name: "Helvetica Neue", size: 18)!}
	static var buttonBackgroundColor: UIColor { UIColor.newTaskButtonColor ?? .white }
}

//MARK: - SettingVC
final class SettingVC: UIViewController {
	
	//MARK: - Properties
	private var segmentedControllerTheme = UISegmentedControl()
	private var buttonChangeLanguage = UIButton()
	private var gradient = CAGradientLayer()
	let viewModel: SettingViewModelProtocol
	
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
		viewModel.createNavController(view: self)
		segmentedControllerSetup()
		languageControllerSetup()
		addSubviewAndConfigure()
		setConstraits()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(false)
		CurrentTabBar.number = 3
	}
	
	//MARK: - Setup
	private func languageControllerSetup() {
		buttonChangeLanguage = UIButton(title: Constants.buttonTitle, font: Constants.buttonFont)
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
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		Theme.switchTheme(gradient: gradient, view: view, traitCollection: view.traitCollection)
	}
	
	//MARK: - addSubviewAndConfigure
	private func addSubviewAndConfigure(){
		self.view.addSubview(segmentedControllerTheme)
		self.view.addSubview(buttonChangeLanguage)
	}
	
	//MARK: - SetConstraits
	private func setConstraits() {
		self.segmentedControllerTheme.translatesAutoresizingMaskIntoConstraints = false
		self.segmentedControllerTheme.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive = true
		self.segmentedControllerTheme.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30).isActive = true
		self.segmentedControllerTheme.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -120).isActive = true
		
		self.buttonChangeLanguage.translatesAutoresizingMaskIntoConstraints = false
		self.buttonChangeLanguage.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive = true
		self.buttonChangeLanguage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30).isActive = true
		self.buttonChangeLanguage.heightAnchor.constraint(equalToConstant: 35).isActive = true
		self.buttonChangeLanguage.bottomAnchor.constraint(equalTo: self.segmentedControllerTheme.topAnchor, constant: -30).isActive = true
	}
}
