//
//  ViewController.swift
//  fabric pattern
//
//  Created by Антон on 05.05.2022.
//

import UIKit
import CoreData

class MainVC: UIViewController {
	
	//MARK: - Properties
	static var shared = MainVC()
	var tableView = UITableView()
	let buttonNewTask = UIButton()
	let newTaskVC = NewTaskVC()
	
	//MARK: - viewWillAppear
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()
		do{
			CoreDataMethods.coreDataModel = try context.fetch(fetchRequest)
		} catch let error as NSError {
			print(error.localizedDescription)
		}
		tableView.reloadData()
	}
	
	
	//MARK: - viewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		setupButton()
		confugureTableView()
	}
	
	func confugureTableView() {
		self.view.backgroundColor = .systemBlue
		self.view.addSubview(tableView)
		self.tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
		self.tableView.backgroundColor  = .clear//UIColor(named: "BGColor")
		self.tableView.bounces          = true //если много ячеек прокрутка on. по дефолту off
		self.tableView.separatorStyle   = .none
		self.tableView.rowHeight        = 60
		self.tableView.isScrollEnabled  = false // скроллинг
		setTableViewDelegates()
		setConstraits()
	}
	
	func setTableViewDelegates(){
		tableView.delegate   = self
		tableView.dataSource = self
	}
	
	func setupButton(){
		self.tableView.addSubview(buttonNewTask)
	 // self.buttonNewTask.frame = CGRect(x: self.view.bounds.width/2 - 60, y: 670, width: 120, height: 50)
		self.buttonNewTask.backgroundColor    = UIColor(named: "BlackWhite")
		self.buttonNewTask.titleLabel?.font   = .futura17()
		self.buttonNewTask.layer.cornerRadius = 10
		self.buttonNewTask.setTitle("New task", for: .normal)
		self.buttonNewTask.setTitleColor(UIColor(named: "WhiteBlack"), for: .normal)
		self.buttonNewTask.addTarget(self, action: #selector(goToNewTaskVC), for: .touchUpInside)
	}
	
	@objc func goToNewTaskVC() {
		Router.shared.present(currentVC: self, presentedVC: newTaskVC)
	}
	
	//MARK: - Set Constraits
	func setConstraits() {
			tableView.translatesAutoresizingMaskIntoConstraints     = false
		  buttonNewTask.translatesAutoresizingMaskIntoConstraints = false
	
			tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -2).isActive       = true
			tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5).isActive   = true
			tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 5).isActive              = true
			tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5).isActive      = true
		
		  buttonNewTask.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -150).isActive = true
		  buttonNewTask.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive               = true
			buttonNewTask.widthAnchor.constraint(equalToConstant: 120).isActive                             = true
			buttonNewTask.heightAnchor.constraint(equalToConstant: 50).isActive                             = true
	}
}


extension MainVC: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return CoreDataMethods.coreDataModel.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell  = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as! CustomCell
		//let items = ViewModel.items[indexPath.row]
		let items = CoreDataMethods.coreDataModel[indexPath.row]
		
		cell.taskTime.text            = items.taskTime
		cell.taskTitle.text           = items.taskTitle
		cell.alarmImageView.isHidden  = items.alarmImage
		cell.repeatImageView.isHidden = items.repeatImage
		cell.buttonCell.isEnabled     = items.check
		return cell
	}
}

