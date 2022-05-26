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
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	
	//MARK: Delete Cell
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		CoreDataMethods.shared.deleteCell(indexPath: indexPath, presentedViewController: self)
	}
	
	//MARK: cellForRowAt
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell   = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as! CustomCell
		let items  = coreDataModel[indexPath.row]
		let button = cell.buttonCell
		button.tag = indexPath.row
		button.addTarget(self, action: #selector(saveCheckmark(sender:)), for: .touchUpInside)
		let timeLabelDate             = items.timeLabelDate
		cell.taskDate.text            = items.taskDate
		cell.taskTime.text            = items.taskTime
		cell.taskTitle.text           = items.taskTitle
		cell.taskTime.isHidden        = !items.alarmImage
		cell.alarmImageView.isHidden  = !items.alarmImage
		cell.repeatImageView.isHidden = !items.repeatImage
		
		
		
		if items.check == false {
			button.backgroundColor = MainVC.shared.view.backgroundColor
			button.setImage(nil, for: .normal)
			if timeLabelDate! < Date() {
			if items.taskTime != "" {
					painting(cell: cell, color: .red, colorTwo: .red)
					strikethroughStyle(cell: cell)
				}else{
					painting(cell: cell, color: .black, colorTwo: .black)
					strikethroughStyle(cell: cell)
				}
//
		}else{
				painting(cell: cell, color: UIColor(white: 0.5, alpha: 1), colorTwo: .black)
				strikethroughStyle(cell: cell)
				}
			sendReminderNotification("Напоминание \(items.taskTime!)", items.taskTitle, items.timeLabelDate!)
		}else{
			button.setImage(UIImage.init(systemName: "checkmark"), for: .normal)
			button.backgroundColor         = .white
			button.tintColor               = .lightGray
			painting(cell: cell, color: .lightGray, colorTwo: .lightGray)
			cell.taskTitle.attributedText  = NSAttributedString(string: "\(cell.taskTitle.text!)", attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
				UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["id_\(items.taskTitle)"])
		}
		
		return cell
	}
	
	private func strikethroughStyle(cell: CustomCell){
		cell.taskTitle.attributedText = NSAttributedString(string: "\(cell.taskTitle.text!)", attributes: [NSAttributedString.Key.strikethroughStyle: nil ?? ""])
	}
	
	private func painting(cell: CustomCell, color: UIColor, colorTwo: UIColor) {
		cell.repeatImageView.tintColor  = color
		cell.alarmImageView.tintColor   = color
		cell.taskTime.textColor         = color
		cell.taskDate.textColor         = color
		cell.taskTitle.textColor        = colorTwo
	}
	
	
	@objc func saveCheckmark(sender: UIButton) {
		//tappedSoft()
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		let model   = coreDataModel[sender.tag]
		model.check.toggle()
		do {
			try context.save()
		} catch let error as NSError {
			print(error.localizedDescription)
		}
		tableView.reloadData()
	}
	
	
	//MARK: - Notification
	func notification(){
		NotificationCenter.default.addObserver(self, selector: #selector(tableViewReloadData), name: Notification.Name("Reload"), object: .none)
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
