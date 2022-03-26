//
//  ViewController.swift
//  ToDo
//
//  Created by Антон on 26.03.2022.
//

import UIKit
import CoreData

class MainView: UIViewController {
	
	
	//MARK: - Properties
	var tasksModels: [Tasks] = []
	var tableView = UITableView()
	let buttonNewTask = UIButton(type: .system)
	let indentifire = "Cell"
	let controller = Controller()
	
	//MARK: - viewWillAppear
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()
		do{
			tasksModels = try context.fetch(fetchRequest)
		} catch let error as NSError {
			print(error.localizedDescription)
		}
	}
	
	//MARK: - viewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .blue
		setupButton()
		setupTable()
		setConstraits()
	}
	
	
	func setupButton(){
		self.buttonNewTask.frame = CGRect(x: self.view.bounds.width/2 - 60, y: 670, width: 120, height: 50)
		self.buttonNewTask.backgroundColor = UIColor(named: "BlackWhite")
		self.buttonNewTask.titleLabel?.font = UIFont(name: "Futura", size: 17)
		self.buttonNewTask.setTitle("New task", for: .normal)
		self.buttonNewTask.setTitleColor(UIColor(named: "BWTrue"), for: .normal)
		self.buttonNewTask.layer.cornerRadius = 10
		self.buttonNewTask.addTarget(self, action: #selector(controller.goToNewList), for: .touchUpInside)
		//self.buttonNewTask.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
		tableView.addSubview(buttonNewTask)
	}


	func setupTable() {
		self.tableView = UITableView()
//		self.tableView.frame = CGRect(x: 10, y: 0, width: 0, height: 0)
		self.tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.tableView.backgroundColor = .clear//UIColor(named: "BGColor")
		//self.tableView.isScrollEnabled = true // скроллинг
		self.tableView.bounces = true //если много ячеек прокрутка on. по дефолту off
		self.tableView.separatorStyle = .none
		self.tableView.rowHeight = 60
		self.tableView.translatesAutoresizingMaskIntoConstraints = false
		//view.addSubview(tableView)
	}
	
	func setConstraits() {
	
		view.addSubview(tableView)
		NSLayoutConstraint.activate([
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -2),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
			tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5)
		])
		view.addSubview(buttonNewTask)
		NSLayoutConstraint.activate([
		])
	}
}
