//
//  ViewController.swift
//  fabric pattern
//
//  Created by Антон on 05.05.2022.
//

import UIKit
import Foundation

final class localTaskStruct {
	static var taskStruct = TaskStruct()
}

//MARK: - Main
final class Main: UIViewController {
	//MARK: - Properties
	var tableView = UITableView()
	internal let buttonNewTask = UIButton()
	internal let gradient = CAGradientLayer()
	var buttonNewTaskWidthAnchor: NSLayoutConstraint?
	var buttonNewTaskHeightAnchor: NSLayoutConstraint?
	var viewModel: MainViewModelProtocol!
	
	//MARK: - liveCycles
	override func viewDidLoad() {
		super.viewDidLoad()
		Theme.switchTheme(gradient: gradient, view: view, traitCollection: traitCollection)
		confugureTableView()
		notification()
		setupButton()
		setConstraits()
		viewModel.createNavController(self)
		navigationSetup()
	}
	
	private func navigationSetup() {
		navigationController?.interactivePopGestureRecognizer?.delegate = self
		navigationController?.delegate = self
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		Theme.switchTheme(gradient: gradient, view: view, traitCollection: traitCollection)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(false)
		viewModel.coreDataMethods.fetchRequest()
		CurrentTabBar.number = 1
	}
	
	
	//MARK: - Configure
	
	private func confugureTableView() {
		view.addSubview(tableView)
		tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
		tableView.register(CustomHeader.self, forCellReuseIdentifier: CustomHeader.identifier)
		tableView.backgroundColor  = .clear
		tableView.bounces          = true //если много ячеек прокрутка on. по дефолту off
		tableView.separatorStyle   = .none
		tableView.rowHeight        = Constants.tableViewRowHeight
		tableView.isScrollEnabled  = true
		tableView.delegate         = self
		tableView.dataSource       = self
		tableView.allowsSelection  = false
	}
	
	private func setupButton() {
		buttonNewTask.layer.cornerRadius = Constants.buttonCornerRadius
		let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
		buttonNewTask.setImage(UIImage(systemName: Constants.buttonNewTaskImage, withConfiguration: config)?.withTintColor(.backgroundColor!, renderingMode: .alwaysOriginal), for: .normal)
		buttonNewTask.addTarget(self, action: #selector(goToNewTaskVCDown), for: .touchDown)
		buttonNewTask.addTarget(self, action: #selector(goToNewTaskVC), for: .touchUpInside)
		buttonNewTask.layer.shadowColor = UIColor.black.cgColor
		buttonNewTask.layer.shadowRadius = 3
		buttonNewTask.layer.shadowOpacity = 0.2
		buttonNewTask.layer.shadowOffset = CGSize(width: 0, height: 3 )
		buttonNewTask.backgroundColor = Constants.buttonBackgroundColor
		tableView.addSubview(buttonNewTask)
	}
	
	@objc private func goToNewTaskVCDown() {
		TapticFeedback.shared.soft
		print(buttonNewTaskHeightAnchor?.isActive as Any)
		buttonNewTaskHeightAnchor?.isActive = false
		buttonNewTaskWidthAnchor?.isActive = false
		buttonNewTask.heightAnchor.constraint(equalToConstant: 80).isActive = true
		buttonNewTask.widthAnchor.constraint(equalToConstant: 80).isActive = true
		buttonNewTask.layer.cornerRadius = 40
		UIView.animate(withDuration: 0.1) { [weak self] in
			self?.view.layoutIfNeeded()
		}
	}
	
	@objc private func goToNewTaskVC() {
		buttonNewTaskHeightAnchor = buttonNewTask.heightAnchor.constraint(equalToConstant: 70)
		buttonNewTaskWidthAnchor = buttonNewTask.widthAnchor.constraint(equalToConstant: 70)
		buttonNewTaskHeightAnchor?.isActive = true
		buttonNewTaskWidthAnchor?.isActive = true
		buttonNewTask.layer.cornerRadius = 35
		UIView.animate(withDuration: 0.1) { [weak self] in
			self?.view.layoutIfNeeded()
		}
		if Counter.count == 0 {
			TapticFeedback.shared.light
			Counter.count += 1
		}
		viewModel.goToNewTaskVC()
		Counter.count = 0
	}
	
	
	//MARK: - Set Constraits
	
	private func setConstraits() {
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
		tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
		
		buttonNewTask.translatesAutoresizingMaskIntoConstraints = false
		buttonNewTask.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -135).isActive = true
		buttonNewTask.centerXAnchor.constraint(equalTo: view.trailingAnchor, constant: -66).isActive = true
		buttonNewTaskWidthAnchor = buttonNewTask.widthAnchor.constraint(equalToConstant: 70)
		buttonNewTaskHeightAnchor = buttonNewTask.heightAnchor.constraint(equalToConstant: 70)
		buttonNewTaskWidthAnchor?.isActive = true
		buttonNewTaskHeightAnchor?.isActive = true
	}
	
	//MARK: - Notification, RELOAD TABLE VIEW
	private func notification() {
		NotificationCenter.default.addObserver(self, selector: #selector(popGestureRecognizer), name: Notification.Name("interactivePopGestureRecognizerON"), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(tableViewReloadData), name: Notification.Name("TableViewReloadData"), object: .none)
		NotificationCenter.default.addObserver(self, selector: #selector(goToDetail), name: Notification.Name("tap"), object: .none)
		NotificationCenter.default.addObserver(self, selector: #selector(scrollUp), name: Notification.Name("scrollUp"), object: .none)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	@objc func popGestureRecognizer() {
		navigationController?.interactivePopGestureRecognizer?.isEnabled = true
	}
	
	@objc func goToDetail(notification: NSNotification) {
		guard let userInfo = notification.userInfo else { return }
		guard let buttonTag = userInfo["buttonTag"] else { return }
		let tag: Int = buttonTag as! Int
		viewModel.passData(cellTag: tag)
		viewModel.goToDetail()
	}
	
	@objc func tableViewReloadData(notification: NSNotification) {
		viewModel.coreDataMethods.fetchRequest()
		tableView.reloadData()
	}
	
	@objc func scrollUp(notification: NSNotification) {
		buttonNewTask.isHidden = true
		guard let userInfo = notification.userInfo else { return }
		guard let height = (userInfo["height"]) else { return }
		UIView.animate(withDuration: 0.3, delay: 0) { [weak self] in
			self?.tableView.frame.origin.y = -(height.self as? CGFloat ?? 011)
		}
	}
	
	@objc func keyboardWillHide(sender: NSNotification) {
		tableView.frame.origin.y = 0 // Move view to original position
		buttonNewTask.isHidden = false
	}
}

//MARK: - Extension
extension Main: UITableViewDelegate, UITableViewDataSource {
	
	//MARK: Section
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		viewModel.selectionStructArray[section].row.count
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return viewModel.selectionStructArray.count
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		viewModel.selectionStructArray[section].header
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 30
	}
	
	//MARK: Delete Cell
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		viewModel.editingStyleBody(indexPath: indexPath, view: self) //
	}
	
	//MARK: CellForRowAt
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as! CustomCell
		let key = indexPath.section
		let items: Tasks = viewModel.coreDataModel[indexPath.row]
		let itemsResult = viewModel.cellForRowAtBody(items: items, key: key, indexPath: indexPath)
		viewModel.visualViewCell(items: itemsResult, cell: cell, indexPath: indexPath)
		return cell
	}
}

//MARK: UIGestureRecognizerDelegate
extension Main: UIGestureRecognizerDelegate, UINavigationControllerDelegate {
	func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
		self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
	}
}

//MARK: - enum Constants
fileprivate enum Constants {
	static var buttonTitle: String { "+" }
	static var buttonTitleColor = UIColor.blackWhite
	static var buttonBackgroundColor = UIColor.newTaskButtonColor
	static var buttonCornerRadius: CGFloat { 35 }
	static var tableViewRowHeight: CGFloat { 65 }
	static var buttonFont: UIFont { UIFont(name: "Helvetica Neue Medium", size: 40)!}
	static var backgroundColorView: UIColor { .backgroundColor! }
	static var buttonNewTaskImage = "plus"
}
