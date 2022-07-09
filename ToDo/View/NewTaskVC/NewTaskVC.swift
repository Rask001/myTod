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
	var taskStruct = TaskStruct()
	
	//MARK: - Properties
	let infoLabel           = UILabel()
	let textField           = UITextField()
	let dataPicker          = UIDatePicker()
	let setTimePicker       = UIDatePicker()
  let setWeekDay          = UIPickerView()
	let switchAlert         = UISwitch()
	let switchAlertRepeat   = UISwitch()
	let navigationBar       = UINavigationBar()
  let alertLabel          = UIImageView()
	let repeatLabel         = UIImageView()
	var repeatSegmented     = UISegmentedControl()
	var coreData            = CoreDataMethods()
	var dayOfMonthLabel     = ""
	var weekDays            = ""
	var segmentedItems      = ["day", "week", "month", "set time"]
	let weekDaysArray       = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
	
	
	
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
	}
	
	
	//MARK: - Setup
	//textFieldSetup
	private func textFieldSetup() {
		self.textField.delegate           = self
		self.textField.layer.cornerRadius = 5
		self.textField.placeholder        = " craete new task"
		self.textField.borderStyle        = UITextField.BorderStyle.none
		self.textField.backgroundColor    = UIColor(named: "WhiteBlack")
		self.textField.addTarget(self, action: #selector(textFieldDidChande), for: .editingChanged)
	}
	
	@objc private func textFieldDidChande() {
		switchAlert.isEnabled = true
		taskStruct.taskTitle = textField.text
		if textField.text == ""{
			allEnabled()
		}
	}
	
  private func infoLabelSetup() {
		infoLabel.numberOfLines = 2
		infoLabel.textAlignment = .center
		infoLabel.text = "Just write you note"
	}
	
	private func setWeekDaySetup() {
		self.setWeekDay.isHidden   = true
		self.setWeekDay.dataSource = self
		self.setWeekDay.delegate   = self
	}
	
	
	//MARK: Set Time Picker
	private func setTimePickerSetup() {
		self.setTimePicker.isHidden = true
		self.setTimePicker.datePickerMode = .time
		self.setTimePicker.preferredDatePickerStyle = .wheels
		self.setTimePicker.addTarget(self, action: #selector(setTimePicker(paramDataPicker:)), for: .valueChanged)
	}
	
	@objc private func setTimePicker(paramDataPicker: UIDatePicker) {
		let timeHM = timeMHformatter(paramDataPicker: paramDataPicker)
		infoLabelTextTime(timeH: timeHM.0, timeM: timeHM.1)
	}
	
	private func timeMHformatter(paramDataPicker: UIDatePicker) -> (String, String) {
		let timeFromDP               = paramDataPicker.date
		let timeHourFormatter        = DateFormatter()
		let timeMinFormatter         = DateFormatter()
		timeHourFormatter.dateFormat = "H"
		timeMinFormatter.dateFormat  = "m"
		let timeHRepeatLabel         = timeHourFormatter.string(from: timeFromDP)
	  let timeMRepeatLabel         = timeMinFormatter.string(from: timeFromDP)
		taskStruct.taskTime          = nil
		taskStruct.taskDateDate      = nil
		taskStruct.timeInterval      = String(((Int(timeHRepeatLabel) ?? 0)*3600) + ((Int(timeMRepeatLabel) ?? 0)*60) )
		let timeHM    = (timeHRepeatLabel, timeMRepeatLabel)
		return timeHM
	}
	
	private func infoLabelTextTime(timeH: String, timeM: String) {
				var hour = ""
				var min  = ""
				timeH != "1" ? (hour = "hours") : (hour = "hour")
				timeM != "1" ? (min = "minutes") : (min = "minute")
				if timeH == "0", timeM == "0"  {
					infoLabel.text = "no repeat"
				} else if
					timeM == "0" {
					infoLabel.text = "repeat every \(timeH) \(hour)"
				} else if
					timeH == "0" {
					infoLabel.text = "repeat every \(timeM) \(min)"
				} else {
					infoLabel.text = "repeat every \(timeH) \(hour) \(timeM) \(min)"
				}
	}
	
	
	//MARK: Set Date Picker
	private func pickerSetup() {
		let dateNow = Date()
		self.dataPicker.isEnabled    = false
		self.dataPicker.date         = dateNow
		self.dataPicker.minimumDate  = dateNow
		self.dataPicker.timeZone     = .autoupdatingCurrent
		self.dataPicker.addTarget(self, action: #selector(dataPickerChange(paramDataPicker:)), for: .valueChanged)
	}
	
	@objc private func dataPickerChange(paramDataPicker: UIDatePicker) {
		let resulst = dateFormatter(dateFromDP: paramDataPicker)
		infoLabelTextDate(paramDP: paramDataPicker, month: resulst)
	}
	
	private func dateFormatter(dateFromDP: UIDatePicker) -> String {
		let dateFromDP                 = dateFromDP.date
		let timeFormatter              = DateFormatter()
		let dateFormatter              = DateFormatter()
		let dateFormatterMonth         = DateFormatter()
		let dayOfMonth                 = DateFormatter()
		timeFormatter.dateFormat       = "HH:mm"
		dateFormatter.dateFormat       = "dd.MM"
		dateFormatterMonth.dateFormat  = "EEEE, MMM d"
		dayOfMonth.dateFormat          = "d"
		taskStruct.taskTime            = timeFormatter.string(from: dateFromDP)
		taskStruct.taskDate            = dateFormatter.string(from: dateFromDP)
		dayOfMonthLabel                = dayOfMonth.string(from: dateFromDP)
		let monthLabel                 = dateFormatterMonth.string(from: dateFromDP)
		taskStruct.taskDateDate        = dateFromDP
		return monthLabel
	}
	
	private func infoLabelTextDate(paramDP: UIDatePicker, month: String) {
		guard paramDP.isEqual(self.dataPicker) else { return }
		if repeatSegmented.selectedSegmentIndex == 0 {
			infoLabel.text = "repeat every day at \(taskStruct.taskTime!)"
		} else if repeatSegmented.selectedSegmentIndex == 1{
			infoLabel.text = "repeat every \(taskStruct.weekDay!) at \(taskStruct.taskTime!)"
		} else if repeatSegmented.selectedSegmentIndex == 2 {
			infoLabel.text = "repeat every month on the\n \(dayOfMonthLabel)th at \(taskStruct.taskTime!)"
		}
	}
		
	
private func alertLabelSetup() {
		alertLabel.image              = UIImage(systemName: "alarm")
		alertLabel.tintColor          = .gray
		alertLabel.contentMode        = .scaleAspectFit
	}
	
	
	private func repeatLabelSetup() {
		repeatLabel.image             = UIImage(systemName: "repeat")
		repeatLabel.tintColor         = .gray
		repeatLabel.contentMode       = .scaleAspectFit
	}
	
	private func setupSegmented() {
		repeatSegmented               = UISegmentedControl(items: segmentedItems)
		repeatSegmented.isEnabled     = false
		repeatSegmented.addTarget(self, action: #selector(repeatSegmentedChange(paramRepeatSegmented:)), for: .valueChanged)
	}
	
	private func switchAlertSetup(){
		switchAlert.isEnabled         = false
		switchAlert.isOn              = false
		switchAlert.addTarget(self, action: #selector(visibilityDataPickerAndSwitchAlertRepeat), for: .valueChanged)
	}
	
	private func allEnabled() {
		switchAlert.isEnabled         = false
		switchAlertRepeat.isEnabled   = false
		repeatSegmented.isEnabled     = false
		dataPicker.isEnabled          = false
		switchAlert.isOn              = false
		switchAlertRepeat.isOn        = false
		setTimePicker.isHidden        = true
		repeatSegmented.selectedSegmentIndex = UISegmentedControl.noSegment
	}
	
	@objc private func repeatSegmentedChange(paramRepeatSegmented: UISegmentedControl) {
		if paramRepeatSegmented.isEqual(self.repeatSegmented){
			let repeatFromSegmented = paramRepeatSegmented.selectedSegmentIndex
			
			if repeatFromSegmented == 0 {
				self.dataPicker.isEnabled   = true
				self.dataPicker.isHidden    = false
				self.setTimePicker.isHidden = true
				self.setWeekDay.isHidden    = true
				taskStruct.timeInterval     = "3600"
				infoLabel.text              = "Daily reminders at set times"
			} else if
				repeatFromSegmented == 1 {
				self.view.endEditing(true)
				self.dataPicker.isEnabled   = true
				self.dataPicker.isHidden    = false
				self.setTimePicker.isHidden = true
				self.setWeekDay.isHidden    = false
				infoLabel.text              = "Weekly reminders at set times"
			} else if
				repeatFromSegmented == 2 {
				self.dataPicker.isEnabled   = true
				self.dataPicker.isHidden    = false
				self.setTimePicker.isHidden = true
				self.setWeekDay.isHidden    = true
				infoLabel.text              = "Monthly reminders at set times"
			} else if
				repeatFromSegmented == 3 {
				self.view.endEditing(true)
				self.dataPicker.isEnabled   = false
				self.dataPicker.isHidden    = true
				self.setTimePicker.isHidden = false
				self.setWeekDay.isHidden    = true
				infoLabel.text              = "Set the repeat time"
			}
		}
	}
	
	@objc private func visibilityDataPickerAndSwitchAlertRepeat() {
		taskStruct.alarmImage = switchAlert.isOn
		if switchAlert.isOn == true {
			self.dataPicker.isEnabled            = true
			self.dataPicker.isHidden             = false
			self.switchAlertRepeat.isEnabled     = true
			self.infoLabel.text                  = "Set the date and time of the reminder"
		} else{
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
	
	private func switchAlertRepeatSetup(){
		switchAlertRepeat.isOn      = false
		switchAlertRepeat.isEnabled = false
		switchAlertRepeat.addTarget(self, action: #selector(visibilityRepeatSegmented), for: .valueChanged)
	}
	
	@objc private func visibilityRepeatSegmented() {
		taskStruct.repeatImage  = switchAlertRepeat.isOn
		if switchAlertRepeat.isOn == false {
			self.repeatSegmented.isEnabled = false
			self.repeatSegmented.selectedSegmentIndex = UISegmentedControl.noSegment
			self.dataPicker.minimumDate    = Date()
			self.dataPicker.isEnabled      = true
			self.dataPicker.isHidden       = false
			self.setTimePicker.isHidden    = true
			self.setWeekDay.isHidden       = true
			self.infoLabel.text            = "Set the date and time of the reminder"
		}else{
			self.repeatSegmented.isEnabled = true
			self.dataPicker.isHidden       = false
			self.dataPicker.minimumDate    = nil
			self.infoLabel.text            = "Choose a repeat rate"
		}
	}
	
	private func navigationBarSetup() {
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
	

	@objc private func continueFunc(){
		guard let textTitle = textField.text, !textTitle.isEmpty else { return }
		guard infoLabel.text != "Set the date and time of the reminder" else { return }
		guard infoLabel.text != "Choose a repeat rate" else { return }
		guard infoLabel.text != "no repeat" else { return }
		taskStruct.createdAt  = Date.now
		  coreData.saveTask(taskTitle:     taskStruct.taskTitle!,
												taskTime:      taskStruct.taskTime,
												taskDate:      taskStruct.taskDate,
												taskDateDate:  taskStruct.taskDateDate,
												createdAt:     taskStruct.createdAt,
												check:         taskStruct.check,
												alarmImage:    taskStruct.alarmImage,
												repeatImage:   taskStruct.repeatImage,
												timeInterval:  taskStruct.timeInterval)
		cancelFunc()
			NotificationCenter.default.post(name: Notification.Name("TableViewReloadData"), object: .none)
	}
	
	@objc private func cancelFunc(){
		textField.text                = nil
		dataPicker.isEnabled          = false
		switchAlert.isOn              = false
		switchAlertRepeat.isOn        = false
		setTimePicker.isHidden        = true
		repeatSegmented.isEnabled     = false
		switchAlertRepeat.isEnabled   = false
		switchAlert.isEnabled         = false
		setWeekDay.isHidden           = true
		infoLabel.text                = "Just write you note"
		taskStruct.taskTime           = ""
		taskStruct.taskDate           = ""
		taskStruct.taskDateDate       = nil
		taskStruct.timeInterval       = nil
		repeatSegmented.selectedSegmentIndex = UISegmentedControl.noSegment
		dismiss(animated: true, completion: nil)
	}
}
