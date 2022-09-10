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


//MARK: - Main
final class Main: UIViewController {
	
	//MARK: - Properties
	
	var tableView = UITableView()
	let buttonNewTask = UIButton()
	let navController = UINavigationController()
	let taptic = TapticFeedback()
	let theme = Theme()
	let gradient = CAGradientLayer()
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
		confugureTableView()
		notification()
		setupButton()
		setConstraits()
		viewModel.createNavController()
		theme.switchTheme(gradient: gradient, view: view, traitCollection: traitCollection)
		//view.backgroundColor = .backgroundColor
		//self.view.applyGradientsLightBackgound(cornerRadius: 0)
	}
	
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(false)
		viewModel.coreDataMethods.fetchRequest()
		theme.switchTheme(gradient: gradient, view: view, traitCollection: traitCollection)
	}
		
//	override func viewWillLayoutSubviews() {
//		super.viewWillLayoutSubviews()
//	}
	
//	override func viewDidLayoutSubviews() {
//		super.viewDidLayoutSubviews()
//	}
	//scrollView.contentInsetAdjustmentBehavior = .automatic
	
	//MARK: - Configure
	
	private func confugureTableView() {
		self.view.addSubview(tableView)
		//self.view.backgroundColor = Theme.current.backgroundColor
		self.tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
		self.tableView.register(CustomHeader.self, forCellReuseIdentifier: CustomHeader.identifier)
		//self.tableView.backgroundColor  = .backgroundColor //.clear
		self.tableView.backgroundColor  = .clear
		self.tableView.bounces          = true //если много ячеек прокрутка on. по дефолту off
		self.tableView.separatorStyle   = .none
		self.tableView.rowHeight        = Constants.tableViewRowHeight
		self.tableView.isScrollEnabled  = true // скроллинг
		self.tableView.delegate         = self
		self.tableView.dataSource       = self
		//self.tableView.contentInsetAdjustmentBehavior = .always
	}

	override func viewWillLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
//		if UserDefaults.standard.object(forKey: "LightTheme") != nil {
//			self.view.applyGradientsLightBackgound(cornerRadius: 0)
//		} else {
//			self.view.applyGradientsDarkBackgound(cornerRadius: 0)
//		}
	}
//		if self.traitCollection.userInterfaceStyle == .dark {
//			self.view.applyGradientsDarkBackgound(cornerRadius: 0)
//		} else {
//			self.view.applyGradientsLightBackgound(cornerRadius: 0)
//		}
//	}
	
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		 }

		 override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
			 }
	
	func setupButton(){
		//self.buttonNewTask.backgroundColor    = Constants.buttonBackgroundColor
		self.buttonNewTask.layer.cornerRadius = Constants.buttonCornerRadius
		let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
		self.buttonNewTask.setImage(UIImage(systemName: "plus", withConfiguration: config)?.withTintColor(.backgroundColor!, renderingMode: .alwaysOriginal), for: .normal)
		self.buttonNewTask.addTarget(self, action: #selector(touchDown), for: .touchDown)
		self.buttonNewTask.addTarget(self, action: #selector(goToNewTaskVC), for: .touchUpInside)
		self.buttonNewTask.layer.shadowColor = UIColor.black.cgColor
		self.buttonNewTask.layer.shadowRadius = 3
		self.buttonNewTask.layer.shadowOpacity = 0.2
		self.buttonNewTask.layer.shadowOffset = CGSize(width: 0, height: 3 )
		self.buttonNewTask.backgroundColor = Constants.buttonBackgroundColor
		//self.buttonNewTask.applyGradients(cornerRadius: Constants.buttonCornerRadius)
		//self.buttonNewTask.draw(CGRect(origin: CGPoint(x: 5, y: 5), size: CGSize(width: 10, height: 10)))
		//let gradientView = GradientView(from: .top, to: .bottom, startColor: .systemBlue, endColor: .systemYellow)
		
		self.tableView.addSubview(buttonNewTask)
	}
	
	@objc private func touchDown() {
		self.buttonNewTask.layer.shadowRadius = 3
		self.buttonNewTask.layer.shadowOpacity = 0.2
		self.buttonNewTask.layer.shadowOffset = CGSize(width: 0, height: 1 )
	}
	
	@objc private func goToNewTaskVC() {
		self.buttonNewTask.layer.shadowRadius = 4
		self.buttonNewTask.layer.shadowOpacity = 0.2
		self.buttonNewTask.layer.shadowOffset = CGSize(width: 0, height: 3 )
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
		buttonNewTask.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -31).isActive               = true
		buttonNewTask.widthAnchor.constraint(equalToConstant: 70).isActive                             = true
		buttonNewTask.heightAnchor.constraint(equalToConstant: 70).isActive                             = true
	}
	
	
	//MARK: - Notification, RELOAD TABLE VIEW
	func notification() {
		NotificationCenter.default.addObserver(self, selector: #selector(tableViewReloadData), name: Notification.Name("TableViewReloadData"), object: .none)
	}
	
	@objc func tableViewReloadData(notification: NSNotification) {
		self.viewModel.coreDataMethods.fetchRequest()
		self.viewModel.reloadTable()
	}
}


//MARK: - Extension
extension Main: UITableViewDelegate, UITableViewDataSource {
	
//		func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//			let model = viewModel.selectionStructArray[section]
//			let cell = tableView.dequeueReusableCell(withIdentifier: CustomHeader.identifier) as! CustomHeader
//			cell.setup(model: model)
//			return cell.contentView
//		}
	
//	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//		let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 35))
//		headerView.layer.cornerRadius = 5
//		headerView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
//		return headerView
//	}
	
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
}


