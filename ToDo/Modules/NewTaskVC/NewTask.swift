//
//  NewTask.swift
//  ToDo
//
//  Created by Антон on 08.05.2022.
//

import Foundation
import UIKit
import CoreData

fileprivate enum Constants {
	static var textFiledFont: UIFont { UIFont(name: "Helvetica Neue", size: 20)!}
	static var navigationItemTitle: String { NSLocalizedString("new task", comment: "") }
	static var textFiledPlaceholder: String { NSLocalizedString("...write something here", comment: "")  }
	static var leftButtonImage: UIImage { UIImage(named: "xmrk")! }
	static var rightButtonImage: UIImage { UIImage(named: "chckmrk")! }
	static var alertLabelImage: UIImage { UIImage(systemName: "alarm")! }
	static var repeatLabelImage: UIImage { UIImage(systemName: "repeat")! }
	static var infoLabelFont: UIFont { UIFont(name: "Futura", size: 17)!}
	static var infoLabelFont20: UIFont { UIFont(name: "Futura", size: 20)!}
	static var navigationTitleFont: UIFont { UIFont(name: "Futura", size: 20)!}
	static var backgroundColorView: UIColor { .systemBackground }
	static var barColorView: UIColor { UIColor(named: "barNewTask") ?? .systemBackground }
}

final class NewTask: UIViewController {
	internal var taskStruct = TaskStruct()
	internal var presenter: NewTaskPresenterProtocol!
	private var taptic = TapticFeedback()
	
	
	//MARK: - Properties
	private let dataPicker              = UIDatePicker()
	private let timePicker              = UIDatePicker()
	private let timePickerDWM           = UIDatePicker()
	
	private let switchAlert             = UISwitch()
	private let switchAlertRepeat       = UISwitch()
	private let alertLabel              = UIImageView()
	private let repeatLabel             = UIImageView()
	internal let infoLabel               = UILabel()
	private let textField               = UITextField()
	private let navigationBar           = UINavigationBar()
	private var repeatSegmented         = UISegmentedControl()
	
	private var button                  = UIButton()
	private let weekDayButton           = UIButton()
	private var buttonMonth             = UIButton()
	
	private var buttonStackView         = UIStackView()
	private var buttonMonthHStackView   = UIStackView()
	private var buttonMonthHStackView2  = UIStackView()
	private var buttonMonthHStackView3  = UIStackView()
	private var buttonMonthHStackView4  = UIStackView()
	private var buttonMonthHStackView5  = UIStackView()
	private var buttonMonthVStackView   = UIStackView()
	private let segmentedItems          = [NSLocalizedString("day", comment: ""),
										   NSLocalizedString("week", comment: ""),
										   NSLocalizedString("month", comment: ""),
										   NSLocalizedString("set time", comment: "")]
	private var segmented1Items          = ["Alarm", "Reapeat"]
	internal let weekDaysArray           = [NSLocalizedString("Sunday", comment: ""),
											NSLocalizedString("Monday", comment: ""),
											NSLocalizedString("Tuesday", comment: ""),
											NSLocalizedString("Wednesday", comment: ""),
											NSLocalizedString("Thursday", comment: ""),
											NSLocalizedString("Friday", comment: ""),
											NSLocalizedString("Saturday", comment: "")]
	
	//["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
	private var buttonArray: [UIButton] = []
	private var coreData                = CoreDataMethods()
	private var animations              = Animations()
	
	//MARK: - LiveCycles
	//MARK: - viewDidAppear
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.timePicker.datePickerMode = .countDownTimer
		self.textField.becomeFirstResponder()
	}
	
	
	
	//MARK: - viewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		createButtonWeekDays()
		createMonthButton()
		stackViewSetup()
		stackViewMonthSetup()
		dataPickerSetup()
		segmentedControllerSetup()
		textFieldSetup()
		addSubviewAndConfigure()
		navigationBarSetup()
		switchAlertSetup()
		switchAlertRepeatSetup()
		alertLabelSetup()
		repeatLabelSetup()
		setConstraits()
		timePickerSetup()
		timePickerDWMSetup()
		infoLabelSetup()
	}
	
	
	//MARK: - Setup
	private func navigationBarSetup() {
		let leftButton  = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(cancelFunc))
		let rightButton = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(continueFunc))
		leftButton.image = Constants.leftButtonImage
		rightButton.image = Constants.rightButtonImage
		leftButton.tintColor = .blackWhite
		rightButton.tintColor = .blackWhite
		self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: Constants.navigationTitleFont, NSAttributedString.Key.foregroundColor: UIColor.blackWhite as Any]
		self.navigationBar.frame               = CGRect(x: 0, y: 0, width: Int(self.view.bounds.size.width), height: 44)
		let navigationItem                     = UINavigationItem(title: Constants.navigationItemTitle)
		navigationItem.leftBarButtonItem       = leftButton
		navigationItem.rightBarButtonItem      = rightButton
		self.navigationBar.items               = [navigationItem]
		self.navigationBar.backgroundColor = Constants.barColorView
		self.navigationBar.setValue(true, forKey: "hidesShadow")
		self.navigationBar.barTintColor = Constants.barColorView
		self.navigationBar.backgroundColor = Constants.barColorView//Constants.backgroundColorView
		self.view.addSubview(navigationBar)
	}
	
	private func textFieldSetup() {
		self.textField.delegate           = self
		self.textField.layer.cornerRadius = 5
		self.textField.placeholder        = Constants.textFiledPlaceholder
		self.textField.borderStyle        = UITextField.BorderStyle.none
		self.textField.font               = Constants.textFiledFont
		self.textField.clearButtonMode    = .always
		self.textField.addTarget(self, action: #selector(textFieldDidChande), for: .editingChanged)
	}
	
	private func alertLabelSetup() {
		alertLabel.image              = Constants.alertLabelImage
		alertLabel.tintColor          = .gray
		alertLabel.contentMode        = .scaleAspectFit
	}
	
	private func repeatLabelSetup() {
		repeatLabel.image             = Constants.repeatLabelImage
		repeatLabel.tintColor         = .gray
		repeatLabel.contentMode       = .scaleAspectFit
	}
	
	private func segmentedControllerSetup() {
		repeatSegmented               = UISegmentedControl(items: segmentedItems)
		repeatSegmented.isHidden      = true
		repeatSegmented.addTarget(self, action: #selector(repeatSegmentedChange(paramRepeatSegmented:)), for: .valueChanged)
	}
	
	private func switchAlertSetup() {
		switchAlert.isEnabled         = false
		switchAlert.isOn              = false
		switchAlert.onTintColor       = .backgroundColor
		switchAlert.addTarget(self, action: #selector(visibilityDataPickerAndSwitchAlertRepeat), for: .valueChanged)
	}
	
	private func switchAlertRepeatSetup(){
		switchAlertRepeat.isOn        = false
		switchAlertRepeat.isEnabled   = false
		switchAlertRepeat.onTintColor = .backgroundColor
		switchAlertRepeat.addTarget(self, action: #selector(visibilityRepeatSegmented), for: .valueChanged)
	}
	
	private func stackViewSetup() {
		self.buttonStackView.isHidden = true
		self.buttonStackView.axis = .horizontal
		self.buttonStackView.spacing = 7
		self.buttonStackView.alignment = .center
		self.buttonStackView.distribution = .fillEqually
	}
	
	private func stackViewMonthSetup() {
		let arrStackView = [buttonMonthHStackView,
							buttonMonthHStackView2,
							buttonMonthHStackView3,
							buttonMonthHStackView4,
							buttonMonthHStackView5]
		for stackView in arrStackView {
			stackView.isHidden = false
			stackView.heightAnchor.constraint(equalTo: self.buttonMonth.heightAnchor).isActive = true
			stackView.axis = .horizontal
			stackView.spacing = 7
			stackView.alignment = .fill
			stackView.distribution = .fillProportionally
		}
	}
	
	private func buttonMonthVStackViewSetup() {
		buttonMonthVStackView.isHidden = true
		buttonMonthVStackView.axis = .vertical
		buttonMonthVStackView.spacing = 7
		buttonMonthVStackView.alignment = .leading
		buttonMonthVStackView.distribution = .fillProportionally
	}
	
	private func infoLabelSetup() {
		infoLabel.numberOfLines = 2
		infoLabel.textAlignment = .center
		infoLabel.font          = Constants.infoLabelFont
		infoLabel.text          = NSLocalizedString("create your note", comment: "")
		infoLabel.textColor     = .blackWhite
	}
	
	private func timePickerSetup() {
		self.timePicker.isHidden = true
		self.timePicker.preferredDatePickerStyle = .wheels
		self.timePicker.addTarget(self, action: #selector(setTimePicker(paramDataPicker:)), for: .valueChanged)
	}
	
	private func timePickerDWMSetup() {
		self.timePickerDWM.isHidden = true
		self.timePickerDWM.datePickerMode = .time
		self.timePickerDWM.minuteInterval = 1
		self.timePickerDWM.roundsToMinuteInterval = true
		self.timePickerDWM.preferredDatePickerStyle = .wheels
		self.timePickerDWM.addTarget(self, action: #selector(setTimePicker(paramDataPicker:)), for: .valueChanged)
	}
	
	private func 		dataPickerSetup() {
		let dateNow = Date.now
		self.dataPicker.isHidden     = true
		self.dataPicker.date         = dateNow
		self.dataPicker.minimumDate  = dateNow
		self.dataPicker.timeZone     = .autoupdatingCurrent
		self.dataPicker.addTarget(self, action: #selector(dataPickerChange(paramDataPicker:)), for: .valueChanged)
	}
	
	
	//MARK: - Methods
	private func createButtonWeekDays() {
		let locale = NSLocale.preferredLanguages.first!
		var weekDaysName: [String] = []
		if locale.hasPrefix("en") {
			weekDaysName = [NSLocalizedString("sun", comment: ""),
							NSLocalizedString("mon", comment: ""),
							NSLocalizedString("tue", comment: ""),
							NSLocalizedString("wed", comment: ""),
							NSLocalizedString("thu", comment: ""),
							NSLocalizedString("fri", comment: ""),
							NSLocalizedString("sat", comment: "")]
		} else if locale.hasPrefix("ru") {
			weekDaysName = [NSLocalizedString("mon", comment: ""),
							NSLocalizedString("tue", comment: ""),
							NSLocalizedString("wed", comment: ""),
							NSLocalizedString("thu", comment: ""),
							NSLocalizedString("fri", comment: ""),
							NSLocalizedString("sat", comment: ""),
							NSLocalizedString("sun", comment: ""),]
		}
		var buttonTag = 0
		for i in weekDaysName {
			self.button = UIButton(title: "\(i)", isShadow: true, font: UIFont.systemFont(ofSize: 15, weight: .regular), cornerRaadius: 12)
			buttonTag += 1
			button.tag = buttonTag
			button.addTarget(self, action: #selector(touchButton(sender:)), for: .touchUpInside)
			button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
			buttonStackView.addArrangedSubview(button)
		}
	}
	
	private func createMonthButton() {
		var monthButtonArray = [Int]()
		for num in 1...31 {
			monthButtonArray.append(num)
		}
		var buttonTag = 0
		let buttonArrStr = monthButtonArray.map{"\($0)"}
		for i in buttonArrStr {
			self.buttonMonth = UIButton(title: i, isShadow: true, font: UIFont.systemFont(ofSize: 15, weight: .regular), cornerRaadius: 18)
			buttonTag += 1
			buttonMonth.tag = buttonTag
			buttonMonth.addTarget(self, action: #selector(touchButtonMonth(sender:)), for: .touchUpInside)
			buttonMonth.heightAnchor.constraint(equalTo: buttonMonth.widthAnchor).isActive = true
			addMonthButtonInStackView(buttonMonth)
		}
		buttonMonthVStackView.addArrangedSubview(buttonMonthHStackView)
		buttonMonthVStackView.addArrangedSubview(buttonMonthHStackView2)
		buttonMonthVStackView.addArrangedSubview(buttonMonthHStackView3)
		buttonMonthVStackView.addArrangedSubview(buttonMonthHStackView4)
		buttonMonthVStackView.addArrangedSubview(buttonMonthHStackView5)
		buttonMonthVStackViewSetup()
	}
	
	private func addMonthButtonInStackView(_ button: UIButton) {
		switch button.tag {
		case 1...7: buttonMonthHStackView.addArrangedSubview(button)
		case 8...14: buttonMonthHStackView2.addArrangedSubview(button)
		case 15...21: buttonMonthHStackView3.addArrangedSubview(button)
		case 22...28: buttonMonthHStackView4.addArrangedSubview(button)
		case 29...31: buttonMonthHStackView5.addArrangedSubview(button)
		default:
			break
		}
	}
	
	@objc func touchButtonMonth(sender: UIButton) {
		taptic.soft
		let button = sender
		let bools: Bool = { button.backgroundColor == .whiteBlack }()
		let monthDay = button.title(for: .normal)!
		switch bools {
		case true:
			button.backgroundColor = .backgroundColor
			button.setTitleColor(.white, for: .normal)
			button.layer.shadowColor = nil
			taskStruct.monthDayChoice?.append(monthDay)
			print(taskStruct.monthDayChoice ?? "error")
		case false:
			button.backgroundColor = .whiteBlack
			button.setTitleColor(.lightGray, for: .normal)
			button.layer.shadowColor = UIColor.black.cgColor
			taskStruct.monthDayChoice?.removeAll { $0 == monthDay }
			print(taskStruct.monthDayChoice ?? "error")
		}
	}
	
	@objc func touchButton(sender: UIButton) {
		taptic.soft
		let button = sender
		let bools: Bool = { button.backgroundColor == .whiteBlack }()
		let weekDay = button.title(for: .normal)!
		switch bools {
		case true:
			button.backgroundColor = .backgroundColor
			button.setTitleColor(.white, for: .normal)
			button.layer.shadowColor = nil
			taskStruct.weekDayChoice?.append(weekDay)
			print(taskStruct.weekDayChoice ?? "error")
		case false:
			button.backgroundColor = .whiteBlack
			button.setTitleColor(.lightGray, for: .normal)
			button.layer.shadowColor = UIColor.black.cgColor
			taskStruct.weekDayChoice?.removeAll { $0 == weekDay }
			print(taskStruct.weekDayChoice ?? "error")
		}
	}
	
	@objc private func textFieldDidChande() {
		switchAlert.isEnabled = true
		switchAlertRepeat.isEnabled = true
		taskStruct.taskTitle = textField.text ?? ""
		if textField.text == "" {
			allEnabled()
		}
	}
	
	@objc private func setTimePicker(paramDataPicker: UIDatePicker) {
		let timeHM = timeMHformatter(paramDataPicker: paramDataPicker)
		infoLabelTextTime(timeH: timeHM.0, timeM: timeHM.1, timeHM: timeHM.2)
	}
	
	private func timeMHformatter(paramDataPicker: UIDatePicker) -> (String, String, String) {
		self.presenter.tFormatter(paramDataPicker: paramDataPicker)
	}
	
	private func infoLabelTextTime(timeH: String, timeM: String, timeHM: String) {
		var hour = ""
		var min  = ""
		timeH != "1" ? (hour = NSLocalizedString("hours", comment: "")) : (hour = NSLocalizedString("hour", comment: ""))
		timeM != "1" ? (min = NSLocalizedString("minutes", comment: "")) : (min = NSLocalizedString("minute", comment: ""))
		let time = taskStruct.taskTime!
		switch repeatSegmented.selectedSegmentIndex {
		case 0: infoLabel.text = String.localizedStringWithFormat(NSLocalizedString("repeat every day at %@", comment: ""), time)
			//	NSLocalizedString("repeat every day at \(taskStruct.taskTime!)", comment: "")
		case 1: infoLabel.text = String.localizedStringWithFormat(NSLocalizedString("repeat every selected day of the week at %@", comment: ""), time)
		case 2: infoLabel.text = String.localizedStringWithFormat(NSLocalizedString("repeat every selected day of the month at %@", comment: ""), time)
		default:
			
			if timeM == "0" {
				infoLabel.text = String.localizedStringWithFormat(NSLocalizedString("repeat every %@ %@", comment: ""), timeH, hour)
			} else if timeH == "0" {
				infoLabel.text = String.localizedStringWithFormat(NSLocalizedString("repeat every %@ %@", comment: ""), timeM, min)
			} else {
				infoLabel.text =  String.localizedStringWithFormat(NSLocalizedString("repeat every %@ %@ %@ %@", comment: ""), timeH, hour, timeM, min)
			}
		}
	}
	
	@objc private func dataPickerChange(paramDataPicker: UIDatePicker) {
		let resulst = dateFormatter(dateFromDP: paramDataPicker)
		infoLabelTextDate(paramDP: paramDataPicker, month: resulst)
	}
	
	private func dateFormatter(dateFromDP: UIDatePicker) -> String {
		self.presenter.dFormatter(dateFromDP: dateFromDP)
	}
	
	private func infoLabelTextDate(paramDP: UIDatePicker, month: String) {
		guard paramDP.isEqual(self.dataPicker) else { return }
		let time = taskStruct.taskTime!
		switch repeatSegmented.selectedSegmentIndex {
		case 0:  infoLabel.text = String.localizedStringWithFormat(NSLocalizedString("repeat every day at %@", comment: ""), time)
		case 1:  infoLabel.text = NSLocalizedString("repeat every \(taskStruct.weekDay!) at \(taskStruct.taskTime!)", comment: "")
		case 2:  infoLabel.text = NSLocalizedString("repeat every selected day of the month at\n \(taskStruct.taskTime!)", comment: "")
		default: infoLabel.text = String.localizedStringWithFormat(NSLocalizedString("the reminder will be set for\n %@ %@", comment: ""), month, time)
		}
	}
	
	@objc private func repeatSegmentedChange(paramRepeatSegmented: UISegmentedControl) {
		if paramRepeatSegmented.isEqual(self.repeatSegmented){
			switch paramRepeatSegmented.selectedSegmentIndex {
			case 0:
				self.view.endEditing(true)
				self.dataPicker.isHidden        = true
				self.timePicker.isHidden        = true
				self.timePickerDWM.isHidden     = false
				self.buttonStackView.isHidden   = true
				self.buttonMonthVStackView.isHidden = true
				self.taskStruct.type            = .dayRepeatType
				infoLabel.text                  = NSLocalizedString("Daily reminders at set times", comment: "")
			case 1:
				self.view.endEditing(true)
				self.dataPicker.isHidden        = true
				self.timePicker.isHidden        = true
				self.timePickerDWM.isHidden     = false
				self.buttonStackView.isHidden   = false
				self.buttonMonthVStackView.isHidden = true
				self.taskStruct.type            = .weekRepeatType
				infoLabel.text                  = NSLocalizedString("Weekly reminders at set times", comment: "")
			case 2:
				self.view.endEditing(true)
				self.dataPicker.isHidden        = true
				self.timePicker.isHidden        = true
				self.timePickerDWM.isHidden     = false
				self.buttonStackView.isHidden   = true
				self.buttonMonthVStackView.isHidden = false
				self.taskStruct.type            = .monthRepeatType
				infoLabel.text                  = NSLocalizedString("Monthly reminders at set times", comment: "")
			case 3:
				self.view.endEditing(true)
				self.dataPicker.isHidden        = true
				self.timePicker.isHidden        = false
				self.timePickerDWM.isHidden     = true
				self.buttonStackView.isHidden   = true
				self.buttonMonthVStackView.isHidden = true
				self.taskStruct.type            = .timeRepeatType
				infoLabel.text                  = NSLocalizedString("Set the repeat time", comment: "")
			default:
				break
			}
		}
	}
	
	@objc private func visibilityDataPickerAndSwitchAlertRepeat() {
		taskStruct.alarmImage = switchAlert.isOn
		switch switchAlert.isOn {
		case true:
			self.dataPicker.isHidden             = false
			self.infoLabel.text                  = NSLocalizedString("Set the date and time of the reminder", comment: "")
			self.taskStruct.type                 = .singleAlertType
		case false:
			self.dataPicker.isHidden             = true
			self.dataPicker.minimumDate          = Date()
			self.switchAlertRepeat.isOn          = false
			self.repeatSegmented.isHidden       = true
			self.timePicker.isHidden             = true
			self.timePickerDWM.isHidden          = true
			self.buttonStackView.isHidden        = true
			self.buttonMonthVStackView.isHidden  = true
			self.taskStruct.type                 = .justType
			self.infoLabel.text                  = NSLocalizedString("create your note", comment: "")
			self.repeatSegmented.selectedSegmentIndex = UISegmentedControl.noSegment
		}
	}
	
	@objc private func visibilityRepeatSegmented() {
		taskStruct.alarmImage = true
		taskStruct.repeatImage = switchAlertRepeat.isOn
		switch switchAlertRepeat.isOn {
		case true:
			self.repeatSegmented.isHidden             = false
			self.switchAlert.isOn                     = true
			self.switchAlert.isEnabled                = true
			self.repeatSegmented.isEnabled            = true
			self.dataPicker.isHidden                  = true
			self.dataPicker.minimumDate               = nil
			self.infoLabel.text                       = NSLocalizedString("Choose a repeat rate", comment: "")
		case false:
			self.repeatSegmented.isHidden            = true
			self.repeatSegmented.selectedSegmentIndex = UISegmentedControl.noSegment
			self.dataPicker.minimumDate               = Date()
			self.dataPicker.isEnabled                 = true
			self.dataPicker.isHidden                  = false
			self.timePicker.isHidden                  = true
			self.timePickerDWM.isHidden               = true
			self.buttonStackView.isHidden             = true
			self.buttonMonthVStackView.isHidden       = true
			self.taskStruct.type                      = .singleAlertType
			self.infoLabel.text                       = NSLocalizedString("Set the date and time of the reminder", comment: "")
			self.taskStruct.repeatImage               = false
			self.taskStruct.alarmImage                = true
		}
	}
	
	
	//MARK: - Continue Func
	@objc private func continueFunc() {
		taskStruct.createdAt  = Date.now
		let text = infoLabel.text
		guard let textTitle = textField.text, !textTitle.isEmpty else { animations.shake(text: infoLabel, duration: 0.4); return }
		guard text != NSLocalizedString("Set the date and time of the reminder", comment: "") else { animations.shake(text: infoLabel, duration: 0.4); return }
		guard text != NSLocalizedString("Choose a repeat rate", comment: "") else { animations.shake(text: infoLabel, duration: 0.4); return }
		guard text != NSLocalizedString("Set the repeat time", comment: "") else { animations.shake(text: infoLabel, duration: 0.4); return }
		guard text != NSLocalizedString("Daily reminders at set times", comment: "") else { animations.shake(text: infoLabel, duration: 0.4); return }
		guard text != NSLocalizedString("Weekly reminders at set times", comment: "") else { animations.shake(text: infoLabel, duration: 0.4); return }
		guard text != NSLocalizedString("Monthly reminders at set times", comment: "") else { animations.shake(text: infoLabel, duration: 0.4); return }
		
		switch taskStruct.type {
		case .justType:
			coreData.saveJustTask(taskTitle:      taskStruct.taskTitle,
								  createdAt:      taskStruct.createdAt,
								  type:           taskStruct.type.rawValue)
		case .singleAlertType:
			coreData.saveAlertTask(taskTitle:    taskStruct.taskTitle,
								   taskTime:     taskStruct.taskTime!,
								   taskDate:     taskStruct.taskDate!,
								   taskDateDate: taskStruct.taskDateDate!,
								   createdAt:    taskStruct.createdAt,
								   alarmImage:   taskStruct.alarmImage,
								   type:         taskStruct.type.rawValue)
		case .timeRepeatType:
			coreData.saveRepeatTask(taskTitle:    taskStruct.taskTitle,
									createdAt:    taskStruct.createdAt,
									alarmImage:   taskStruct.alarmImage,
									repeatImage:  taskStruct.repeatImage,
									timeInterval: taskStruct.timeInterval!,
									type:         taskStruct.type.rawValue)
		case .dayRepeatType:
			coreData.saveDailyRepitionTask(taskTitle:    taskStruct.taskTitle,
										   taskTime:     taskStruct.taskTime!,
										   taskDateDate: taskStruct.taskDateDate!,
										   createdAt:    taskStruct.createdAt,
										   alarmImage:   taskStruct.alarmImage,
										   repeatImage:  taskStruct.repeatImage,
										   type:         taskStruct.type.rawValue)
		case .weekRepeatType:
			guard taskStruct.weekDayChoice != [] else { animations.shake(text: infoLabel, duration: 0.4); return }
			coreData.saveWeekDaysRepitionTask(taskTitle:    taskStruct.taskTitle,
											  taskTime:     taskStruct.taskTime!,
											  taskDateDate: taskStruct.taskDateDate!,
											  createdAt:    taskStruct.createdAt,
											  alarmImage:   taskStruct.alarmImage,
											  repeatImage:  taskStruct.repeatImage,
											  type:         taskStruct.type.rawValue,
											  weekDay:      taskStruct.weekDayChoice!)
		case .monthRepeatType:
			guard taskStruct.monthDayChoice != [] else { animations.shake(text: infoLabel, duration: 0.4); return }
			coreData.saveDaysMonthRepitionTask(taskTitle:    taskStruct.taskTitle,
											   taskTime:     taskStruct.taskTime!,
											   taskDateDate: taskStruct.taskDateDate!,
											   createdAt:    taskStruct.createdAt,
											   alarmImage:   taskStruct.alarmImage,
											   repeatImage:  taskStruct.repeatImage,
											   type:         taskStruct.type.rawValue,
											   monthDay:     taskStruct.monthDayChoice!)
		}
		cancelFunc()
		NotificationCenter.default.post(name: Notification.Name("TableViewReloadData"), object: .none)
	}
	
	private func allEnabled() {
		switchAlert.isEnabled          = false
		switchAlertRepeat.isEnabled    = false
		repeatSegmented.isHidden       = true
		dataPicker.isHidden            = true
		switchAlert.isOn               = false
		switchAlertRepeat.isOn         = false
		timePicker.isHidden            = true
		timePickerDWM.isHidden         = true
		buttonStackView.isHidden       = true
		buttonMonthVStackView.isHidden = true
		taskStruct.type                = .justType
		infoLabel.text                 = NSLocalizedString("create your note", comment: "")
		repeatSegmented.selectedSegmentIndex = UISegmentedControl.noSegment
	}
	
	
	//MARK: - Cancel Func
	@objc private func cancelFunc(){
		textField.text                 = nil
		switchAlert.isOn               = false
		switchAlertRepeat.isOn         = false
		timePicker.isHidden            = true
		timePickerDWM.isHidden         = true
		repeatSegmented.isHidden       = true
		repeatSegmented.isSelected     = false
		switchAlertRepeat.isEnabled    = false
		switchAlert.isEnabled          = false
		buttonStackView.isHidden       = true
		buttonMonthVStackView.isHidden = true
		infoLabel.text                 = NSLocalizedString("create your note", comment: "")
		taskStruct.taskTime            = ""
		taskStruct.taskDate            = ""
		taskStruct.taskDateDate        = nil
		taskStruct.timeInterval        = nil
		taskStruct.repeatImage         = false
		taskStruct.alarmImage          = false
		taskStruct.weekDayChoice       = []
		taskStruct.monthDayChoice      = []
		taskStruct.type                = .justType
		repeatSegmented.selectedSegmentIndex = UISegmentedControl.noSegment
		dismiss(animated: true, completion: nil)
	}
	
	
	//MARK: - addSubviewAndConfigure
	private func addSubviewAndConfigure(){
		self.view.backgroundColor = Constants.backgroundColorView
		self.view.addSubview(self.textField)
		self.view.addSubview(self.dataPicker)
		self.view.addSubview(self.switchAlert)
		self.view.addSubview(self.switchAlertRepeat)
		self.view.addSubview(self.alertLabel)
		self.view.addSubview(self.repeatLabel)
		self.view.addSubview(self.repeatSegmented)
		self.view.addSubview(self.timePicker)
		self.view.addSubview(self.timePickerDWM)
		self.view.addSubview(self.infoLabel)
		self.view.addSubview(self.buttonStackView)
		self.view.addSubview(self.buttonMonthVStackView)
	}
	
	
	//MARK: - SetConstraits
	private func setConstraits() {
		textField.translatesAutoresizingMaskIntoConstraints                                                        = false
		textField.widthAnchor.constraint(equalToConstant: 300).isActive                                            = true
		textField.heightAnchor.constraint(equalToConstant: 31).isActive                                            = true
		textField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 70).isActive                        = true
		textField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive                              = true
		
		dataPicker.translatesAutoresizingMaskIntoConstraints                                                       = false
		dataPicker.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive                             = true
		dataPicker.centerYAnchor.constraint(equalTo: self.repeatSegmented.centerYAnchor).isActive                  = true
		
		switchAlert.translatesAutoresizingMaskIntoConstraints                                                      = false
		switchAlert.leadingAnchor.constraint(equalTo: self.alertLabel.trailingAnchor, constant: 10).isActive       = true
		switchAlert.topAnchor.constraint(equalTo: self.textField.bottomAnchor, constant: 100).isActive             = true
		
		switchAlertRepeat.translatesAutoresizingMaskIntoConstraints                                                = false
		switchAlertRepeat.trailingAnchor.constraint(equalTo: self.repeatLabel.leadingAnchor, constant: -10).isActive = true
		switchAlertRepeat.centerYAnchor.constraint(equalTo: self.switchAlert.centerYAnchor).isActive                 = true
		
		alertLabel.translatesAutoresizingMaskIntoConstraints                                                       = false
		alertLabel.heightAnchor.constraint(equalToConstant: 30).isActive                                           = true
		alertLabel.widthAnchor.constraint(equalToConstant: 30).isActive                                            = true
		alertLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 70).isActive = true
		alertLabel.centerYAnchor.constraint(equalTo: self.switchAlert.centerYAnchor).isActive                      = true
		
		repeatLabel.translatesAutoresizingMaskIntoConstraints                                                      = false
		repeatLabel.heightAnchor.constraint(equalToConstant: 30).isActive                                          = true
		repeatLabel.widthAnchor.constraint(equalToConstant: 30).isActive                                           = true
		repeatLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -70).isActive = true
		repeatLabel.centerYAnchor.constraint(equalTo: self.switchAlertRepeat.centerYAnchor).isActive               = true
		
		repeatSegmented.translatesAutoresizingMaskIntoConstraints                                                  = false
		repeatSegmented.heightAnchor.constraint(equalToConstant: 30).isActive                                      = true
		repeatSegmented.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive       = true
		repeatSegmented.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30).isActive          = true
		repeatSegmented.topAnchor.constraint(equalTo: self.alertLabel.bottomAnchor, constant: 40).isActive         = true
		
		timePicker.translatesAutoresizingMaskIntoConstraints                                                       = false
		timePicker.widthAnchor.constraint(equalToConstant: 250).isActive                                           = true
		timePicker.heightAnchor.constraint(equalToConstant: 120).isActive                                          = true
		timePicker.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive                             = true
		timePicker.topAnchor.constraint(equalTo: self.repeatSegmented.bottomAnchor, constant: 10).isActive         = true
		
		timePickerDWM.translatesAutoresizingMaskIntoConstraints                                                    = false
		timePickerDWM.widthAnchor.constraint(equalToConstant: 250).isActive                                        = true
		timePickerDWM.heightAnchor.constraint(equalToConstant: 120).isActive                                       = true
		timePickerDWM.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive                          = true
		timePickerDWM.topAnchor.constraint(equalTo: self.repeatSegmented.bottomAnchor, constant: 10).isActive      = true
		
		buttonStackView.translatesAutoresizingMaskIntoConstraints                                                  = false
		buttonStackView.widthAnchor.constraint(equalToConstant: 350).isActive                                      = true
		buttonStackView.heightAnchor.constraint(equalToConstant: 80).isActive                                      = true
		buttonStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive                        = true
		buttonStackView.topAnchor.constraint(equalTo: self.timePickerDWM.bottomAnchor, constant: 0).isActive       = true
		
		buttonMonthVStackView.translatesAutoresizingMaskIntoConstraints                                            = false
		buttonMonthVStackView.widthAnchor.constraint(equalToConstant: 294).isActive                                = true
		buttonMonthVStackView.heightAnchor.constraint(equalToConstant: 208).isActive                               = true
		buttonMonthVStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive                  = true
		buttonMonthVStackView.topAnchor.constraint(equalTo: self.timePickerDWM.bottomAnchor, constant: 0).isActive = true
		
		infoLabel.translatesAutoresizingMaskIntoConstraints                                                        = false
		infoLabel.widthAnchor.constraint(equalToConstant: 350).isActive                                            = true
		infoLabel.heightAnchor.constraint(equalToConstant: 60).isActive                                            = true
		infoLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive                              = true
		infoLabel.topAnchor.constraint(equalTo: self.textField.bottomAnchor, constant: 15).isActive                = true
	}
}
