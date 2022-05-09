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
		return coreDataModel.count
	}
	
//	//MARK: Delete Cell
//	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//		coreDataMethods.deleteCell(indexPath: indexPath)
//	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell  = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as! CustomCell
		let items = coreDataModel[indexPath.row]
		cell.taskTime.text            = items.taskTime
		cell.taskTitle.text           = items.taskTitle
		cell.alarmImageView.isHidden  = items.alarmImage
		cell.repeatImageView.isHidden = items.repeatImage
		cell.buttonCell.isEnabled     = items.check
		return cell
	}
	
	
	//MARK: - Notification
	func notification(){
		NotificationCenter.default.addObserver(self, selector: #selector(tableViewReloadData), name: Notification.Name("NewTask"), object: .none)
	}
	
	@objc func tableViewReloadData(notification: NSNotification){
		fetchRequest()
		self.tableView.reloadData()
	}
	
	
	//MARK: - Fetch Request
	func fetchRequest(){
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()
		do{
			coreDataModel = try context.fetch(fetchRequest)
		} catch let error as NSError {
			print(error.localizedDescription)
		}
	}
}
