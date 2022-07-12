//
//  CustomCellVM.swift
//  ToDo
//
//  Created by Антон on 07.07.2022.
//

import Foundation
import UIKit

class CustomCellVM {
	static let shared = CustomCellVM()
	//TODO: сделать cell.taskDate.text = "every \(items.timeInterval!) seconds" в норм формат. и вообще переделать реализацию
	//MARK: VisualViewCell
	func setupCustomCell(tableView: UITableView, indexPath: IndexPath) -> CustomCell {
		let cell   = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as! CustomCell
		let items  = CoreDataMethods.shared.coreDataModel[indexPath.row]
		let button = cell.buttonCell
		
		////		guard let tableViewCell = cell, let viewModel = viewModel else { return }
		////		let cellViewModel = viewModel?.cellViewModel(forIndexPath: indexPath)
		////		cell.viewModel = cellViewModel
		///
		cell.taskDateDate             = items.taskDateDate
		cell.taskTime.text            = items.taskTime
		cell.taskTitle.text           = items.taskTitle
		cell.taskTime.isHidden        = !items.alarmImage
		cell.alarmImageView.isHidden  = !items.alarmImage
		cell.repeatImageView.isHidden = !items.repeatImage
		if items.repeatImage == false {
		cell.taskDate.text            = items.taskDate
		} else {
			cell.taskDate.text            = "every \((Int(items.timeInterval!)!)/60) min" //починить, когда после установки репита начать ставить время будет не очень. нужно делать неактивным датапикер при 3ем сегменте
		}
		button.tag = indexPath.row
		button.addTarget(self, action: #selector(saveCheckmark(sender:)), for: .touchUpInside)
		visualViewCell(items: items, button: button, taskDateDate: cell.taskDateDate, cell: cell)
		return cell
	}
	
	//визуальное отоброжение ячеек в зависимости от статуса задачи
	private func visualViewCell(items: Tasks, button: UIButton, taskDateDate: Date?, cell: CustomCell) {
		
		if items.check == false { // если таск не отмечен как выполненный
			button.backgroundColor = MainVC.shared.view.backgroundColor
			button.setImage(nil, for: .normal)
			if taskDateDate == nil { // если у него нет даты и выремени выполнения, то есть нил.
				painting(cell: cell, color: UIColor(white: 0.5, alpha: 1), colorTwo: .black)
				strikethroughStyle(cell: cell)
				//LocalNotification.shared.sendRepeatNotification("repeat every \(Int(items.timeInterval!)!/60) min", items.taskTitle, items.timeInterval!)
			} else { // если есть время выполнения
				if taskDateDate! < Date() { // если дата и время просрочены красим в красный
					painting(cell: cell, color: .red, colorTwo: .red)
					strikethroughStyle(cell: cell)
				} else { // если не просрочены делаем стандартными
					painting(cell: cell, color: UIColor(white: 0.5, alpha: 1), colorTwo: .black)
					strikethroughStyle(cell: cell)
				}
				LocalNotification.shared.sendReminderNotification("reminder \(items.taskTime!)", items.taskTitle, taskDateDate!)
			}
	} else { // если ставим отметку выполненного таскa: красим в серый зачеркиваем и удаляем нотификейшен
			button.setImage(UIImage.init(systemName: "checkmark"), for: .normal)
			button.backgroundColor         = .white
			button.tintColor               = .lightGray
			painting(cell: cell, color: .lightGray, colorTwo: .lightGray)
			cell.taskTitle.attributedText  = NSAttributedString(string: "\(cell.taskTitle.text!)", attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
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
