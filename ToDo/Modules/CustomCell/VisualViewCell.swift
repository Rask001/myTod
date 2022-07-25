//
//  VisualViewCell.swift
//  ToDo
//
//  Created by Антон on 22.07.2022.
//
import UIKit
import Foundation

class VisualViewCell {
	var coreData = CoreDataMethods.shared.coreDataModel
	let tappedFeedBack = TappedFeedBack()
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
	
		var typeTask: String { items.type }
		var check: Bool { items.check }
		var isOverdue: Bool { items.taskDateDate! < Date.now }
		
		switch typeTask {
			
		case "justType":
			switch check {
			case true:
				checkLight()
				painting(cell: cell, color: .lightGray, colorTwo: .lightGray)
				cell.taskTitle.attributedText = NSAttributedString(string: "\(cell.taskTitle.text!)", attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
			case false:
				button.setImage(nil, for: .normal)
				button.backgroundColor = .backgroundColor
				painting(cell: cell, color: UIColor(white: 0.5, alpha: 1), colorTwo: .black)
				strikethroughStyle(cell: cell)
			}
			
		case "singleAlertType":
			switch check {
			case true:
				checkLight()
				painting(cell: cell, color: .lightGray, colorTwo: .lightGray)
				cell.taskTitle.attributedText = NSAttributedString(string: "\(cell.taskTitle.text!)", attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
				UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["id_\(items.taskTitle)"])
				if items.repeatImage == true {
					items.repeatImage = false
					items.alarmImage = false
				}
			case false:
				switch isOverdue { //просрочено ли?
				case true:
					button.backgroundColor = .backgroundColor
					button.setImage(nil, for: .normal)
					painting(cell: cell, color: .red, colorTwo: .red)
					strikethroughStyle(cell: cell)
				case false:
					standart()
				}
				LocalNotification.shared.sendReminderNotification("reminder \(items.taskTime!)", items.taskTitle, items.taskDateDate!)
			}
			
		case "timeRepeatType":
			switch check {
			case true:
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
			case false:
				standart()
			}
			
		case "dayRepeatType":
			switch check {
			case true:
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
			case false:
				switch isOverdue { //просрочено ли?
				case true:
					button.backgroundColor = .backgroundColor
					button.setImage(nil, for: .normal)
					painting(cell: cell, color: .red, colorTwo: .red)
					strikethroughStyle(cell: cell)
				case false:
					standart()
				}
			}
			
		case "weekRepeatType":
			print(#function)
		case "monthRepeatType":
			print(#function)
		default:
			print(#function)
		}
		
		func checkLight() {
			button.setImage(UIImage.init(systemName: "checkmark"), for: .normal)
			button.backgroundColor = .white
			button.tintColor = .lightGray
		}
		
		func standart() {
			button.backgroundColor = .backgroundColor
			button.setImage(nil, for: .normal)
			painting(cell: cell, color: UIColor(white: 0.5, alpha: 1), colorTwo: .black)
			strikethroughStyle(cell: cell)
		}
		
		func strikethroughStyle(cell: CustomCell) {
			cell.taskTitle.attributedText = NSAttributedString(string: "\(cell.taskTitle.text!)", attributes: [NSAttributedString.Key.strikethroughStyle: nil ?? ""])
		}
		
		func painting(cell: CustomCell, color: UIColor, colorTwo: UIColor) {
			cell.repeatImageView.tintColor  = color
			cell.alarmImageView.tintColor   = color
			cell.taskTime.textColor         = color
			cell.taskDate.textColor         = color
			cell.taskTitle.textColor        = colorTwo
		}
	}
}
