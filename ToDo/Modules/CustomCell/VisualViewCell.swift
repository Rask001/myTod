//
//  VisualViewCell.swift
//  ToDo
//
//  Created by Антон on 22.07.2022.
//
import UIKit
import Foundation

class VisualViewCell {
	
	let tappedFeedBack = TappedFeedBack()
	let coreDataMethods = CoreDataMethods()
	//визуальное отоброжение ячеек в зависимости от статуса задачи
	func visualViewCell(items: Tasks, cell: CustomCell, indexPath: IndexPath) {
    	let button = cell.buttonCell
			cell.taskDateDate             = items.taskDateDate
			cell.taskTime.text            = items.taskTime
			cell.taskTitle.text           = items.taskTitle
			cell.taskTime.isHidden        = !items.alarmImage
			cell.alarmImageView.isHidden  = !items.alarmImage
			cell.repeatImageView.isHidden = !items.repeatImage
			if items.repeatImage == false {
				cell.taskDate.text            = items.taskDate
			} else if items.taskDateDate != nil, items.repeatImage == true {
				cell.taskDate.text            = "every day"
			} else {
		    cell.taskDate.text            = "every \((Int(items.timeInterval!)!)/60) min"
			}
		switch items.check {
		case false:
			nonCheck()
		case true:
			check()
		}
		
		func nonCheck() { // если таск не отмечен как выполненный
			button.backgroundColor = .backgroundColor
			button.setImage(nil, for: .normal)
			var isNil: Bool { items.taskDateDate == nil }
			switch isNil {
			case true: //если у таски нет времени
				painting(cell: cell, color: UIColor(white: 0.5, alpha: 1), colorTwo: .black)
				strikethroughStyle(cell: cell)
			case false: //если у таски есть время
				var isOverdue: Bool { items.taskDateDate! < Date.now }
				switch isOverdue { //просрочено ли?
				case true:
					painting(cell: cell, color: .red, colorTwo: .red)
					strikethroughStyle(cell: cell)
				case false:
					painting(cell: cell, color: UIColor(white: 0.5, alpha: 1), colorTwo: .black)
					strikethroughStyle(cell: cell)
				}
				LocalNotification.shared.sendReminderNotification("reminder \(items.taskTime!)", items.taskTitle, items.taskDateDate!)
			}
		}
		func check() { //если ставим отметку выполненного таскa: красим в серый зачеркиваем и удаляем нотификейшен
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
}

