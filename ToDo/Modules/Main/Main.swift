//
//  ViewController.swift
//  fabric pattern
//
//  Created by Антон on 05.05.2022.
//
import CoreData
import UIKit
//MARK: - enum Constants

private enum Constants {
	static var mainTitle: String { "my tasks" }
	static var buttonTitle: String { "New task" }
	static var buttonTitleColor: String { "WhiteBlack" }
	static var buttonBackgroundColor: String { "BlackWhite" }
	static var buttonCornerRadius: CGFloat { 10 }
	static var tableViewRowHeight: CGFloat { 60 }
}


//MARK: - Main
class Main: UIViewController {
	
	//MARK: - Properties
	var tableView       = UITableView()
	let buttonNewTask   = UIButton()
	let viewModel: MainViewModelProtocol
	init(viewModel: MainViewModelProtocol) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//let updateTable = AppDelegate()

	//MARK: - liveCycles
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupButton()
		confugureTableView()
		notification()
		//updateTable.delegate = self
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		viewModel.coreDataFetch()
		//updateTable.delegate = self
	}
	
	override func viewDidLayoutSubviews() {
		super.viewWillLayoutSubviews()
		setConstraits()
	}
	
	
	//MARK: - Configure
	
	private func confugureTableView() {
		self.title = Constants.mainTitle
		self.navigationController?.navigationBar.barTintColor = .backgroundColor
		self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.futura20()!, NSAttributedString.Key.foregroundColor: UIColor.white]
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
	
	func setupButton(){
		self.tableView.addSubview(buttonNewTask)
		self.buttonNewTask.backgroundColor    = UIColor(named: Constants.buttonBackgroundColor)
		self.buttonNewTask.titleLabel?.font   = .NoteworthyBold20()
		self.buttonNewTask.layer.cornerRadius = Constants.buttonCornerRadius
		self.buttonNewTask.setTitle(Constants.buttonTitle, for: .normal)
		self.buttonNewTask.setTitleColor(UIColor(named: Constants.buttonTitleColor), for: .normal)
		self.buttonNewTask.addTarget(self, action: #selector(goToNewTaskVC), for: .touchUpInside)
	}
	
	@objc private func goToNewTaskVC() {
		viewModel.goToNewTaskVC()
	}
	
	//MARK: - Set Constraits
	
	private func setConstraits() {
		tableView.translatesAutoresizingMaskIntoConstraints                                             = false
		tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -2).isActive       = true
		tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5).isActive   = true
		tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 5).isActive              = true
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
	
	@objc func tableViewReloadData(notification: NSNotification){
			self.viewModel.coreDataFetch()
		  self.viewModel.reloadTable()
	}
}

//MARK: - Extension
extension Main: UITableViewDelegate, UITableViewDataSource {
//	func tableViewReload() {
//		tableView.reloadData()
//	}
//
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.coreDataModel.count
	}
	
	//MARK: Delete Cell
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		viewModel.tappedRigid()
		viewModel.coreDataDeleteCell(indexPath: indexPath, presentedViewController: self)
	}
	
	//MARK: CellForRowAt
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell   = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as! CustomCell
		let items = viewModel.coreDataModel[indexPath.row]
		viewModel.visualViewCell(items: items, cell: cell, indexPath: indexPath)
		return cell
	}
}


