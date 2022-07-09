//
//  MainVC+ext.swift
//  ToDo
//
//  Created by Антон on 09.05.2022.
//

import CoreData
import UIKit

extension MainVC: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return CoreDataMethods.shared.coreDataModel.count
	}
	
	//MARK: Delete Cell
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		CoreDataMethods.shared.deleteCell(indexPath: indexPath, presentedViewController: self)
	}
	
	//MARK: CellForRowAt
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		 CustomCellVM.shared.setupCustomCell(tableView: tableView, indexPath: indexPath)
	}
	

	//MARK: - Notification
	func notification() {
		NotificationCenter.default.addObserver(self, selector: #selector(tableViewReloadData), name: Notification.Name("TableViewReloadData"), object: .none)
	}
	@objc func tableViewReloadData(notification: NSNotification){
		CoreDataMethods.shared.fetchRequest()
		self.tableView.reloadData()
	}
}
