//
//  VoiceCell + extension.swift
//  ToDo
//
//  Created by Антон on 12.10.2022.
//

import Foundation
import UIKit

extension VoiceCell {
	
	func makeBackgroundViewCell() -> UIView {
		let view = UIView()
		view.backgroundColor = .white
		return view
	}
	
	func makeBottomBgViewCell() -> UIView {
		let view = UIView()
		view.backgroundColor = .white
		view.layer.cornerRadius = 8
		return view
	}
	
	func makeTextField() -> UITextField {
		let tf = UITextField()
		return tf
	}
	
	func makeTaskTitle() -> UILabel {
		let label = UILabel()
		label.text = "New record 001"
		return label
	}
	
	func makeTaskTime() -> UILabel {
		let label = UILabel()
		return label
	}
	
	func makeTimePlus() -> UILabel {
		let label = UILabel()
		return label
	}
	
	func makeTimeNegative() -> UILabel {
		let label = UILabel()
		return label
	}
	
	func makeTaskDate() -> UILabel {
		let label = UILabel()
		return label
	}
	
	func makeButtonCell() -> UIButton {
		let button = UIButton()
		return button
	}
	
	func makePlayPauseButton() -> UIButton {
		let button = UIButton()
		return button
	}
	
	func makeSlider() -> UISlider {
		let slider = UISlider()
		return slider
	}
	
	func togglePlayback() {
		
	}
	
	func backgroundViewCellShadowLayer() {
		layer.cornerRadius = 5
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowRadius = 4
		layer.shadowOpacity = 0.1
		layer.shadowOffset = CGSize(width: 0, height: 3)
		backgroundViewCell.layer.cornerRadius = 5
		backgroundViewCell.clipsToBounds = true
	}
	
	func animate() {
		UIView.animate(withDuration: 0.5,
									 delay: 0.0,
									 usingSpringWithDamping: 0.8,
									 initialSpringVelocity: 1) { [weak self] in
			self?.backgroundViewCell.layoutIfNeeded()
		}
	}
}


extension VoiceCell {
	
	func addSubviewAndConfigure() {
		backgroundColor = .clear
		contentView.addSubview(backgroundViewCell)
		backgroundViewCell.addSubview(bottomBgViewCell)
		backgroundViewCell.addSubview(textFieldLabel)
		backgroundViewCell.addSubview(taskTitle)
		backgroundViewCell.addSubview(taskTime)
		backgroundViewCell.addSubview(timePlus)
		backgroundViewCell.addSubview(timeNegative)
		backgroundViewCell.addSubview(taskDateLabel)
		backgroundViewCell.addSubview(buttonCell)
		backgroundViewCell.addSubview(playPauseButton)
		bottomBgViewCell.addSubview(slider)
	}

	
	func setConstraintsCell() {
		
		backgroundViewCell.translatesAutoresizingMaskIntoConstraints = false
		backgroundViewCell.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
		backgroundViewCell.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
		backgroundViewCell.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
		backgroundViewCell.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
		
		taskTitle.translatesAutoresizingMaskIntoConstraints = false
		taskTitle.topAnchor.constraint(equalTo: backgroundViewCell.topAnchor).isActive = true
		taskTitle.leadingAnchor.constraint(equalTo: backgroundViewCell.leadingAnchor).isActive = true
		taskTitle.trailingAnchor.constraint(equalTo: backgroundViewCell.trailingAnchor).isActive = true
		taskTitle.heightAnchor.constraint(equalToConstant: 60).isActive = true
		
		bottomBgViewCell.translatesAutoresizingMaskIntoConstraints = false
		bottomBgViewCell.topAnchor.constraint(equalTo: taskTitle.bottomAnchor).isActive = true
		bottomBgViewCell.leadingAnchor.constraint(equalTo: backgroundViewCell.leadingAnchor).isActive = true
		bottomBgViewCell.trailingAnchor.constraint(equalTo: backgroundViewCell.trailingAnchor).isActive = true
	  bottomBgViewCell.heightAnchor.constraint(equalToConstant: 102).isActive = true
		
		slider.translatesAutoresizingMaskIntoConstraints = false
		slider.centerYAnchor.constraint(equalTo: bottomBgViewCell.centerYAnchor).isActive = true
		slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
		slider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
		
	}
}
