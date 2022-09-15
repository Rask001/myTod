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
	static var buttonTitle: String { "+" }
	static var buttonTitleColor = UIColor.blackWhite
	static var buttonBackgroundColor = UIColor.newTaskButtonColor
	static var buttonCornerRadius: CGFloat { 35 }
	static var tableViewRowHeight: CGFloat { 60 }
	static var buttonFont: UIFont { UIFont(name: "Helvetica Neue Medium", size: 40)!}
	static var backgroundColorView: UIColor { .backgroundColor! }

}

class localTaskStruct {
static var taskStruct = TaskStruct()
}

//MARK: - Main
final class Main: UIViewController {
	
	
	//MARK: - Properties
	var tableView = UITableView()
	let buttonNewTask = CustomButtonNewTask()
	let navController = UINavigationController()
	let taptic = TapticFeedback()
	let theme = Theme()
	let helper = Helper()
	let gradient = CAGradientLayer()
	var viewModel: MainViewModelProtocol
	static let shared = MainViewModel.self
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
		confugureTableView()
		notification()
		setupButton()
		setConstraits()
		viewModel.createNavController()
		theme.switchTheme(gradient: gradient, view: view, traitCollection: traitCollection)
	}
	
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(false)
		viewModel.coreDataMethods.fetchRequest()
		theme.switchTheme(gradient: gradient, view: view, traitCollection: traitCollection)
	}

	
	//MARK: - Configure
	
	private func confugureTableView() {
		self.view.addSubview(tableView)
		self.tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
		self.tableView.register(CustomHeader.self, forCellReuseIdentifier: CustomHeader.identifier)
		self.tableView.backgroundColor  = .clear
		self.tableView.bounces          = true //если много ячеек прокрутка on. по дефолту off
		self.tableView.separatorStyle   = .none
		self.tableView.rowHeight        = Constants.tableViewRowHeight
		self.tableView.isScrollEnabled  = true // скроллинг
		self.tableView.delegate         = self
		self.tableView.dataSource       = self
		self.tableView.allowsSelection  = true
	}

	
	func setupButton(){
		self.buttonNewTask.layer.cornerRadius = Constants.buttonCornerRadius
		let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
		self.buttonNewTask.setImage(UIImage(systemName: "plus", withConfiguration: config)?.withTintColor(.backgroundColor!, renderingMode: .alwaysOriginal), for: .normal)
		//self.buttonNewTask.addTarget(self, action: #selector(touchDown), for: .touchDown)
		self.buttonNewTask.addTarget(self, action: #selector(goToNewTaskVC), for: .touchDown)
		self.buttonNewTask.layer.shadowColor = UIColor.black.cgColor
		self.buttonNewTask.layer.shadowRadius = 3
		self.buttonNewTask.layer.shadowOpacity = 0.2
		self.buttonNewTask.layer.shadowOffset = CGSize(width: 0, height: 3 )
		self.buttonNewTask.backgroundColor = Constants.buttonBackgroundColor
		self.tableView.addSubview(buttonNewTask)
	}
	
	@objc private func goToNewTaskVC() {
		if Counter.count == 0 {
			TapticFeedback.shared.soft
			Counter.count += 1
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
			self.viewModel.goToNewTaskVC()
			Counter.count = 0 
		}
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
		buttonNewTask.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -31).isActive               = true
		buttonNewTask.widthAnchor.constraint(equalToConstant: 70).isActive                             = true
		buttonNewTask.heightAnchor.constraint(equalToConstant: 70).isActive                             = true
	}
	
	
	//MARK: - Notification, RELOAD TABLE VIEW
	func notification() {
		NotificationCenter.default.addObserver(self, selector: #selector(tableViewReloadData), name: Notification.Name("TableViewReloadData"), object: .none)
		NotificationCenter.default.addObserver(self, selector: #selector(goToDetail), name: Notification.Name("tap"), object: .none)
	}
	@objc func goToDetail(notification: NSNotification) {
		guard let userInfo = notification.userInfo else { return }
		guard let buttonTag = userInfo["buttonTag"] else { return }
		let tag: Int = buttonTag as! Int
	  print(tag)
		passData(cellTag: tag)
		self.viewModel.goToDetail()
	}
	
	func passData(cellTag: Int) {
		CoreDataMethods.shared.fetchRequest()
		let model = CoreDataMethods.shared.coreDataModel
		for items in model {
			let itemsId = helper.createShortIntWithoutStrChar(fromItemsId: items.id)
			if cellTag == itemsId {
				localTaskStruct.taskStruct.taskTitle     = items.taskTitle
				localTaskStruct.taskStruct.createdAt     = items.createdAt
				localTaskStruct.taskStruct.check         = items.check
				localTaskStruct.taskStruct.taskDateDate  = items.taskDateDate
				localTaskStruct.taskStruct.id            = items.id
				localTaskStruct.taskStruct.descript      = items.descript
				localTaskStruct.taskStruct.descriptSize  = items.descriptSize
				//localTaskStruct.taskStruct.descriptFontSize = items.descriptFontSize
			}
		}
	}
	
	
	
	@objc func tableViewReloadData(notification: NSNotification) {
		self.viewModel.coreDataMethods.fetchRequest()
		self.viewModel.reloadTable()
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
		viewModel.editingStyleBody(indexPath: indexPath)
	}
	
	//MARK: CellForRowAt
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell   = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as! CustomCell
		let key = indexPath.section
		let items: Tasks = viewModel.coreDataModel[indexPath.row]
		let itemsResult = viewModel.cellForRowAtBody(items: items, key: key, indexPath: indexPath)
		viewModel.visualViewCell(items: itemsResult, cell: cell, indexPath: indexPath)
		return cell
	}
	
	func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		
		let editButton = UIContextualAction(style: .normal, title: "") {_,_,_ in
		print("work!")
		}
		editButton.backgroundColor = UIColor.backgroundColor
		
		editButton.image = UIImage.init(systemName: "pencil")
		
//		let editButton2 = UIContextualAction(style: .normal, title: "") { action, view, completion in
//		}
//		editButton2.image = UIImage.init(systemName: "star")
//		editButton2.backgroundColor = UIColor.green
		
		return UISwipeActionsConfiguration(actions: [editButton])
	}
}
