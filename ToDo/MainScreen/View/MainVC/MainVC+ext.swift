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
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	
	//MARK: Delete Cell
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		CoreDataMethods.shared.deleteCell(indexPath: indexPath, presentedViewController: self)
	}
	
	//MARK: CellForRowAt
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		self.setupCustomCell(tableView: tableView, indexPath: indexPath)
	}
	
	//TODO: сделать cell.taskDate.text = "every \(items.timeInterval!) seconds" в норм формат. и вообще переделать реализацию
	//MARK: VisualViewCell
	private func setupCustomCell(tableView: UITableView, indexPath: IndexPath) -> CustomCell {
		let cell   = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as! CustomCell
		let items  = CoreDataMethods.shared.coreDataModel[indexPath.row]
		let button = cell.buttonCell
		button.tag = indexPath.row
		button.addTarget(self, action: #selector(saveCheckmark(sender:)), for: .touchUpInside)
		let timeLabelDate             = items.timeLabelDate
		cell.taskTime.text            = items.taskTime
		cell.taskTitle.text           = items.taskTitle
		cell.taskTime.isHidden        = !items.alarmImage
		cell.alarmImageView.isHidden  = !items.alarmImage
		cell.repeatImageView.isHidden = !items.repeatImage
		if items.repeatImage == false {
		cell.taskDate.text            = items.taskDate
		}else{
		cell.taskDate.text            = "every \(Int(items.timeInterval!)!/60) min"
		}
		visualViewCell(items: items, button: button, timeLabelDate: timeLabelDate, cell: cell)
		return cell
	}
	
	//визуальное отоброжение ячеек в зависимости от статуса задачи
	private func visualViewCell(items: Tasks, button: UIButton, timeLabelDate: Date?, cell: CustomCell) {
		if items.check == false { // если таск не отмечен как выполненный
			button.backgroundColor = MainVC.shared.view.backgroundColor
			button.setImage(nil, for: .normal)
			if timeLabelDate == nil { // если у него нет даты и выремени выполнения, то есть нил.
				painting(cell: cell, color: .black, colorTwo: .black)
				strikethroughStyle(cell: cell)
			}else{ // если дата и время просрочены красим в красный
				if timeLabelDate! < Date() {
					painting(cell: cell, color: .red, colorTwo: .red)
					strikethroughStyle(cell: cell)
				}else{ // если не просрочены делаем стандартными
					painting(cell: cell, color: UIColor(white: 0.5, alpha: 1), colorTwo: .black)
					strikethroughStyle(cell: cell)
				}
				sendReminderNotification("Напоминание \(items.taskTime!)", items.taskTitle, items.timeLabelDate!, items.repeatImage, items.timeInterval)
			}
		}else{ // если ставим отметку выполненного таск: красим в серый зачеркиваем и удаляем пуш
			button.setImage(UIImage.init(systemName: "checkmark"), for: .normal)
			button.backgroundColor         = .white
			button.tintColor               = .lightGray
			painting(cell: cell, color: .lightGray, colorTwo: .lightGray)
			cell.taskTitle.attributedText  = NSAttributedString(string: "\(cell.taskTitle.text!)", attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
			UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["id_\(items.taskTitle)"])
		}
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
		self.tableView.reloadData()
	}
	
	
	//MARK: - Notification
	func notification(){
		NotificationCenter.default.addObserver(self, selector: #selector(tableViewReloadData), name: Notification.Name("TableViewReloadData"), object: .none)
	}
	@objc func tableViewReloadData(notification: NSNotification){
		CoreDataMethods.shared.fetchRequest()
		self.tableView.reloadData()
	}
}
