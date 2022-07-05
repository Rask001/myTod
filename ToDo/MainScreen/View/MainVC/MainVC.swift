//
//  ViewController.swift
//  fabric pattern
//
//  Created by Антон on 05.05.2022.
//

import UIKit

class MainVC: UIViewController {
	
	//MARK: - Properties
	static var shared   = MainVC()
	var tableView       = UITableView()
	let buttonNewTask   = UIButton()
	let newTaskVC       = NewTaskVC()
	
	//MARK: - viewWillAppear
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		CoreDataMethods.shared.fetchRequest()
	}
	
//	var viewModel: CellViewModelProtocol? {
//		didSet {
//			fillUI()
//		}
//	}
	
	//MARK: - viewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		setupButton()
		confugureTableView()
		notification()
		//fillUI()
	}
	
//	fileprivate func fillUI() {
//		if !isViewLoaded { return }
//		guard let viewModel = viewModel else { return }
//
//	}
	
	//MARK: - Mhetods
	private func confugureTableView() {
		self.view.backgroundColor = .backgroundColor
		self.view.addSubview(tableView)
		self.tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
		self.tableView.backgroundColor  = .clear//UIColor(named: "BGColor")
		self.tableView.bounces          = true //если много ячеек прокрутка on. по дефолту off
		self.tableView.separatorStyle   = .none
		self.tableView.rowHeight        = 60
		self.tableView.isScrollEnabled  = true // скроллинг
		setTableViewDelegates()
		setConstraits()
	}
	
	private func setTableViewDelegates(){
		tableView.delegate   = self
		tableView.dataSource = self
	}
	
	func setupButton(){
		self.tableView.addSubview(buttonNewTask)
		self.buttonNewTask.backgroundColor    = UIColor(named: "BlackWhite")
		self.buttonNewTask.titleLabel?.font   = .NoteworthyBold20()
		self.buttonNewTask.layer.cornerRadius = 10
		self.buttonNewTask.setTitle("New task", for: .normal)
		self.buttonNewTask.setTitleColor(UIColor(named: "WhiteBlack"), for: .normal)
		self.buttonNewTask.addTarget(self, action: #selector(goToNewTaskVC), for: .touchUpInside)
	}
	
	@objc private func goToNewTaskVC() {
		present(newTaskVC, animated: true, completion: nil)
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
}
