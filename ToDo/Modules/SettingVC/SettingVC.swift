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
	static var buttonFont: UIFont { .systemFont(ofSize: 18, weight: .medium) }
	static var buttonHeight: CGFloat { 56 }
}

//MARK: - SettingVC
final class SettingVC: UIViewController {
	
	//MARK: - Properties
	private var segmentedControllerTheme = UISegmentedControl()
	private var buttonChangeLanguage = UIButton()
	private var passwordChange = UIButton()
	private let controlsStackView = UIStackView()
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
		controlsStackViewSetup()
		addSubviewAndConfigure()
		setConstraits()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(false)
		CurrentTabBar.number = 3
		Theme.switchTheme(gradient: gradient, view: view, traitCollection: view.traitCollection)
		Theme.configureBars(for: self)
		updateLiquidButtonsAppearance()
	}
	
	//MARK: - Setup
	
	private func passwordChangeSetup() {
		passwordChange = UIButton(title: Constants.buttonPasswordTitle, font: Constants.buttonFont)
		configureLiquidButton(passwordChange)
		passwordChange.addTarget(self, action: #selector(goToChangePassword), for: .touchUpInside)
	}
    
	private func languageControllerSetup() {
		buttonChangeLanguage = UIButton(title: Constants.buttonLanguageTitle, font: Constants.buttonFont)
		configureLiquidButton(buttonChangeLanguage)
		buttonChangeLanguage.addTarget(self, action: #selector(changeLanguage), for: .touchUpInside)
	}
	
	private func configureLiquidButton(_ button: UIButton) {
		var configuration = UIButton.Configuration.filled()
		configuration.cornerStyle = .capsule
		configuration.baseForegroundColor = .label
		configuration.baseBackgroundColor = UIColor.white.withAlphaComponent(0.72)
		configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
		button.configuration = configuration
		button.titleLabel?.font = Constants.buttonFont
		button.clipsToBounds = false
		button.layer.cornerRadius = Constants.buttonHeight / 2
		button.layer.cornerCurve = .continuous
		button.layer.borderWidth = 1
		button.layer.borderColor = UIColor.white.withAlphaComponent(0.45).cgColor
		button.layer.shadowColor = UIColor.black.cgColor
		button.layer.shadowOpacity = 0.08
		button.layer.shadowRadius = 16
		button.layer.shadowOffset = CGSize(width: 0, height: 8)
	}
    
		private func segmentedControllerSetup() {
			segmentedControllerTheme = UISegmentedControl(items: viewModel.getSegmentedItems())
			segmentedControllerTheme.selectedSegmentIndex = MTUserDefaults.shared.theme.rawValue //SegmIndex = themeEnumIndex
			segmentedControllerTheme.addTarget(self, action: #selector(changeTheme(paramTheme:)), for: .valueChanged)
		}
	
	private func controlsStackViewSetup() {
		controlsStackView.axis = .vertical
		controlsStackView.alignment = .fill
		controlsStackView.distribution = .fill
		controlsStackView.spacing = 20
	}
	
	//MARK: - Actions
	@objc private func changeTheme(paramTheme: UISegmentedControl) {
		MTUserDefaults.shared.theme = ThemeEnum(rawValue: paramTheme.selectedSegmentIndex) ?? .system
		view.window?.overrideUserInterfaceStyle = MTUserDefaults.shared.theme.getUserIntefaceStyle()
		view.setNeedsLayout()
		
		DispatchQueue.main.async { [weak self] in
			guard let self else { return }
			Theme.switchTheme(gradient: self.gradient, view: self.view, traitCollection: self.view.traitCollection)
			Theme.configureBars(for: self)
			self.updateLiquidButtonsAppearance()
		}
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
		Theme.configureBars(for: self)
		updateLiquidButtonsAppearance()
	}
	
	private func updateLiquidButtonsAppearance() {
		let style = Theme.resolvedInterfaceStyle(for: view.traitCollection)
		let fillColor: UIColor
		let borderColor: UIColor
		let titleColor: UIColor
		
		switch style {
		case .dark:
			fillColor = UIColor.white.withAlphaComponent(0.16)
			borderColor = UIColor.white.withAlphaComponent(0.18)
			titleColor = .white
		default:
			fillColor = UIColor.white.withAlphaComponent(0.72)
			borderColor = UIColor.white.withAlphaComponent(0.45)
			titleColor = .label
		}
		
		[passwordChange, buttonChangeLanguage].forEach { button in
			button.configuration?.baseBackgroundColor = fillColor
			button.configuration?.baseForegroundColor = titleColor
			button.layer.borderColor = borderColor.cgColor
		}
	}
	
	//MARK: - addSubviewAndConfigure
	private func addSubviewAndConfigure(){
		controlsStackView.addArrangedSubview(passwordChange)
		controlsStackView.addArrangedSubview(buttonChangeLanguage)
		controlsStackView.addArrangedSubview(segmentedControllerTheme)
		self.view.addSubview(controlsStackView)
	}
	
	//MARK: - SetConstraits
	private func setConstraits() {
		controlsStackView.translatesAutoresizingMaskIntoConstraints = false
		controlsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
		controlsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
		controlsStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 120).isActive = true
		
			passwordChange.heightAnchor.constraint(equalToConstant: Constants.buttonHeight).isActive = true
			buttonChangeLanguage.heightAnchor.constraint(equalToConstant: Constants.buttonHeight).isActive = true
		segmentedControllerTheme.heightAnchor.constraint(equalToConstant: 34).isActive = true
	}
}
