//
//  ViewController.swift
//  fabric pattern
//
//  Created by Антон on 05.05.2022.
//
import CoreData
import UIKit
//MARK: - enum Constants

fileprivate enum Constants {
	static var mainTitle: String { "my tasks" }
	static var buttonTitle: String { "New task" }
	static var buttonTitleColor = UIColor.blackWhite
	static var buttonBackgroundColor = UIColor.newTaskButtonColor
	static var buttonCornerRadius: CGFloat { 10 }
	static var tableViewRowHeight: CGFloat { 60 }
}



//MARK: - Main
final class Main: UIViewController {
	
	//MARK: - Properties
	
	var tableView = UITableView()
	let buttonNewTask = UIButton()
	let taptic = TapticFeedback()
	var viewModel: MainViewModelProtocol
	init(viewModel: MainViewModelProtocol) {
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
		viewModel.createNavController()
	}

	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		viewModel.coreDataFetch()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewWillLayoutSubviews()
		setConstraits()
	}
	
	
	//MARK: - Configure
	
	private func confugureTableView() {
		self.view.addSubview(tableView)
		self.view.backgroundColor = .backgroundColor
		self.tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
		self.tableView.backgroundColor  = .clear
		self.tableView.bounces          = true //если много ячеек прокрутка on. по дефолту off
		self.tableView.separatorStyle   = .none
		self.tableView.rowHeight        = Constants.tableViewRowHeight
		self.tableView.isScrollEnabled  = true // скроллинг
		self.tableView.delegate         = self
		self.tableView.dataSource       = self
	}
	
	@objc func cancelFunc(){
		
	}
	@objc func continueFunc(){
		
	}
	func setupButton(){
		self.tableView.addSubview(buttonNewTask)
		self.buttonNewTask.backgroundColor    = Constants.buttonBackgroundColor
		self.buttonNewTask.titleLabel?.font   = .NoteworthyBold20()
		self.buttonNewTask.layer.cornerRadius = Constants.buttonCornerRadius
		self.buttonNewTask.setTitle(Constants.buttonTitle, for: .normal)
		self.buttonNewTask.setTitleColor(Constants.buttonTitleColor, for: .normal)
		self.buttonNewTask.addTarget(self, action: #selector(goToNewTaskVC), for: .touchUpInside)
	}
	
	@objc private func goToNewTaskVC() {
		viewModel.goToNewTaskVC()
	}
	
	//MARK: - Set Constraits
	
	private func setConstraits() {
		tableView.translatesAutoresizingMaskIntoConstraints                                             = false
		tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive                     = true
		tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5).isActive   = true
		tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive                           = true
		tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5).isActive      = true
		
		buttonNewTask.translatesAutoresizingMaskIntoConstraints                                         = false
		buttonNewTask.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100).isActive = true
		buttonNewTask.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive               = true
		buttonNewTask.widthAnchor.constraint(equalToConstant: 120).isActive                             = true
		buttonNewTask.heightAnchor.constraint(equalToConstant: 50).isActive                             = true
	}
	
	
	//MARK: - Notification, RELOAD TABLE VIEW
	func notification() {
		NotificationCenter.default.addObserver(self, selector: #selector(tableViewReloadData), name: Notification.Name("TableViewReloadData"), object: .none)
	}
	
	@objc func tableViewReloadData(notification: NSNotification) {
			self.viewModel.coreDataFetch()
		  self.viewModel.reloadTable()
	}
}


//MARK: - Extension
extension Main: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		viewModel.selectionStructArray[section].row.count
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		viewModel.selectionStructArray.count
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		viewModel.selectionStructArray[section].header
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 44
	}
	
	//MARK: Delete Cell
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		taptic.warning
		if indexPath.section == 0 {
		viewModel.coreDataDeleteCell(indexPath: indexPath, presentedViewController: self, taskModel: viewModel.currentArray)
		} else if indexPath.section == 1{
			viewModel.coreDataDeleteCell(indexPath: indexPath, presentedViewController: self, taskModel: viewModel.overdueArray)
		} else {
			viewModel.coreDataDeleteCell(indexPath: indexPath, presentedViewController: self, taskModel: viewModel.coreDataModel)
		}
	}
	
	//MARK: CellForRowAt
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell   = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as! CustomCell
		let key = indexPath.section
		let items: Tasks
		
		switch key {
		case 0: items = viewModel.currentArray[indexPath.row]
		case 1: items = viewModel.overdueArray[indexPath.row]
		default: items = viewModel.coreDataModel[indexPath.row]
		}

		viewModel.visualViewCell(items: items, cell: cell, indexPath: indexPath)
		return cell
	}
}


