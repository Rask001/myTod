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
	let infoLabel         = UILabel()
	let textField         = UITextField()
	let dataPicker        = UIDatePicker()
	let setTimePicker     = UIDatePicker()
	let switchAlert       = UISwitch()
	let switchAlertRepeat = UISwitch()
	let navigationBar     = UINavigationBar()
	let alertLabel        = UIImageView()
	let repeatLabel       = UIImageView()
	var repeatSegmented   = UISegmentedControl()
	var coreData          = CoreDataMethods()
	var dateLabelDate     = Date()
	var timeHRepeatLabel  = ""
	var timeMRepeatLabel  = ""
	var timelabel         = ""
	var dateLabel         = ""
	var segmentedItems    = ["day", "week", "month", "set time"]
	var repeatTime        = String?(nil)
	
	
	//MARK: - viewDidAppear
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.textField.becomeFirstResponder()
		pickerSetup()
	}
	
	
	//MARK: - viewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		setupSegmented()
		textFieldSetup()
		addSubviewAndConfigure()
		navigationBarSetup()
		switchAlertSetup()
		switchAlertRepeatSetup()
		alertLabelSetup()
		repeatLabelSetup()
		setConstraits()
		setTimePickerSetup()
		infoLabelSetup()
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
	
	func infoLabelSetup() {
		infoLabel.textAlignment = .center
		infoLabel.text = ""
	}
	
	
	func pickerSetup() {
		let dateNow = Date()
		self.dataPicker.isEnabled    = false
		self.dataPicker.date         = dateNow
		self.dataPicker.minimumDate  = dateNow
		self.dataPicker.timeZone     = .autoupdatingCurrent
		self.dataPicker.addTarget(self, action: #selector(dataPickerChange(paramDataPicker:)), for: .valueChanged)
	}
	
	func setTimePickerSetup() {
		self.setTimePicker.isHidden = true
		self.setTimePicker.datePickerMode = .time
		self.setTimePicker.preferredDatePickerStyle = .wheels
		self.setTimePicker.addTarget(self, action: #selector(setTimePicker(paramDataPicker:)), for: .valueChanged)
	}
	
	@objc func setTimePicker(paramDataPicker: UIDatePicker) {
		let timeFromDP = paramDataPicker.date
		let timeHourFormatter = DateFormatter()
		let timeMinFormatter = DateFormatter()
		timeHourFormatter.dateFormat = "H"
		timeMinFormatter.dateFormat = "m"
		timeHRepeatLabel = timeHourFormatter.string(from: timeFromDP)
		timeMRepeatLabel = timeMinFormatter.string(from: timeFromDP)
		var hour = ""
		var min = ""
		timeHRepeatLabel != "1" ? (hour = "hours") : (hour = "hour")
		timeMRepeatLabel != "1" ? (min = "minutes") : (min = "minute")
		if timeHRepeatLabel == "0", timeMRepeatLabel == "0"  {
			infoLabel.text = "no repeat"
		} else if
			timeMRepeatLabel == "0" {
			infoLabel.text = "repeat every \(timeHRepeatLabel) \(hour)"
		} else if
			timeHRepeatLabel == "0" {
			infoLabel.text = "repeat every \(timeMRepeatLabel) \(min)"
		} else {
			infoLabel.text = "repeat every \(timeHRepeatLabel) \(hour) \(timeMRepeatLabel) \(min)"
		}
	}
	
	@objc func dataPickerChange(paramDataPicker: UIDatePicker) {
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
		
	func alertLabelSetup() {
		alertLabel.image         = UIImage(systemName: "alarm")
		alertLabel.tintColor     = .gray
		alertLabel.contentMode   = .scaleAspectFit
	}
	
	func repeatLabelSetup() {
		repeatLabel.image        = UIImage(systemName: "repeat")
		repeatLabel.tintColor    = .gray
		repeatLabel.contentMode  = .scaleAspectFit
	}
	
	
	func setupSegmented() {
		repeatSegmented = UISegmentedControl(items: segmentedItems)
		repeatSegmented.isEnabled = false
		repeatSegmented.addTarget(self, action: #selector(repeatSegmentedChange(paramRepeatSegmented:)), for: .valueChanged)
	}
	
	
	func switchAlertSetup(){
		switchAlert.isOn = false
		switchAlert.addTarget(self, action: #selector(visibilityDataPickerAndSwitchAlertRepeat), for: .valueChanged)
	}
	
	@objc func repeatSegmentedChange(paramRepeatSegmented: UISegmentedControl) {
		if paramRepeatSegmented.isEqual(self.repeatSegmented){
			let repeatFromSegmented = paramRepeatSegmented.selectedSegmentIndex
			
			if repeatFromSegmented == 0 {
				self.setTimePicker.isHidden = true
				self.repeatTime = "3600"
				infoLabel.text = "repeat every day at \(timelabel)"
			} else if
				repeatFromSegmented == 1 {
				self.setTimePicker.isHidden = true
				self.repeatTime = "86400"
				infoLabel.text = "repeat every weak at \(timelabel)"
			} else if
				repeatFromSegmented == 2 {
				self.setTimePicker.isHidden = true
				self.repeatTime = "604800"
				infoLabel.text = "repeat every month at \(timelabel)"
			} else if
				repeatFromSegmented == 3 {
				self.view.endEditing(true)
				self.setTimePicker.isHidden = false
				//self.repeatTime = "62"
			}
		}
	}
	
	@objc func visibilityDataPickerAndSwitchAlertRepeat() {
		if switchAlert.isOn == true {
			self.dataPicker.isEnabled            = true
			self.switchAlertRepeat.isEnabled     = true
		} else{
			self.dataPicker.isEnabled            = false
			self.switchAlertRepeat.isEnabled     = false
			self.switchAlertRepeat.isOn          = false
			self.repeatSegmented.isEnabled       = false
			self.repeatSegmented.selectedSegmentIndex = UISegmentedControl.noSegment
		}
	}
	
	func switchAlertRepeatSetup(){
		switchAlertRepeat.isOn      = false
		switchAlertRepeat.isEnabled = false
		switchAlertRepeat.addTarget(self, action: #selector(visibilityRepeatSegmented), for: .valueChanged)
	}
	
	@objc func visibilityRepeatSegmented() {
		if switchAlertRepeat.isOn == false {
			self.repeatSegmented.isEnabled = false
			self.repeatSegmented.selectedSegmentIndex = UISegmentedControl.noSegment
			self.dataPicker.minimumDate  = Date()
		}else{
			self.repeatSegmented.isEnabled = true
			self.dataPicker.minimumDate  = nil
		}
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
											withRepeatLabelBool: switchRepeat,
		                  withTimeInterval: repeatTime)
		cancelFunc()
			NotificationCenter.default.post(name: Notification.Name("Reload"), object: .none)
		} else {
			coreData.saveTask(withTitle:           text,
												withTimeLabel:       "",
												withDateLabel:       "",
												withDate:            nil,
												withCheck:           false,
												withAlarmLabelBuul:  switchAlert,
												withRepeatLabelBool: switchRepeat,
												withTimeInterval: repeatTime)
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
		self.view.addSubview(self.alertLabel)
		self.view.addSubview(self.repeatLabel)
		self.view.addSubview(self.repeatSegmented)
		self.view.addSubview(self.setTimePicker)
		self.view.addSubview(self.infoLabel)
	}
	
	func setConstraits() {
		self.textField.translatesAutoresizingMaskIntoConstraints                                                   = false
		self.textField.widthAnchor.constraint(equalToConstant: 300).isActive                                       = true
		self.textField.heightAnchor.constraint(equalToConstant: 31).isActive                                       = true
		self.textField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80 ).isActive                  = true
		self.textField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive                         = true

		self.dataPicker.translatesAutoresizingMaskIntoConstraints                                                  = false
		self.dataPicker.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive       = true
		self.dataPicker.topAnchor.constraint(equalTo: self.textField.bottomAnchor, constant: 100).isActive         = true
		
		self.switchAlert.translatesAutoresizingMaskIntoConstraints                                                 = false
		self.switchAlert.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 60).isActive         = true
		self.switchAlert.centerYAnchor.constraint(equalTo: self.dataPicker.centerYAnchor).isActive                 = true
		
		self.switchAlertRepeat.translatesAutoresizingMaskIntoConstraints                                           = false
		self.switchAlertRepeat.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 60).isActive   = true
		self.switchAlertRepeat.topAnchor.constraint(equalTo: self.switchAlert.bottomAnchor, constant: 30).isActive = true
		
		self.alertLabel.translatesAutoresizingMaskIntoConstraints                                                  = false
		self.alertLabel.heightAnchor.constraint(equalToConstant: 30).isActive                                      = true
		self.alertLabel.widthAnchor.constraint(equalToConstant: 30).isActive                                       = true
		self.alertLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15).isActive          = true
		self.alertLabel.centerYAnchor.constraint(equalTo: self.switchAlert.centerYAnchor).isActive                 = true
		
		self.repeatLabel.translatesAutoresizingMaskIntoConstraints                                                 = false
		self.repeatLabel.heightAnchor.constraint(equalToConstant: 30).isActive                                     = true
		self.repeatLabel.widthAnchor.constraint(equalToConstant: 30).isActive                                      = true
		self.repeatLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15).isActive         = true
		self.repeatLabel.centerYAnchor.constraint(equalTo: self.switchAlertRepeat.centerYAnchor).isActive          = true
		
		self.repeatSegmented.translatesAutoresizingMaskIntoConstraints                                             = false
		self.repeatSegmented.widthAnchor.constraint(equalToConstant: 230).isActive                                 = true
		self.repeatSegmented.heightAnchor.constraint(equalToConstant: 30).isActive                                 = true
		self.repeatSegmented.centerYAnchor.constraint(equalTo: self.repeatLabel.centerYAnchor).isActive            = true
		self.repeatSegmented.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive  = true
		
		self.setTimePicker.translatesAutoresizingMaskIntoConstraints                                               = false
		self.setTimePicker.widthAnchor.constraint(equalToConstant: 250).isActive                                   = true
		self.setTimePicker.heightAnchor.constraint(equalToConstant: 120).isActive                                  = true
		self.setTimePicker.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive                     = true
		self.setTimePicker.topAnchor.constraint(equalTo: self.repeatSegmented.bottomAnchor, constant: 60).isActive = true
		
		self.infoLabel.translatesAutoresizingMaskIntoConstraints                                                   = false
		self.infoLabel.widthAnchor.constraint(equalToConstant: 300).isActive                                       = true
		self.infoLabel.heightAnchor.constraint(equalToConstant: 30).isActive                                       = true
		self.infoLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive                         = true
		self.infoLabel.topAnchor.constraint(equalTo: self.repeatSegmented.bottomAnchor, constant: 25).isActive     = true
	}
}
