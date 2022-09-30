//
//  SecondVC.swift
//  ToDo
//
//  Created by Антон on 28.08.2022.
//

import CoreData
import UIKit
//MARK: - enum Constants

fileprivate enum Constants {
	//static var mainTitle: String { "today" }
	static var buttonTitle: String { "+" }
	static var buttonTitleColor = UIColor.blackWhite
	static var buttonBackgroundColor = UIColor.newTaskButtonColor
	static var buttonCornerRadius: CGFloat { 35 }
	static var tableViewRowHeight: CGFloat { 60 }
  static var textButtonFont: UIFont { UIFont(name: "Helvetica Neue Medium", size: 40)!}
	static var navigationTitleFont: UIFont { UIFont(name: "Futura", size: 20)!}
}


//MARK: - Main
final class SecondVC: UIViewController {
	
	
	//MARK: - Properties
	
	internal var tableView = UITableView()
	private let buttonNewTask = UIButton()
	private let taptic = TapticFeedback()
	private let viewModel: SecondViewModelProtocol
	private let	gradient = CAGradientLayer()
	var buttonNewTaskWidthAnchor: NSLayoutConstraint?
	var buttonNewTaskHeightAnchor: NSLayoutConstraint?
	
	init(viewModel: SecondViewModelProtocol) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	//MARK: - liveCycles
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupButton()
		confugureTableView()
		notification()
		setConstraits()
		viewModel.createNavController()
    Theme.switchTheme(gradient: gradient, view: view, traitCollection: traitCollection)
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
			super.traitCollectionDidChange(previousTraitCollection)
			Theme.switchTheme(gradient: gradient, view: view, traitCollection: traitCollection)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		viewModel.coreDataMethods.fetchRequest()
		CurrentTabBar.number = 2
			}
	
	
	override func viewDidLayoutSubviews() {
		super.viewWillLayoutSubviews()
		self.tableView.backgroundColor = .clear
	}
	
	
	//MARK: - Configure
	
	private func confugureTableView() {
		self.view.addSubview(tableView)
		self.tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
		self.tableView.bounces          = true //если много ячеек прокрутка on. по дефолту off
		self.tableView.separatorStyle   = .none
		self.tableView.rowHeight        = Constants.tableViewRowHeight
		self.tableView.isScrollEnabled  = true // скроллинг
		self.tableView.delegate         = self
		self.tableView.dataSource       = self
		self.tableView.contentInset.top = 20
		NotificationCenter.default.addObserver(self, selector: #selector(goToDetailSecond), name: Notification.Name("tapSecond"), object: .none)
	}
	
		@objc func goToDetailSecond(notification: NSNotification) {
			guard let userInfo = notification.userInfo else { return }
			guard let buttonTag = userInfo["buttonTag"] else { return }
			let tag: Int = buttonTag as! Int
			print(tag)
			passData(cellTag: tag)
			self.viewModel.goToNewTaskSecond()
		}
	
	private func passData(cellTag: Int) {
		CoreDataMethods.shared.fetchRequest()
		let model = CoreDataMethods.shared.coreDataModel
		for items in model {
			let itemsId = Helper.createShortIntWithoutStrChar(fromItemsId: items.id)
			if cellTag == itemsId {
				localTaskStruct.taskStruct.taskTitle     = items.taskTitle
				localTaskStruct.taskStruct.createdAt     = items.createdAt
				localTaskStruct.taskStruct.check         = items.check
				localTaskStruct.taskStruct.taskDateDate  = items.taskDateDate
				localTaskStruct.taskStruct.id            = items.id
				localTaskStruct.taskStruct.descript      = items.descript
				localTaskStruct.taskStruct.descriptSize  = items.descriptSize
			}
		}
	}
	
	
	@objc func cancelFunc(){
		
	}
	@objc func continueFunc(){
		
	}
	private func setupButton(){
		self.buttonNewTask.backgroundColor    = Constants.buttonBackgroundColor
		self.buttonNewTask.layer.cornerRadius = Constants.buttonCornerRadius
		let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
		self.buttonNewTask.setImage(UIImage(systemName: "plus", withConfiguration: config)?.withTintColor(.backgroundColor!, renderingMode: .alwaysOriginal), for: .normal)
		self.buttonNewTask.addTarget(self, action: #selector(goToNewTaskVCDown), for: .touchDown)
		self.buttonNewTask.addTarget(self, action: #selector(goToNewTaskVC), for: .touchUpInside)
		self.buttonNewTask.layer.shadowColor = UIColor.black.cgColor
		self.buttonNewTask.layer.shadowRadius = 3
		self.buttonNewTask.layer.shadowOpacity = 0.2
		self.buttonNewTask.layer.shadowOffset = CGSize(width: 0, height: 3 )
		self.tableView.addSubview(buttonNewTask)
	}
	
	
	@objc private func goToNewTaskVCDown() {
		TapticFeedback.shared.soft
		print(buttonNewTaskHeightAnchor?.isActive as Any)
		buttonNewTaskHeightAnchor?.isActive = false
		buttonNewTaskWidthAnchor?.isActive = false
		buttonNewTask.heightAnchor.constraint(equalToConstant: 80).isActive = true
		buttonNewTask.widthAnchor.constraint(equalToConstant: 80).isActive = true

		self.buttonNewTask.layer.cornerRadius = 40
		UIView.animate(withDuration: 0.1) { [weak self] in
			self?.view.layoutIfNeeded()
		}
	}
	
	@objc private func goToNewTaskVC() {
		buttonNewTaskHeightAnchor = buttonNewTask.heightAnchor.constraint(equalToConstant: 70)
		buttonNewTaskWidthAnchor = buttonNewTask.widthAnchor.constraint(equalToConstant: 70)
		buttonNewTaskHeightAnchor?.isActive = true
		buttonNewTaskWidthAnchor?.isActive = true
		self.buttonNewTask.layer.cornerRadius = 35
		UIView.animate(withDuration: 0.1) { [weak self] in
			self?.view.layoutIfNeeded()
		}
		if Counter.count == 0 {
			TapticFeedback.shared.light
			Counter.count += 1
		}
		  self.viewModel.goToNewTaskSecond()
			Counter.count = 0
	}
	
	
	
	
	
	//MARK: - Set Constraits
	
	private func setConstraits() {
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
		tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5).isActive = true
		tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
		tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5).isActive = true
		   
		buttonNewTask.translatesAutoresizingMaskIntoConstraints = false
		buttonNewTask.centerYAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -135).isActive = true
		buttonNewTask.centerXAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -66).isActive = true
		buttonNewTaskWidthAnchor = buttonNewTask.widthAnchor.constraint(equalToConstant: 70)
		buttonNewTaskHeightAnchor = buttonNewTask.heightAnchor.constraint(equalToConstant: 70)
		buttonNewTaskWidthAnchor?.isActive = true
		buttonNewTaskHeightAnchor?.isActive = true
	}
	
	
	//MARK: - Notification, RELOAD TABLE VIEW
	private func notification() {
		NotificationCenter.default.addObserver(self, selector: #selector(tableViewReloadData), name: Notification.Name("TableViewReloadData"), object: .none)
	}
	
	@objc func tableViewReloadData(notification: NSNotification){
		self.viewModel.coreDataMethods.fetchRequest()
			self.viewModel.reloadTable()
	}
}

//MARK: - Extension
extension SecondVC: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.todayTasksArray.count
	}
	
	//MARK: Delete Cell
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		taptic.warning
		viewModel.coreDataDeleteCell(indexPath: indexPath, presentedViewController: self, taskModel: viewModel.todayTasksArray)
	}
	
	//MARK: CellForRowAt
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell   = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as! CustomCell
		let items = viewModel.todayTasksArray[indexPath.row]
		viewModel.visualViewCell(items: items, cell: cell, indexPath: indexPath)
		return cell
	}
}
