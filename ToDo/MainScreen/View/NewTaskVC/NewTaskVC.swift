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
	let zaplatka          = UILabel()
	let textField         = UITextField()
	let dataPicker        = UIDatePicker()
	let setTimePicker     = UIDatePicker()
  let setWeekDay        = UIPickerView()
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
	var monthLabel        = ""
	var dayOfMonthLabel   = ""
	var weekDays          = ""
	var segmentedItems    = ["day", "week", "month", "set time"]
	let weekDaysArray     = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
	var repeatTime        = String?(nil)
	var repeatIntTime = Int()
	
	
	//MARK: - viewDidAppear
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.textField.becomeFirstResponder()
	}
	
	
	//MARK: - viewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		pickerSetup()
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
		setWeekDaySetup()
		zaplatkaSetup()
		tapObserves()
	}
	
	
	//MARK: - Setup
	//textFieldSetup
	func textFieldSetup() {
		self.textField.delegate           = self
		self.textField.layer.cornerRadius = 5
		self.textField.placeholder        = " craete new task"
		self.textField.borderStyle        = UITextField.BorderStyle.none
		self.textField.backgroundColor    = UIColor(named: "WhiteBlack")
		self.textField.addTarget(self, action: #selector(textFieldDidChande), for: .editingChanged)
	}
	
	@objc func textFieldDidChande() {
		switchAlert.isEnabled = true
		if textField.text == ""{
			allEnabled()
		}
	}
	
	
	func infoLabelSetup() {
		infoLabel.numberOfLines = 2
		infoLabel.textAlignment = .center
		infoLabel.text = "Just write you note"
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
	
	func setWeekDaySetup() {
		self.setWeekDay.isHidden   = true
		self.setWeekDay.dataSource = self
		self.setWeekDay.delegate   = self
	}
	
	@objc func setTimePicker(paramDataPicker: UIDatePicker) {
		let timeFromDP = paramDataPicker.date
		let timeHourFormatter = DateFormatter()
		let timeMinFormatter = DateFormatter()
		timeHourFormatter.dateFormat = "H"
		timeMinFormatter.dateFormat = "m"
		timeHRepeatLabel = timeHourFormatter.string(from: timeFromDP)
		timeMRepeatLabel = timeMinFormatter.string(from: timeFromDP)
		
		
		
		repeatIntTime = ((Int(timeHRepeatLabel) ?? 0)*3600) + ((Int(timeMRepeatLabel) ?? 0)*60)
		
		
		
		
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
			
			dateFormatter(dateFromDP: paramDataPicker)
			
			if switchAlertRepeat.isOn == true {
				infoLabel.text = "repeat every \(weekDays) at \(timelabel)"
				if repeatSegmented.selectedSegmentIndex == 2 {
					infoLabel.text = "repeat every month on the\n \(dayOfMonthLabel)th at \(timelabel)"
				} else if repeatSegmented.selectedSegmentIndex == 0 {
					infoLabel.text = "repeat every day at \(timelabel)"
				}
			} else {
				infoLabel.text = "the reminder will be set for\n \(monthLabel) \(timelabel)"
			}
		}
	}
	
	func dateFormatter(dateFromDP: UIDatePicker) {
		let dateFromDP                = dateFromDP.date
		let timeFormatter             = DateFormatter()
		let dateFormatter             = DateFormatter()
		let dateFormatterMonth        = DateFormatter()
		let dayOfMonth                = DateFormatter()
		timeFormatter.dateFormat      = "HH:mm"
		dateFormatter.dateFormat      = "dd.MM"
		dateFormatterMonth.dateFormat = "EEEE, MMM d"
		dayOfMonth.dateFormat         = "d"
		timelabel                     = timeFormatter.string(from: dateFromDP)
		dateLabel                     = dateFormatter.string(from: dateFromDP)
		monthLabel                    = dateFormatterMonth.string(from: dateFromDP)
		dayOfMonthLabel               = dayOfMonth.string(from: dateFromDP)
		dateLabelDate                 = dateFromDP
	}
		
	func alertLabelSetup() {
		alertLabel.image              = UIImage(systemName: "alarm")
		alertLabel.tintColor          = .gray
		alertLabel.contentMode        = .scaleAspectFit
	}
	
	func repeatLabelSetup() {
		repeatLabel.image             = UIImage(systemName: "repeat")
		repeatLabel.tintColor         = .gray
		repeatLabel.contentMode       = .scaleAspectFit
	}
	
	func setupSegmented() {
		repeatSegmented               = UISegmentedControl(items: segmentedItems)
		repeatSegmented.isEnabled     = false
		repeatSegmented.addTarget(self, action: #selector(repeatSegmentedChange(paramRepeatSegmented:)), for: .valueChanged)
	}
	
	func switchAlertSetup(){
		switchAlert.isEnabled         = false
		switchAlert.isOn              = false
		switchAlert.addTarget(self, action: #selector(visibilityDataPickerAndSwitchAlertRepeat), for: .valueChanged)
	}
	
	func allEnabled() {
		switchAlert.isEnabled         = false
		switchAlertRepeat.isEnabled   = false
		repeatSegmented.isEnabled     = false
		dataPicker.isEnabled          = false
		switchAlert.isOn              = false
		switchAlertRepeat.isOn        = false
		setTimePicker.isHidden        = true
		repeatSegmented.selectedSegmentIndex = UISegmentedControl.noSegment
	}
	
	@objc func repeatSegmentedChange(paramRepeatSegmented: UISegmentedControl) {
		if paramRepeatSegmented.isEqual(self.repeatSegmented){
			let repeatFromSegmented = paramRepeatSegmented.selectedSegmentIndex
			
			if repeatFromSegmented == 0 {
				self.dataPicker.isEnabled   = true
				self.dataPicker.isHidden    = false
				self.setTimePicker.isHidden = true
				self.setWeekDay.isHidden    = true
				self.zaplatka.isHidden      = false
				self.repeatTime             = "3600"
				infoLabel.text              = "repeat every day at \(timelabel)"
			} else if
				repeatFromSegmented == 1 {
				self.view.endEditing(true)
				self.dataPicker.isEnabled   = true
				self.dataPicker.isHidden    = false
				self.setTimePicker.isHidden = true
				self.setWeekDay.isHidden    = false
				self.zaplatka.isHidden      = false
				//self.repeatTime             = "86400"
				infoLabel.text              = "repeat every \(weekDays) at \(timelabel)"
			} else if
				repeatFromSegmented == 2 {
				self.zaplatka.isHidden = true
				self.dataPicker.isEnabled   = true
				self.dataPicker.isHidden    = false
				self.setTimePicker.isHidden = true
				self.setWeekDay.isHidden    = true
				//self.repeatTime             = "604800"
				infoLabel.text              = "repeat every month on the\n \(dayOfMonthLabel)th at \(timelabel)"
			} else if
				repeatFromSegmented == 3 {
				self.view.endEditing(true)
				self.zaplatka.isHidden = true
				self.dataPicker.isEnabled   = false
				self.dataPicker.isHidden    = true
				self.setTimePicker.isHidden = false
				self.setWeekDay.isHidden    = true
				infoLabel.text              = "set the repeat time"
//				self.repeatTime = String(repeatIntTime)
			}
		}
	}
	
	@objc func visibilityDataPickerAndSwitchAlertRepeat() {
		if switchAlert.isOn == true {
			self.zaplatka.isHidden = true
			self.dataPicker.isEnabled            = true
			self.dataPicker.isHidden             = false
			self.switchAlertRepeat.isEnabled     = true
			self.infoLabel.text                  = "Set the date and time of the reminder"
		} else{
			self.zaplatka.isHidden = true
			self.dataPicker.isEnabled            = false
			self.dataPicker.isHidden             = false
			self.dataPicker.minimumDate          = Date()
			self.switchAlertRepeat.isEnabled     = false
			self.switchAlertRepeat.isOn          = false
			self.repeatSegmented.isEnabled       = false
			self.setTimePicker.isHidden          = true
			self.setWeekDay.isHidden             = true
			self.infoLabel.text                  = "Create your note"
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
			self.zaplatka.isHidden = true
			self.repeatSegmented.isEnabled = false
			self.repeatSegmented.selectedSegmentIndex = UISegmentedControl.noSegment
			self.dataPicker.minimumDate    = Date()
			self.dataPicker.isEnabled      = true
			self.dataPicker.isHidden       = false
			self.setTimePicker.isHidden    = true
			self.setWeekDay.isHidden       = true
			self.infoLabel.text            = "Set the date and time of the reminder"
		}else{
			self.zaplatka.isHidden = true
			self.repeatSegmented.isEnabled = true
			self.dataPicker.isHidden       = false
			self.dataPicker.minimumDate    = nil
			self.infoLabel.text            = "Choose a repeat rate"
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
		if switchAlert == true, switchRepeat == false {
//			guard switchRepeat == false else { return }
			guard timelabel != "" else { return }
			guard dateLabel != "" else { return }
		coreData.saveTask(withTitle:           text,
											withTimeLabel:       timelabel,
											withDateLabel:       dateLabel,
											withDate:            dateLabelDate,
											withCheck:           false,
											withAlarmLabelBuul:  switchAlert,
											withRepeatLabelBool: switchRepeat,
		                  withTimeInterval:    repeatTime)
		cancelFunc()
			NotificationCenter.default.post(name: Notification.Name("Reload"), object: .none)
		} else {
			
			
			
			self.repeatTime = String(repeatIntTime)
			
			
			
			coreData.saveTask(withTitle:           text,
												withTimeLabel:       "",
												withDateLabel:       "",
												withDate:            nil,
												withCheck:           false,
												withAlarmLabelBuul:  switchAlert,
												withRepeatLabelBool: switchRepeat,
												withTimeInterval:    repeatTime)
			print(repeatTime)
			cancelFunc()
				NotificationCenter.default.post(name: Notification.Name("Reload"), object: .none)
		}
	}
	
	@objc func cancelFunc(){
		zaplatka.isHidden           = true
		textField.text              = nil
		dataPicker.isEnabled        = false
		switchAlert.isOn            = false
		switchAlertRepeat.isOn      = false
		setTimePicker.isHidden      = true
		repeatSegmented.isEnabled   = false
		switchAlertRepeat.isEnabled = false
		switchAlert.isEnabled       = false
		setWeekDay.isHidden         = true
		infoLabel.text              = "Just write you note"
		timelabel                   = ""
		dateLabel                   = ""
		repeatSegmented.selectedSegmentIndex = UISegmentedControl.noSegment
		dismiss(animated: true, completion: nil)
	}
}
