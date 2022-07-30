//
//  NewTask.swift
//  ToDo
//
//  Created by Антон on 08.05.2022.
//

import Foundation
import UIKit
import CoreData
protocol NewTaskProtocol: AnyObject {
	
}

class NewTask: UIViewController {
	var taskStruct = TaskStruct()
	private let viewModel: NewTaskViewModelProtocol
	
	init(viewModel: NewTaskViewModelProtocol) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: - Properties
	let infoLabel           = UILabel()
	let textField           = UITextField()
	let dataPicker          = UIDatePicker()
	let dataPickerMonth     = UIDatePicker()
	let setTimePicker       = UIDatePicker()
	let setTimePicker2      = UIDatePicker()
	let setTimePickerWeek   = UIDatePicker()
	var button              = UIButton()
	//let buttonStackView          = UIPickerView()
	let switchAlert         = UISwitch()
	let switchAlertRepeat   = UISwitch()
	let navigationBar       = UINavigationBar()
	let alertLabel          = UIImageView()
	let repeatLabel         = UIImageView()
	var repeatSegmented     = UISegmentedControl()
	let weekDayButton       = UIButton()
	lazy var buttonStackView     = UIStackView()
	var coreData            = CoreDataMethods()
	var segmentedItems      = ["day", "week", "month", "set time"]
	let weekDaysArray       = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
	var buttonArray: [UIButton] = []
	weak var mainViewModel  : MainViewModel?
	let tappedFeedBack = TappedFeedBack()
	
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		createButtonWeekDays()
	}
	
	//MARK: - viewDidAppear
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.setTimePicker.datePickerMode = .countDownTimer
		self.textField.becomeFirstResponder()
	}
	
	//MARK: - viewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		setStackView()
		//addButtonToStackView()
		dataPickerSetup()
		dataPickerMonthSetup()
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
		setTimePickerSetup2()
		setTimePickerSetup3()
		infoLabelSetup()
		//buttonStackViewSetup()
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
	
	private func setStackView() {
		self.buttonStackView.isHidden = true
		self.buttonStackView.axis = .horizontal
		self.buttonStackView.spacing = 7
		self.buttonStackView.alignment = .center
		self.buttonStackView.distribution = .fillEqually
	}
 
	
	private func createButtonWeekDays() {
		let weekDaysName = ["sun", "mon", "tue", "wen", "thu", "fri", "sat"]
		var buttonTag = 0
		for i in weekDaysName {
			self.button = UIButton(title: "\(i)", isShadow: true, font: UIFont.systemFont(ofSize: 13, weight: .regular), cornerRaadius: 12)
			buttonTag += 1
			button.tag = buttonTag
			button.addTarget(self, action: #selector(touchButton(sender:)), for: .touchUpInside)
			button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
			buttonStackView.addArrangedSubview(button)
		}
	}
	
	@objc func touchButton(sender: UIButton) {
		let button = sender
		let bools: Bool = { button.backgroundColor == .white }()
		let weekDay = button.title(for: .normal)!
		switch bools {
	case true:
			button.backgroundColor = .systemBlue
			button.setTitleColor(.white, for: .normal)
			button.layer.shadowColor = UIColor.white.cgColor
			taskStruct.weekDayChoice?.append(weekDay)
			print(taskStruct.weekDayChoice ?? "error")
	case false:
			button.backgroundColor = .white
			button.setTitleColor(.lightGray, for: .normal)
			button.layer.shadowColor = UIColor.black.cgColor
			taskStruct.weekDayChoice?.removeAll { $0 == weekDay }
			print(taskStruct.weekDayChoice ?? "error")
		}
	}
	

	@objc private func textFieldDidChande() {
		switchAlert.isEnabled = true
		taskStruct.taskTitle = textField.text ?? ""
		if textField.text == ""{
			allEnabled()
		}
	}
	
	private func infoLabelSetup() {
		infoLabel.numberOfLines = 2
		infoLabel.textAlignment = .center
		infoLabel.font = UIFont.futura17()
		infoLabel.text          = "Just write you note"
	}
	
//	private func buttonStackViewSetup() {
//		self.buttonStackView.isHidden   = true
//		self.buttonStackView.dataSource = self
//		self.buttonStackView.delegate   = self
//	}
	
	//MARK: Set Time Picker
	private func setTimePickerSetup() {
		self.setTimePicker.isHidden = true
		self.setTimePicker.preferredDatePickerStyle = .wheels
		self.setTimePicker.addTarget(self, action: #selector(setTimePicker(paramDataPicker:)), for: .valueChanged)
	}
	
	private func setTimePickerSetup2() {
		self.setTimePicker2.isHidden = true
		self.setTimePicker2.datePickerMode = .time
		self.setTimePicker2.minuteInterval = 5
		self.setTimePicker2.roundsToMinuteInterval = true
		self.setTimePicker2.preferredDatePickerStyle = .wheels
		self.setTimePicker2.addTarget(self, action: #selector(setTimePicker(paramDataPicker:)), for: .valueChanged)
	}
	
	private func setTimePickerSetup3() {
		self.setTimePickerWeek.isHidden = true
		self.setTimePickerWeek.datePickerMode = .time
		//self.setTimePickerWeek.minuteInterval = 5
		//self.setTimePickerWeek.roundsToMinuteInterval = true
		self.setTimePickerWeek.preferredDatePickerStyle = .wheels
		self.setTimePickerWeek.addTarget(self, action: #selector(setTimePicker(paramDataPicker:)), for: .valueChanged)
	}
	
	@objc private func setTimePicker(paramDataPicker: UIDatePicker) {
		let timeHM = timeMHformatter(paramDataPicker: paramDataPicker)
		infoLabelTextTime(timeH: timeHM.0, timeM: timeHM.1, timeHM: timeHM.2)
	}
	
	private func timeMHformatter(paramDataPicker: UIDatePicker) -> (String, String, String) {
		let timeFromDP                  = paramDataPicker.date
		let timeHourFormatter           = DateFormatter()
		let timeMinFormatter            = DateFormatter()
		let timeHourMinFormatter        = DateFormatter()
		timeHourFormatter.dateFormat    = "H"
		timeMinFormatter.dateFormat     = "m"
		timeHourMinFormatter.dateFormat = "HH:mm"
		let timeHRepeatLabel            = timeHourFormatter.string(from: timeFromDP)
		let timeMRepeatLabel            = timeMinFormatter.string(from: timeFromDP)
		let timeHMRepeatLabel           = timeHourMinFormatter.string(from: timeFromDP)
		taskStruct.taskTime             = timeHMRepeatLabel
		taskStruct.taskDateDate         = timeFromDP
		taskStruct.timeInterval         = String(((Int(timeHRepeatLabel) ?? 0)*3600) + ((Int(timeMRepeatLabel) ?? 0)*60) )
		let timeHM    = (timeHRepeatLabel, timeMRepeatLabel, timeHMRepeatLabel)
		return timeHM
	}
	
	private func infoLabelTextTime(timeH: String, timeM: String, timeHM: String) {
		var hour = ""
		var min  = ""
		timeH != "1" ? (hour = "hours") : (hour = "hour")
		timeM != "1" ? (min = "minutes") : (min = "minute")
		
		switch repeatSegmented.selectedSegmentIndex {
		case 0: infoLabel.text = "repeat every day at \(taskStruct.taskTime!)"
		case 1: infoLabel.text = "repeat every selected day of the week at \(taskStruct.taskTime!)"
		case 2: infoLabel.text = "repeat every month on the\n \(taskStruct.dayOfMonth!)th at \(taskStruct.taskTime!)"
		default:
			
			if timeM == "0" {
				infoLabel.text = "repeat every \(timeH) \(hour)"
			} else if timeH == "0" {
				infoLabel.text = "repeat every \(timeM) \(min)"
			} else {
				infoLabel.text = "repeat every \(timeH) \(hour) \(timeM) \(min)"
			}
		}
	}
	
	//MARK: Set Date Picker
	private func 		dataPickerSetup() {
		let dateNow = Date.now
		self.dataPicker.isEnabled    = false
		self.dataPicker.date         = dateNow
		self.dataPicker.minimumDate  = dateNow
		self.dataPicker.timeZone     = .autoupdatingCurrent
		self.dataPicker.addTarget(self, action: #selector(dataPickerChange(paramDataPicker:)), for: .valueChanged)
	}
	
	private func 		dataPickerMonthSetup() {
		self.dataPickerMonth.isHidden       = true
		self.dataPickerMonth.timeZone       = .autoupdatingCurrent
		self.dataPickerMonth.datePickerMode = .date
		self.dataPickerMonth.addTarget(self, action: #selector(dataPickerChange(paramDataPicker:)), for: .valueChanged)
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
		taskStruct.dayOfMonth          = dayOfMonth.string(from: dateFromDP)
		let monthLabel                 = dateFormatterMonth.string(from: dateFromDP)
		taskStruct.taskDateDate        = dateFromDP
		taskStruct.type                = .singleAlertType
		return monthLabel
	}
	
	private func infoLabelTextDate(paramDP: UIDatePicker, month: String) {
		guard paramDP.isEqual(self.dataPicker) else { return }
		switch repeatSegmented.selectedSegmentIndex {
		case 0:  infoLabel.text = "repeat every day at \(taskStruct.taskTime!)"
		case 1:  infoLabel.text = "repeat every \(taskStruct.weekDay!) at \(taskStruct.taskTime!)"
		case 2:  infoLabel.text = "repeat every month on the\n \(taskStruct.dayOfMonth!)th at \(taskStruct.taskTime!)"
		default: infoLabel.text = "the reminder will be set for\n \(month) \(taskStruct.taskTime!)"
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
		setTimePicker2.isHidden       = true
		buttonStackView.isHidden           = true
		infoLabel.text                = "Just write you note"
		repeatSegmented.selectedSegmentIndex = UISegmentedControl.noSegment
	}
	
	@objc private func repeatSegmentedChange(paramRepeatSegmented: UISegmentedControl) {
		if paramRepeatSegmented.isEqual(self.repeatSegmented){
			switch paramRepeatSegmented.selectedSegmentIndex {
			case 0:
				self.dataPicker.isEnabled       = true
				self.dataPicker.isHidden        = true
				self.dataPickerMonth.isHidden   = true
				self.setTimePicker.isHidden     = true
				self.setTimePicker2.isHidden    = false
				self.setTimePickerWeek.isHidden = true
				self.buttonStackView.isHidden        = true
				self.taskStruct.type            = .dayRepeatType
				infoLabel.text                  = "Daily reminders at set times"
			case 1:
				self.view.endEditing(true)
				self.dataPicker.isEnabled       = true
				self.dataPicker.isHidden        = true
				self.dataPickerMonth.isHidden   = true
				self.setTimePicker.isHidden     = true
				self.setTimePicker2.isHidden    = true
				self.setTimePickerWeek.isHidden = false
				self.buttonStackView.isHidden   = false
				self.taskStruct.type            = .weekRepeatType
				infoLabel.text                  = "Weekly reminders at set times"
			case 2:
				self.dataPicker.isEnabled       = true
				self.dataPicker.isHidden        = false
				self.dataPickerMonth.isHidden   = false
				self.setTimePicker.isHidden     = true
				self.setTimePicker2.isHidden    = true
				self.setTimePickerWeek.isHidden = true
				self.buttonStackView.isHidden        = true
				self.taskStruct.type            = .monthRepeatType
				infoLabel.text                  = "Monthly reminders at set times"
			default:
				self.view.endEditing(true)
				self.dataPicker.isEnabled       = false
				self.dataPicker.isHidden        = true
				self.dataPickerMonth.isHidden   = true
				self.setTimePicker.isHidden     = false
				self.setTimePicker2.isHidden    = true
				self.setTimePickerWeek.isHidden = true
				self.buttonStackView.isHidden        = true
				self.taskStruct.type            = .timeRepeatType
				infoLabel.text                  = "Set the repeat time"
			}
		}
	}
	
	@objc private func visibilityDataPickerAndSwitchAlertRepeat() {
		taskStruct.alarmImage = switchAlert.isOn
		if switchAlert.isOn == true {
			self.dataPicker.isEnabled         = true
			self.dataPicker.isHidden          = false
			self.switchAlertRepeat.isEnabled  = true
			self.infoLabel.text               = "Set the date and time of the reminder"
		} else {
			self.dataPicker.isEnabled         = false
			self.dataPicker.isHidden          = false
			self.dataPickerMonth.isHidden     = true
			self.dataPicker.minimumDate       = Date()
			self.switchAlertRepeat.isEnabled  = false
			self.switchAlertRepeat.isOn       = false
			self.repeatSegmented.isEnabled    = false
			self.setTimePicker.isHidden       = true
			self.setTimePicker2.isHidden      = true
			self.setTimePickerWeek.isHidden   = true
			self.buttonStackView.isHidden          = true
			self.infoLabel.text               = "Create your note"
			self.repeatSegmented.selectedSegmentIndex = UISegmentedControl.noSegment
		}
	}
	
	private func switchAlertRepeatSetup(){
		switchAlertRepeat.isOn      = false
		switchAlertRepeat.isEnabled = false
		switchAlertRepeat.addTarget(self, action: #selector(visibilityRepeatSegmented), for: .valueChanged)
	}
	
	@objc private func visibilityRepeatSegmented() {
		taskStruct.repeatImage = switchAlertRepeat.isOn
		switch switchAlertRepeat.isOn {
		case false:
			self.repeatSegmented.isEnabled  = false
			self.repeatSegmented.selectedSegmentIndex = UISegmentedControl.noSegment
			self.dataPicker.minimumDate     = Date()
			self.dataPicker.isEnabled       = true
			self.dataPicker.isHidden        = false
			self.dataPickerMonth.isHidden   = true
			self.setTimePicker.isHidden     = true
			self.setTimePicker2.isHidden    = true
			self.setTimePickerWeek.isHidden = true
			self.buttonStackView.isHidden        = true
			self.infoLabel.text             = "Set the date and time of the reminder"
			self.taskStruct.repeatImage     = false
		case true:
			self.repeatSegmented.isEnabled  = true
			self.dataPicker.isHidden        = false
			self.dataPicker.minimumDate     = nil
			self.infoLabel.text             = "Choose a repeat rate"
		}
	}
	
	private func navigationBarSetup() {
		let leftButton  = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(cancelFunc))
		let rightButton = UIBarButtonItem(title: "continue", style: .plain, target: self, action: #selector(continueFunc))
		//self.navigationController?.
		self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.futura20()!, NSAttributedString.Key.foregroundColor: UIColor.black]
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
	
	@objc private func continueFunc() {
		let text = infoLabel.text
		taskStruct.createdAt  = Date.now
		guard let textTitle = textField.text, !textTitle.isEmpty else { redText(); return }
		guard text != "Set the date and time of the reminder" else { redText(); return }
		guard text != "Choose a repeat rate" else { redText(); return }
		guard text != "no repeat" else { redText(); return }
		guard text != "Set the repeat time" else { redText(); return }
		guard text != "Daily reminders at set times" else { redText(); return }
		guard text != "Weekly reminders at set times" else { redText(); return }
		guard text != "Monthly reminders at set times" else { redText(); return }
		
		switch taskStruct.type {
		case .justType:
			coreData.saveJustTask(taskTitle:      taskStruct.taskTitle,
														createdAt:      taskStruct.createdAt!,
														type:           taskStruct.type.rawValue)
		case .singleAlertType:
			coreData.saveAlertTask(taskTitle:    taskStruct.taskTitle,
														 taskTime:     taskStruct.taskTime!,
														 taskDate:     taskStruct.taskDate!,
														 taskDateDate: taskStruct.taskDateDate!,
														 createdAt:    taskStruct.createdAt!,
														 alarmImage:   taskStruct.alarmImage,
														 type:         taskStruct.type.rawValue)
		case .timeRepeatType:
			coreData.saveRepeatTask(taskTitle:    taskStruct.taskTitle,
															createdAt:    taskStruct.createdAt!,
															alarmImage:   taskStruct.alarmImage,
															repeatImage:  taskStruct.repeatImage,
															timeInterval: taskStruct.timeInterval!,
															type:         taskStruct.type.rawValue)
		case .dayRepeatType:
			coreData.saveDailyRepitionTask(taskTitle:    taskStruct.taskTitle,
																		 taskTime:     taskStruct.taskTime!,
																		 taskDateDate: taskStruct.taskDateDate!,
																		 createdAt:    taskStruct.createdAt!,
																		 alarmImage:   taskStruct.alarmImage,
																		 repeatImage:  taskStruct.repeatImage,
																		 type:         taskStruct.type.rawValue)
		case .weekRepeatType:
			coreData.saveWeekDaysRepitionTask(taskTitle: taskStruct.taskTitle,
																				taskTime: taskStruct.taskTime!,
																				taskDateDate: taskStruct.taskDateDate!,
																				createdAt: taskStruct.createdAt!,
																				alarmImage: taskStruct.alarmImage,
																				repeatImage: taskStruct.repeatImage,
																				type: taskStruct.type.rawValue,
																				weekDay: taskStruct.weekDayChoice!)
		case .monthRepeatType:
			infoLabel.text = "in developing...will be later"
		}
		cancelFunc()
		NotificationCenter.default.post(name: Notification.Name("TableViewReloadData"), object: .none)
	}
	
	private func redText() {
		tappedHeavy()
			self.infoLabel.textColor = UIColor.red
			self.infoLabel.font = UIFont.futura20()
		DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
				self.infoLabel.textColor = UIColor.black
				self.infoLabel.font = UIFont.futura17()
		}
	}
	
	@objc private func cancelFunc(){
		textField.text                = nil
		dataPicker.isEnabled          = false
		dataPickerMonth.isHidden      = true
		switchAlert.isOn              = false
		switchAlertRepeat.isOn        = false
		setTimePicker.isHidden        = true
		setTimePicker2.isHidden       = true
		setTimePickerWeek.isHidden    = true
		repeatSegmented.isEnabled     = false
		repeatSegmented.isSelected    = false
		switchAlertRepeat.isEnabled   = false
		switchAlert.isEnabled         = false
		buttonStackView.isHidden           = true
		infoLabel.text                = "Just write you note"
		taskStruct.taskTime           = ""
		taskStruct.taskDate           = ""
		taskStruct.taskDateDate       = nil
		taskStruct.timeInterval       = nil
		taskStruct.repeatImage        = false
		taskStruct.alarmImage         = false
		taskStruct.weekDayChoice      = []
		taskStruct.type               = .justType
		repeatSegmented.selectedSegmentIndex = UISegmentedControl.noSegment
		dismiss(animated: true, completion: nil)
	}
}

extension NewTask: NewTaskProtocol {
	
}
