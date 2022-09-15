////
////  Cell.swift
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
//
//
//class TaskCell: UITableViewCell {
//	
//	let coreData = CoreDataMethods()
//	//weak var coreData: CoreDataMethods?
//	static let identifier = "identifierCell"
//	
//	
//	//MARK: - ViewModelInit
//	var viewModel: TaskCellProtocol
//	var viewModelAction: TaskCellActionProtocol
//	init(viewModel: TaskCellProtocol, viewModelAction: TaskCellActionProtocol) {
//		self.viewModel = viewModel
//		self.viewModelAction = viewModelAction
//	}
//	
//	required init?(coder: NSCoder) {
//		fatalError("init(coder:) has not been implemented")
//	}
//	
//	var backgroundViewCell: UIView
//	var textFieldLabel: UITextField
//	var taskTitle: UILabel
//	var taskTime: UILabel
//	var taskDate: UILabel
//	var buttonCell: CustomButton
//	var buttonOk: CustomButton
//	var alarmImageView: UIImageView
//	var repeatImageView: UIImageView
//	var taskDateDate: Date
//	var id: String
//	
//	func configure(cell: TaskCellProtocol) {
//		backgroundViewCell = cell.backgroundViewCell
//		textFieldLabel = cell.textFieldLabel
//	  taskTitle = cell.taskTitle
//		taskTime = cell.taskTime
//		taskDate = cell.taskDate
//		buttonCell = cell.buttonCell
//		buttonOk = cell.buttonOk
//		alarmImageView = cell.alarmImageView
//		repeatImageView = cell.repeatImageView
//		taskDateDate = cell.taskDateDate
//		id = cell.id
//	}
//	
//	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//		super.init(style: style, reuseIdentifier: reuseIdentifier)
//		addSubviewAndConfigure()
//		setConstraintsCell()
//	}
//	
//	
//	//MARK: - Functions
//	@objc func longPress(gestureRecognizer: UILongPressGestureRecognizer) {
//		if Counter.count == 0 {
//			TapticFeedback.shared.light
//			self.textFieldLabel.isHidden = false
//			self.textFieldLabel.becomeFirstResponder()
//			self.buttonCell.isEnabled = false
//			self.buttonOk.isHidden = false
//			Counter.count += 1
//		}
//	}
//	
//	@objc func tap() {
//		TapticFeedback.shared.medium
//		let dictionary = ["buttonTag" : buttonCell.tag]
//		NotificationCenter.default.post(name: Notification.Name("tap"), object: nil, userInfo: dictionary)
//	}
//	
//	@objc func completeEdit() {
//		self.endEditing(true)
//		viewModelAction.completeEdit()
//		coreData.editingCell(cellTag: buttonCell.tag, newText: textFieldLabel.text ?? "error CustomCell")
//		Counter.count = 0
//	}
//	
//	private func gestureRecognizerLongTap() {
//		let	gestureLongRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
//		gestureLongRecogniser.minimumPressDuration = 0.6
//		gestureLongRecogniser.delegate = self
//		self.addGestureRecognizer(gestureLongRecogniser)
//
//		//textFieldLabel.addTarget(self, action: #selector(textFieldDidChange), for: .editingDidEndOnExit)
//	}
//	
//	private func gestureRecognizerTap() {
//		let	gestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(tap))
//		gestureRecogniser.delegate = self
//		self.addGestureRecognizer(gestureRecogniser)
//	}
//	
//	
//	func addSubviewAndConfigure() {
//		self.contentView.backgroundColor = .clear
//		self.backgroundColor = .clear
//		self.selectionStyle  = .none
//		self.textFieldLabel.delegate = self
//		self.addSubview(backgroundViewCell)
//		self.backgroundViewCell.addSubview(taskTime)
//		self.backgroundViewCell.addSubview(alarmImageView)
//		self.backgroundViewCell.addSubview(repeatImageView)
//		self.backgroundViewCell.addSubview(buttonCell)
//		self.backgroundViewCell.addSubview(taskTitle)
//		self.backgroundViewCell.addSubview(taskDate)
//		self.backgroundViewCell.addSubview(textFieldLabel)
//		self.backgroundViewCell.addSubview(buttonOk)
//	}
//	
//	func setConstraintsCell() {
//		repeatImageView.translatesAutoresizingMaskIntoConstraints                                                         = false
//		repeatImageView.topAnchor.constraint(equalTo: self.backgroundViewCell.topAnchor, constant: 4).isActive            = true
//		repeatImageView.trailingAnchor.constraint(equalTo: self.alarmImageView.leadingAnchor, constant: -2).isActive      = true
//		repeatImageView.widthAnchor.constraint(equalToConstant: 17).isActive                                              = true
//		repeatImageView.heightAnchor.constraint(equalToConstant: 17).isActive                                             = true
//				 
//		alarmImageView.translatesAutoresizingMaskIntoConstraints                                                          = false
//		alarmImageView.topAnchor.constraint(equalTo: self.backgroundViewCell.topAnchor, constant: 6).isActive             = true
//		alarmImageView.trailingAnchor.constraint(equalTo: self.taskTime.leadingAnchor, constant: -4).isActive             = true
//		alarmImageView.widthAnchor.constraint(equalToConstant: 14).isActive                                               = true
//		alarmImageView.heightAnchor.constraint(equalToConstant: 14).isActive                                              = true
//				 
//		taskTime.translatesAutoresizingMaskIntoConstraints                                                                = false
//		taskTime.topAnchor.constraint(equalTo: self.backgroundViewCell.topAnchor, constant: 1).isActive                   = true
//		taskTime.trailingAnchor.constraint(equalTo: self.backgroundViewCell.trailingAnchor, constant: -3).isActive        = true
//		taskTime.widthAnchor.constraint(equalToConstant: self.frame.width/5).isActive                                     = true
//					 
//		taskDate.translatesAutoresizingMaskIntoConstraints                                                                = false
//		taskDate.topAnchor.constraint(equalTo: self.taskTime.bottomAnchor, constant: 1).isActive                          = true
//		taskDate.trailingAnchor.constraint(equalTo: self.backgroundViewCell.trailingAnchor, constant: -3).isActive        = true
//		taskDate.widthAnchor.constraint(equalToConstant: self.frame.width/5).isActive                                     = true
//			
//		backgroundViewCell.translatesAutoresizingMaskIntoConstraints                                                      = false
//		backgroundViewCell.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: Constants.cellDistance).isActive = true
//		backgroundViewCell.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive                 = true
//		backgroundViewCell.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive                            = true
//		backgroundViewCell.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive                    = true
//					 
//		buttonCell.translatesAutoresizingMaskIntoConstraints                                                              = false
//		buttonCell.centerYAnchor.constraint(equalTo: self.backgroundViewCell.centerYAnchor).isActive                      = true
//		buttonCell.leadingAnchor.constraint(equalTo: self.backgroundViewCell.leadingAnchor, constant: 10).isActive        = true
//		buttonCell.heightAnchor.constraint(equalToConstant: 35).isActive                                                  = true
//		buttonCell.widthAnchor.constraint(equalToConstant: 35).isActive                                                   = true
//		
//		buttonOk.translatesAutoresizingMaskIntoConstraints                                                              = false
//		buttonOk.centerYAnchor.constraint(equalTo: self.backgroundViewCell.centerYAnchor).isActive                      = true
//		buttonOk.trailingAnchor.constraint(equalTo: self.taskTitle.trailingAnchor, constant: 0).isActive        = true
//		buttonOk.heightAnchor.constraint(equalToConstant: 35).isActive                                                  = true
//		buttonOk.widthAnchor.constraint(equalToConstant: 35).isActive                                                   = true
//					 
//		taskTitle.translatesAutoresizingMaskIntoConstraints                                                               = false
//		taskTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive                                          = true
//		taskTitle.leadingAnchor.constraint(equalTo: buttonCell.trailingAnchor, constant: 10).isActive                      = true
//		taskTitle.trailingAnchor.constraint(equalTo: self.repeatImageView.leadingAnchor, constant: -3).isActive           = true
//		
//		textFieldLabel.translatesAutoresizingMaskIntoConstraints                                                          = false
//		textFieldLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive                                     = true
//		textFieldLabel.leadingAnchor.constraint(equalTo: buttonCell.trailingAnchor, constant: 10).isActive                 = true
//		textFieldLabel.trailingAnchor.constraint(equalTo: self.repeatImageView.leadingAnchor, constant: -3).isActive      = true
//	}
//	
//}
//
//
//
//extension TaskCell: UITextFieldDelegate {
//	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//		completeEdit()
//	return true
//	}
//}
//
//
//extension TaskCell: UITextViewDelegate {
//	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//		self.endEditing(true)
//	}
//}
