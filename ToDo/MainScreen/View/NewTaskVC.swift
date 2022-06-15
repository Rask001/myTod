//
//  NewTaskVC.swift
//  ToDo
//
//  Created by Антон on 08.05.2022.
//

import Foundation
import UIKit
import CoreData

class NewTaskVC: UIViewController {
	
	//MARK: - Properties
	let textField         = UITextField()
	let dataPicker        = UIDatePicker()
	let repeatPicker      = UIPickerView()
	let switchAlert       = UISwitch()
	let switchAlertRepeat = UISwitch()
	let navigationBar     = UINavigationBar()
	
	var coreData  = CoreDataMethods()
	//var date      = Date()
	var dateLabelDate = Date()
	var timelabel = ""
	var dateLabel = ""

	
	//MARK: - viewDidAppear
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.textField.becomeFirstResponder()
	}
	
	
	//MARK: - viewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		textFieldSetup()
		pickerSetup()
		addSubviewAndConfigure()
		navigationBarSetup()
		pickerRepeatSetup()
		setConstraits()
		switchAlertSetup()
		switchAlertRepeatSetup()
	}
	
	
	//MARK: - Setup
	//textFieldSetup
	func textFieldSetup() {
		self.textField.delegate           = self
		self.textField.layer.cornerRadius = 5
		self.textField.placeholder        = " craete new task"
		self.textField.borderStyle        = UITextField.BorderStyle.none
		self.textField.backgroundColor    = UIColor(named: "WhiteBlack")
	}
	
	
	func pickerSetup() {
		let dateNow = Date()
	  self.dataPicker.isEnabled    = false
		self.dataPicker.minimumDate  = dateNow
		self.dataPicker.timeZone     = .autoupdatingCurrent
		self.dataPicker.addTarget(self, action: #selector(dataPickerChange(paramDataPicker:)), for: .valueChanged)
	}
	
	@objc func dataPickerChange(paramDataPicker:UIDatePicker) {
		if paramDataPicker.isEqual(self.dataPicker) {
			let dateFromDP = paramDataPicker.date
//			let dateComponentsChange = dataPicker.calendar.dateComponents([.month, .day, .hour, .minute], from: dateFromDP)
			let timeFormatter = DateFormatter()
			let dateFormatter = DateFormatter()
			//dateFormatter.locale = Locale(identifier: "ru_RU")
			timeFormatter.dateFormat = "HH:mm"
			dateFormatter.dateFormat = "dd.MM"
			timelabel = timeFormatter.string(from: dateFromDP)
			dateLabel = dateFormatter.string(from: dateFromDP)
			dateLabelDate = dateFromDP
//			newDate = dateFromDP
		}
	}
		
	
	func pickerRepeatSetup() {
	}
	
	func switchAlertSetup(){
		switchAlert.isOn = false
		switchAlert.addTarget(self, action: #selector(visibility), for: .valueChanged)
	}
	@objc func visibility() {
		switchAlert.isOn == false ? (self.dataPicker.isEnabled = false) : (self.dataPicker.isEnabled = true)
	}
	
	func switchAlertRepeatSetup(){
		switchAlertRepeat.isOn = false
		//switchAlertRepeat.addTarget(self, action: #selector(repeatReminder), for: .valueChanged)
	}
	
	func navigationBarSetup() {
		let leftButton  = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(cancelFunc))
		let rightButton = UIBarButtonItem(title: "continue", style: .plain, target: self, action: #selector(continueFunc))
		self.navigationBar.frame              = CGRect(x: 0, y: 0, width: Int(self.view.bounds.size.width), height: 44)
		self.navigationBar.barTintColor       = .secondarySystemBackground
		self.navigationBar.prefersLargeTitles = true
		self.navigationBar.shadowImage        = .none
		let navigationItem                    = UINavigationItem(title: "Create task")
		navigationItem.leftBarButtonItem      = leftButton
		navigationItem.rightBarButtonItem     = rightButton
		self.navigationBar.items              = [navigationItem]
		self.view.addSubview(navigationBar)
	}
	
	@objc func continueFunc(){
		guard let text   = textField.text, !text.isEmpty else { return }
		let switchAlert  = switchAlert.isOn
		let switchRepeat = switchAlertRepeat.isOn
		if switchAlert == true {
			guard timelabel != "" else { return }
			guard dateLabel != "" else { return }
		coreData.saveTask(withTitle:           text,
											withTimeLabel:       timelabel,
											withDateLabel:       dateLabel,
											withDate:            dateLabelDate,
											withCheck:           false,
											withAlarmLabelBuul:  switchAlert,
											withRepeatLabelBool: switchRepeat)
		cancelFunc()
			NotificationCenter.default.post(name: Notification.Name("Reload"), object: .none)
		} else {
			coreData.saveTask(withTitle:           text,
												withTimeLabel:       "",
												withDateLabel:       "",
												withDate:            nil,
												withCheck:           false,
												withAlarmLabelBuul:  switchAlert,
												withRepeatLabelBool: switchRepeat)
			cancelFunc()
				NotificationCenter.default.post(name: Notification.Name("Reload"), object: .none)
		}
	}
	
	
	@objc func cancelFunc(){
		self.textField.text       = nil
		self.dataPicker.isEnabled = false
		switchAlert.isOn          = false
		switchAlertRepeat.isOn    = false
		timelabel                 = ""
		dateLabel                 = ""
		dismiss(animated: true, completion: nil)
	}
}


//MARK: - Extension

extension NewTaskVC: UITextFieldDelegate {
	
	func addSubviewAndConfigure(){
		self.view.backgroundColor = .secondarySystemBackground
		self.view.addSubview(self.textField)
		self.view.addSubview(self.dataPicker)
		self.view.addSubview(self.switchAlert)
		self.view.addSubview(self.switchAlertRepeat)
		//self.view.addSubview(self.repeatPicker)
	}
	
	func setConstraits() {
		self.textField.translatesAutoresizingMaskIntoConstraints                                                   = false
		self.textField.widthAnchor.constraint(equalToConstant: 300).isActive                                       = true
		self.textField.heightAnchor.constraint(equalToConstant: 31).isActive                                       = true
		self.textField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80 ).isActive                  = true
		self.textField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive                         = true

		self.dataPicker.translatesAutoresizingMaskIntoConstraints                                                  = false
		self.dataPicker.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 60).isActive          = true
		self.dataPicker.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive       = true
		self.dataPicker.topAnchor.constraint(equalTo: self.textField.bottomAnchor, constant: 130).isActive         = true
		
		self.switchAlert.translatesAutoresizingMaskIntoConstraints                                                 = false
		self.switchAlert.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30).isActive         = true
		self.switchAlert.centerYAnchor.constraint(equalTo: self.dataPicker.centerYAnchor).isActive                 = true
		
		self.switchAlertRepeat.translatesAutoresizingMaskIntoConstraints                                           = false
		self.switchAlertRepeat.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30).isActive   = true
		self.switchAlertRepeat.topAnchor.constraint(equalTo: self.switchAlert.bottomAnchor, constant: 30).isActive = true
		
//		self.repeatPicker.translatesAutoresizingMaskIntoConstraints                                                = false
//		self.repeatPicker.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 60).isActive        = true
//		self.repeatPicker.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive     = true
//		self.repeatPicker.topAnchor.constraint(equalTo: self.switchAlertRepeat.topAnchor).isActive                 = true
		
	}

}


extension NewTaskVC: UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		10
	}
}
