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
	static var mainTitle: String { "today" }
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
	
	var tableView = UITableView()
	let buttonNewTask = UIButton()
	let taptic = TapticFeedback()
	let theme = Theme()
	let viewModel: SecondViewModelProtocol
	let gradient = CAGradientLayer()
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
		//self.navigationController?.setNavigationBarHidden(true, animated: false)
		viewModel.createNavController()
		theme.switchTheme(gradient: gradient, view: view, traitCollection: traitCollection)
		//view.backgroundColor = .backgroundColor
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(false)
		viewModel.coreDataMethods.fetchRequest()
		theme.switchTheme(gradient: gradient, view: view, traitCollection: traitCollection)

			}
	
//	override func viewDidAppear(_ animated: Bool) {
//		super.viewWillAppear(false)
//		theme.switchTheme(gradient: gradient, view: view, traitCollection: traitCollection)
//	}
	
	override func viewDidLayoutSubviews() {
		super.viewWillLayoutSubviews()
		self.tableView.backgroundColor = .clear
		//self.view.applyGradientsLightBackgound(cornerRadius: 0)
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
	}
	
	
	@objc func cancelFunc(){
		
	}
	@objc func continueFunc(){
		
	}
	func setupButton(){
		self.buttonNewTask.backgroundColor    = Constants.buttonBackgroundColor
		self.buttonNewTask.layer.cornerRadius = Constants.buttonCornerRadius
		let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
		self.buttonNewTask.setImage(UIImage(systemName: "plus", withConfiguration: config)?.withTintColor(.backgroundColor!, renderingMode: .alwaysOriginal), for: .normal)
		self.buttonNewTask.addTarget(self, action: #selector(touchDown), for: .touchDown)
		self.buttonNewTask.addTarget(self, action: #selector(goToNewTaskVC), for: .touchUpInside)
		self.buttonNewTask.layer.shadowColor = UIColor.black.cgColor
		self.buttonNewTask.layer.shadowRadius = 3
		self.buttonNewTask.layer.shadowOpacity = 0.2
		self.buttonNewTask.layer.shadowOffset = CGSize(width: 0, height: 3 )
		self.tableView.addSubview(buttonNewTask)
	}
	
	@objc private func touchDown() {
		self.buttonNewTask.layer.shadowRadius = 3
		self.buttonNewTask.layer.shadowOpacity = 0.2
		self.buttonNewTask.layer.shadowOffset = CGSize(width: 0, height: 1 )
	}
	
	@objc private func goToNewTaskVC() {
		viewModel.goToNewTaskVC()
	}
	
	//MARK: - Set Constraits
	
	private func setConstraits() {
		tableView.translatesAutoresizingMaskIntoConstraints                                                = false
		tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive                        = true
		tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5).isActive      = true
		tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive                = true //34
		tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5).isActive         = true
		   
		buttonNewTask.translatesAutoresizingMaskIntoConstraints                                            = false
		buttonNewTask.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100).isActive    = true
		buttonNewTask.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -31).isActive = true
		buttonNewTask.widthAnchor.constraint(equalToConstant: 70).isActive                                 = true
		buttonNewTask.heightAnchor.constraint(equalToConstant: 70).isActive                                = true
	}
	
	
	//MARK: - Notification, RELOAD TABLE VIEW
	func notification() {
		NotificationCenter.default.addObserver(self, selector: #selector(tableViewReloadData), name: Notification.Name("TableViewReloadData"), object: .none)
	}
	
	@objc func tableViewReloadData(notification: NSNotification){
		self.viewModel.coreDataMethods.fetchRequest()
			//self.viewModel.coreDataFetch()
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
