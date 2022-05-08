//
//  ViewController.swift
//  fabric pattern
//
//  Created by Антон on 05.05.2022.
//

import UIKit

class MainVC: UIViewController {
	
	//MARK: - Properties
	static var shared = MainVC()
	var tableView = UITableView()
	
	//MARK: - viewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
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
	
	func setConstraits() {
			tableView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -2),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
			tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5)
		])
	}
}


extension MainVC: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return ViewModel.items.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell  = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as! CustomCell
		let items = ViewModel.items[indexPath.row]
		
		cell.taskTime.text            = items.taskTime
		cell.taskTitle.text           = items.taskTitle
		cell.alarmImageView.isHidden  = items.alarmImage
		cell.repeatImageView.isHidden = items.repeatImage
		cell.buttonCell.isEnabled     = items.check
		return cell
	}
}

