//
//  CustomCell + ext.swift
//  ToDo
//
//  Created by Антон on 12.10.2022.
//

import Foundation
import UIKit

extension CustomCell {
	
	internal func makeBackgroundViewCell() -> UIView {
		let view = UIView()
		view.backgroundColor = .systemBackground
		view.layer.cornerRadius = 10
		return view
	}
	
	internal func makeTextField() -> UITextField {
		let tf = UITextField()
		tf.isHidden = true
		tf.backgroundColor = .systemYellow
		tf.text = "text filed"
		tf.textAlignment = .left
		tf.adjustsFontSizeToFitWidth = true
		return tf
	}
	
	internal func makeTaskTitle() -> UILabel {
		let label = UILabel()
		label.isHidden = false
		label.backgroundColor = .green
		label.text = "New Task"
		label.textAlignment = .left
		label.adjustsFontSizeToFitWidth = true
		return label
	}
	
	internal func makeTaskTime() -> UILabel {
		let label = UILabel()
		label.backgroundColor = .blue
		label.text = "13:25"
		label.textAlignment = .right
		label.adjustsFontSizeToFitWidth = true
		return label
	}
	
	internal func makeTaskDate() -> UILabel {
		let label = UILabel()
		label.backgroundColor = .orange
		label.text = "every week"
		label.textAlignment = .right
		label.adjustsFontSizeToFitWidth = true
		return label
	}
	
	internal func makeWeekLabel() -> UILabel {
		let label = UILabel()
		label.backgroundColor = .green
		label.text = "sun,mon,tue,wed,thu,fri,sat"
		label.textAlignment = .right
		label.adjustsFontSizeToFitWidth = true
		return label
	}

	internal func makeButtonCell() -> UIButton {
		let button = UIButton()
		button.backgroundColor = .lightGray
		button.layer.cornerRadius = 20
		
		return button
	}
	internal func makeButtonOk() -> UIButton {
		let button = UIButton()
		return button
	}
	
	
	internal func makeAlarmImageView() -> UIImageView {
		let imageView = UIImageView()
		imageView.image = UIImage(systemName: "alarm")?.withTintColor(.label, renderingMode: .alwaysOriginal)
		imageView.contentMode = .scaleAspectFit
		imageView.isHidden = false
		return imageView
	}
	internal func makeRepeatImageView() -> UIImageView {
		let imageView = UIImageView()
		imageView.image = UIImage(systemName: "repeat")?.withTintColor(.label, renderingMode: .alwaysOriginal)
		imageView.contentMode = .scaleAspectFit
		return imageView
	}
	internal func makeDescriptImageView() -> UIImageView {
		let imageView = UIImageView()
		imageView.image = UIImage(systemName: "square.text.square")?.withTintColor(.label, renderingMode: .alwaysOriginal)
		imageView.isHidden = false
		imageView.contentMode = .scaleAspectFit
		return imageView
	}
	internal func makeVoiceImageView() -> UIImageView {
		let imageView = UIImageView()
		imageView.image = UIImage(systemName: "mic")?.withTintColor(.label, renderingMode: .alwaysOriginal)
		imageView.contentMode = .scaleAspectFit
		return imageView
	}
	
	//MARK: - Actions
	func gestureRecognizerTap() {
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
		self.addGestureRecognizer(tapGesture)
		tapGesture.delegate = self
	}
	
	func gestureRecognizerLongTap() {
		let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
		tapGesture.minimumPressDuration = 0.8
		self.addGestureRecognizer(tapGesture)
		tapGesture.delegate = self
	}
	
	@objc func tap() {
		let buttonTag = ["buttonTag": buttonCell.tag]
		NotificationCenter.default.post(name: Notification.Name("tap"), object: nil, userInfo: buttonTag)
	}
	
	@objc func longTap() {
		
	}
	
	internal func createStackView() -> UIStackView {
		let stackView = UIStackView(arrangedSubviews: [voiceImageView, descriptImageView, repeatImageView, alarmImageView])
		stackView.axis = .horizontal
		stackView.backgroundColor = .red
		stackView.distribution = .fillEqually
		return stackView
	}
	
	
	//MARK: - addSubviewAndConfigure
	func addSubviewAndConfigure() {
		self.backgroundColor = .clear
		self.addSubview(backgroundViewCell)
		self.backgroundViewCell.addSubview(self.stackViewImage)
		self.backgroundViewCell.addSubview(self.textFieldLabel)
		self.backgroundViewCell.addSubview(self.taskTitle)
		self.backgroundViewCell.addSubview(self.taskTime)
		self.backgroundViewCell.addSubview(self.taskDate)
		self.backgroundViewCell.addSubview(self.weekLabel)
		self.backgroundViewCell.addSubview(self.buttonCell)
		self.backgroundViewCell.addSubview(self.buttonOk)
	}

	//MARK: - setConstraints
	func setConstraintsCell() {
		backgroundViewCell.translatesAutoresizingMaskIntoConstraints = false
		backgroundViewCell.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
		backgroundViewCell.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
		backgroundViewCell.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
		
		taskTime.translatesAutoresizingMaskIntoConstraints = false
		taskTime.topAnchor.constraint(equalTo: self.backgroundViewCell.topAnchor, constant: 3).isActive = true
		taskTime.heightAnchor.constraint(equalToConstant: 18).isActive = true
		taskTime.widthAnchor.constraint(equalToConstant: 60).isActive = true
		taskTime.trailingAnchor.constraint(equalTo: self.backgroundViewCell.trailingAnchor, constant: -4).isActive = true
		
		stackViewImage.translatesAutoresizingMaskIntoConstraints = false
		stackViewImage.topAnchor.constraint(equalTo: backgroundViewCell.topAnchor, constant: 4).isActive = true
		stackViewImage.trailingAnchor.constraint(equalTo: self.taskTime.leadingAnchor).isActive = true
		stackViewImage.heightAnchor.constraint(equalToConstant: 18).isActive = true
		stackViewImage.widthAnchor.constraint(lessThanOrEqualToConstant: 80).isActive = true
		
		buttonCell.translatesAutoresizingMaskIntoConstraints = false
		buttonCell.leadingAnchor.constraint(equalTo: self.backgroundViewCell.leadingAnchor, constant: 10).isActive = true
		buttonCell.topAnchor.constraint(equalTo: self.backgroundViewCell.topAnchor, constant: 10).isActive = true
		buttonCell.bottomAnchor.constraint(equalTo: self.backgroundViewCell.bottomAnchor, constant: -10).isActive = true
		buttonCell.widthAnchor.constraint(equalToConstant: 40).isActive = true
		
		taskTitle.translatesAutoresizingMaskIntoConstraints = false
		taskTitle.leadingAnchor.constraint(equalTo: self.buttonCell.trailingAnchor, constant: 10).isActive = true
		taskTitle.topAnchor.constraint(equalTo: self.backgroundViewCell.topAnchor, constant: 10).isActive = true
		taskTitle.bottomAnchor.constraint(equalTo: self.backgroundViewCell.bottomAnchor, constant: -10).isActive = true
		taskTitle.trailingAnchor.constraint(equalTo: self.stackViewImage.leadingAnchor, constant: 0).isActive = true
		
		textFieldLabel.translatesAutoresizingMaskIntoConstraints = false
		textFieldLabel.leadingAnchor.constraint(equalTo: self.buttonCell.trailingAnchor, constant: 10).isActive = true
		textFieldLabel.topAnchor.constraint(equalTo: self.backgroundViewCell.topAnchor, constant: 10).isActive = true
		textFieldLabel.bottomAnchor.constraint(equalTo: self.backgroundViewCell.bottomAnchor, constant: -10).isActive = true
		textFieldLabel.trailingAnchor.constraint(equalTo: self.stackViewImage.leadingAnchor, constant: 0).isActive = true
		
		taskDate.translatesAutoresizingMaskIntoConstraints = false
		taskDate.topAnchor.constraint(equalTo: self.taskTime.bottomAnchor, constant: 0).isActive = true
		taskDate.heightAnchor.constraint(equalToConstant: 18).isActive = true
		taskDate.trailingAnchor.constraint(equalTo: self.backgroundViewCell.trailingAnchor, constant: -4).isActive = true
		
		weekLabel.translatesAutoresizingMaskIntoConstraints = false
		weekLabel.topAnchor.constraint(equalTo: self.taskDate.bottomAnchor, constant: 0).isActive = true
		weekLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
		weekLabel.trailingAnchor.constraint(equalTo: self.backgroundViewCell.trailingAnchor, constant: -4).isActive = true
		weekLabel.leadingAnchor.constraint(equalTo: taskTitle.trailingAnchor).isActive = true
		
	}
}
