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
		
		
		//MARK: - SWITCH
		var typeTask: String { items.type }
		var check: Bool { items.check }
		var isOverdue: Bool { items.taskDateDate ?? Date.now < Date.now }
		let strikethrough = NSAttributedString(string: "\(cell.taskTitle.text!)", attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
		let notStrikethrough = NSAttributedString(string: "\(cell.taskTitle.text!)", attributes: [NSAttributedString.Key.strikethroughStyle: nil ?? ""])
		
		
		switch typeTask {
		case "justType":
			switch check {
			case true:
				checkLight()
				painting(cell: cell, color: .lightGray, colorTwo: .lightGray)
				cell.taskTitle.attributedText = strikethrough
				cell.taskDate.text = ""
			case false:
				button.setImage(nil, for: .normal)
				button.backgroundColor = .backgroundColor
				painting(cell: cell, color: UIColor(white: 0.5, alpha: 1), colorTwo: .black)
				cell.taskTitle.attributedText = notStrikethrough
				cell.taskDate.text = ""

			}
			
		case "singleAlertType":
			cell.taskDate.text = items.taskDate
			switch check {
			case true:
				checkLight()
				painting(cell: cell, color: .lightGray, colorTwo: .lightGray)
				cell.taskTitle.attributedText = strikethrough
				LocalNotification.shared.deleteLocalNotification(items.taskTitle)
			case false:
				switch isOverdue { //просрочено ли?
				case true:
					button.backgroundColor = .backgroundColor
					button.setImage(nil, for: .normal)
					painting(cell: cell, color: .red, colorTwo: .red)
					cell.taskTitle.attributedText = notStrikethrough
				case false:
					standart()
				}
				LocalNotification.shared.sendReminderNotification("reminder \(items.taskTime!)", items.taskTitle, items.taskDateDate!)
			}
			
		case "timeRepeatType":
			guard let taskDateInt = Int(items.timeInterval!) else { return }
			cell.taskDate.text = "every \(taskDateInt/60) min"
			switch check {
			case true:
				button.setImage(UIImage.init(systemName: "checkmark"), for: .normal)
				button.backgroundColor = .white
				button.tintColor = .lightGray
				painting(cell: cell, color: .lightGray, colorTwo: .lightGray)
				cell.taskTitle.attributedText = strikethrough
				LocalNotification.shared.deleteLocalNotification(items.taskTitle)
			case false:
				standart()
				LocalNotification.shared.sendRepeatNotification("repeat \(cell.taskDate.text!)", items.taskTitle, items.timeInterval)
			}
			
		case "dayRepeatType":
			cell.taskDate.text = "every day"
			switch check {
			case true:
				button.setImage(UIImage.init(systemName: "checkmark"), for: .normal)
				button.backgroundColor = .white
				button.tintColor = .lightGray
				painting(cell: cell, color: .lightGray, colorTwo: .lightGray)
				cell.taskTitle.attributedText = strikethrough
				LocalNotification.shared.deleteLocalNotification(items.taskTitle)
			case false:
//				switch isOverdue { //просрочено ли?
//				case true:
//					button.backgroundColor = .backgroundColor
//					button.setImage(nil, for: .normal)
//					painting(cell: cell, color: .red, colorTwo: .red)
//					cell.taskTitle.attributedText = notStrikethrough
//				case false:
					standart()
//}
			}
			
		case "weekRepeatType":
			cell.taskDate.text = "every week"
			switch check {
			case true:
				button.setImage(UIImage.init(systemName: "checkmark"), for: .normal)
				button.backgroundColor = .white
				button.tintColor = .lightGray
				painting(cell: cell, color: .lightGray, colorTwo: .lightGray)
				cell.taskTitle.attributedText = strikethrough
				LocalNotification.shared.deleteLocalNotification(items.taskTitle)
			case false:
//				switch isOverdue { //просрочено ли?
//				case true:
//					button.backgroundColor = .backgroundColor
//					button.setImage(nil, for: .normal)
//					painting(cell: cell, color: .red, colorTwo: .red)
//					cell.taskTitle.attributedText = notStrikethrough
//				case false:
					standart()
//}
			}
		case "monthRepeatType":
			cell.taskDate.text = "every month"
			switch check {
			case true:
				button.setImage(UIImage.init(systemName: "checkmark"), for: .normal)
				button.backgroundColor = .white
				button.tintColor = .lightGray
				painting(cell: cell, color: .lightGray, colorTwo: .lightGray)
				cell.taskTitle.attributedText = strikethrough
				LocalNotification.shared.deleteLocalNotification(items.taskTitle)
			case false:
//				switch isOverdue { //просрочено ли?
//				case true:
//					button.backgroundColor = .backgroundColor
//					button.setImage(nil, for: .normal)
//					painting(cell: cell, color: .red, colorTwo: .red)
//					cell.taskTitle.attributedText = notStrikethrough
//				case false:
					standart()
//}
			}
		default:
			print("default visual")
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
			cell.taskTitle.attributedText = notStrikethrough
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
