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
		let cell   = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as! CustomCell //!
		let items  = CoreDataMethods.shared.coreDataModel[indexPath.row]
		visualViewCell(items: items, cell: cell, indexPath: indexPath)
		return cell
	}

//визуальное отоброжение ячеек в зависимости от статуса задачи
	private func visualViewCell(items: Tasks, cell: CustomCell, indexPath: IndexPath) {
		let button = cell.buttonCell
		button.tag = indexPath.row
		button.addTarget(self, action: #selector(saveCheckmark(sender:)), for: .touchUpInside)
		cell.taskDateDate             = items.taskDateDate
		cell.taskTime.text            = items.taskTime
		cell.taskTitle.text           = items.taskTitle
		cell.taskTime.isHidden        = !items.alarmImage
		cell.alarmImageView.isHidden  = !items.alarmImage
		cell.repeatImageView.isHidden = !items.repeatImage
		if items.repeatImage == false {
			cell.taskDate.text            = items.taskDate
		} else {
			cell.taskDate.text            = "every \((Int(items.timeInterval!)!)/60) min"
		}
		
		if items.check == false {                  // если таск не отмечен как выполненный
			button.backgroundColor = MainVC.shared.view.backgroundColor
			button.setImage(nil, for: .normal)
			if items.taskDateDate == nil {           // если у него нет даты и выремени выполнения, то есть нил.
				painting(cell: cell, color: UIColor(white: 0.5, alpha: 1), colorTwo: .black)
				strikethroughStyle(cell: cell)
			} else {                                 // если есть время выполнения
				if items.taskDateDate! < Date() {      // если дата и время просрочены красим в красный
					painting(cell: cell, color: .red, colorTwo: .red)
					strikethroughStyle(cell: cell)
				} else {                               // если не просрочены делаем стандартными
					painting(cell: cell, color: UIColor(white: 0.5, alpha: 1), colorTwo: .black)
					strikethroughStyle(cell: cell)
				}
				LocalNotification.shared.sendReminderNotification("reminder \(items.taskTime!)", items.taskTitle, items.taskDateDate!)
			}
		} else {// если ставим отметку выполненного таскa: красим в серый зачеркиваем и удаляем нотификейшен
			button.setImage(UIImage.init(systemName: "checkmark"), for: .normal)
			button.backgroundColor = .white
			button.tintColor = .lightGray
			painting(cell: cell, color: .lightGray, colorTwo: .lightGray)
			cell.taskTitle.attributedText = NSAttributedString(string: "\(cell.taskTitle.text!)", attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
			UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["id_\(items.taskTitle)"])
			if items.repeatImage == true {
				items.repeatImage = false
				items.alarmImage = false
			}
		}
	}


private func strikethroughStyle(cell: CustomCell) {
	cell.taskTitle.attributedText = NSAttributedString(string: "\(cell.taskTitle.text!)", attributes: [NSAttributedString.Key.strikethroughStyle: nil ?? ""])
}

private func painting(cell: CustomCell, color: UIColor, colorTwo: UIColor) {
	cell.repeatImageView.tintColor  = color
	cell.alarmImageView.tintColor   = color
	cell.taskTime.textColor         = color
	cell.taskDate.textColor         = color
	cell.taskTitle.textColor        = colorTwo
}


	@objc private func saveCheckmark(sender: UIButton) {
		//tappedSoft()
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		let model = CoreDataMethods.shared.coreDataModel[sender.tag]
		model.check.toggle()
		do {
			try context.save()
		} catch let error as NSError {
			print(error.localizedDescription)
		}
		NotificationCenter.default.post(name: Notification.Name("TableViewReloadData"), object: .none)
	}
}
