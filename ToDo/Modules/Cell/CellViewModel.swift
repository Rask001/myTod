////
////  CellViewModel.swift
////  ToDo
////
////  Created by Антон on 14.09.2022.
////
//
//import Foundation
//import UIKit
//
//fileprivate enum Constants {
//	static var cellFont: UIFont { UIFont(name: "Helvetica Neue", size: 20)!}
//	static var cellDistance: CGFloat { -3 }
//	static var textFiledFont: UIFont { UIFont(name: "Helvetica Neue", size: 20)!}
//}
//
////MARK: - TaskCellViewModel
//class TaskCellViewModel: TaskCellProtocol {
//
//
//
//	//weak var view: TaskCell?
//
//	var id: String = ""
//	var taskDateDate: Date = Date.now
//	var backgroundViewCell: UIView {
//		let view                            = UIView()
//		view.backgroundColor                = .cellColor
//		view.layer.cornerRadius             = 10
//		view.layer.shadowColor              = UIColor.black.cgColor
//		view.layer.shadowRadius             = 4
//		view.layer.shadowOpacity            = 0.2
//		view.layer.shadowOffset             = CGSize(width: 0, height: 3 )
//		return view
//	}
//
//	var textFieldLabel: UITextField {
//		let textField = UITextField()
//		textField.borderStyle               = UITextField.BorderStyle.none
//		textField.backgroundColor           = .cellColor
//		textField.font                      = Constants.textFiledFont
//		textField.textAlignment             = .left
//		textField.adjustsFontSizeToFitWidth = true
//		textField.clearButtonMode           = .never
//		textField.isHidden                  = true
//		return textField
//	}
//
//	var taskTitle: UILabel {
//		let taskTitle                       = UILabel(font: Constants.cellFont, textColor: .black)
//		taskTitle.textAlignment             = .left
//		taskTitle.adjustsFontSizeToFitWidth = true
//		taskTitle.isHidden = false
//		return taskTitle
//	}
//
//	var taskTime: UILabel {
//		let taskTime                        = UILabel(font: .avenirNext20()!, textColor: .black)
//		taskTime.textAlignment              = .center
//		taskTime.adjustsFontSizeToFitWidth  = true
//		return taskTime
//	}
//
//	var taskDate: UILabel {
//		let taskDate                        = UILabel(font: .avenirNext20()!, textColor: .black)
//		taskDate.textAlignment              = .center
//		taskDate.adjustsFontSizeToFitWidth  = true
//		return taskDate
//	}
//
//	var buttonCell: CustomButton {
//		let buttonCell                      = CustomButton(type: .custom)
//		buttonCell.layer.cornerRadius       = 17.5
//		buttonCell.backgroundColor          = UIColor.backgroundColor
//		return buttonCell
//	}
//
//	var buttonOk: CustomButton {
//		let buttonOk                      = CustomButton(type: .custom)
//		buttonOk.isHidden                 = true
//		buttonOk.setImage(UIImage.init(systemName: "checkmark"), for: .normal)
//		buttonOk.backgroundColor          = .cellColor
//		buttonOk.tintColor                = .backgroundColor
//		buttonOk.addTarget(self, action: #selector(completeEdit), for: .touchUpInside) //игнорировать предупреждение!
//		return buttonOk
//	}
//
//	var alarmImageView: UIImageView {
//		let alarmImageView                  = UIImageView()
//		alarmImageView.image                = UIImage(systemName: "alarm")
//		alarmImageView.tintColor            = .gray
//		alarmImageView.contentMode          = .scaleAspectFit
//		return alarmImageView
//	}
//
//	var repeatImageView: UIImageView {
//		let repeatImageView                 = UIImageView()
//		repeatImageView.image               = UIImage(systemName: "repeat")
//		repeatImageView.tintColor           = .gray
//		repeatImageView.contentMode         = .scaleAspectFit
//		return repeatImageView
//	}
//}
//
//
////MARK: - extension
//extension TaskCellViewModel: TaskCellActionProtocol {
//	@objc func completeEdit() {
//		self.buttonOk.isHidden = true
//		self.textFieldLabel.isHidden = true
//		self.buttonCell.isEnabled = true
//	}
//}
