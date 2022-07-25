//
//  CodeLayout.swift
//  ToDo
//
//  Created by Антон on 24.06.2022.
//

import Foundation

//MARK: - Extension Layout
extension NewTask {
	
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
		self.view.addSubview(self.setTimePicker2)
		self.view.addSubview(self.infoLabel)
		self.view.addSubview(self.setWeekDay)
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
		self.switchAlert.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50).isActive         = true
		self.switchAlert.centerYAnchor.constraint(equalTo: self.dataPicker.centerYAnchor).isActive                 = true
		
		self.switchAlertRepeat.translatesAutoresizingMaskIntoConstraints                                           = false
		self.switchAlertRepeat.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50).isActive   = true
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
		self.repeatSegmented.widthAnchor.constraint(equalToConstant: 240).isActive                                 = true
		self.repeatSegmented.heightAnchor.constraint(equalToConstant: 30).isActive                                 = true
		self.repeatSegmented.centerYAnchor.constraint(equalTo: self.repeatLabel.centerYAnchor).isActive            = true
		self.repeatSegmented.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive  = true
		
		self.setTimePicker.translatesAutoresizingMaskIntoConstraints                                               = false
		self.setTimePicker.widthAnchor.constraint(equalToConstant: 250).isActive                                   = true
		self.setTimePicker.heightAnchor.constraint(equalToConstant: 120).isActive                                  = true
		self.setTimePicker.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive                     = true
		self.setTimePicker.topAnchor.constraint(equalTo: self.repeatSegmented.bottomAnchor, constant: 10).isActive = true
		
		self.setTimePicker2.translatesAutoresizingMaskIntoConstraints                                               = false
		self.setTimePicker2.widthAnchor.constraint(equalToConstant: 250).isActive                                   = true
		self.setTimePicker2.heightAnchor.constraint(equalToConstant: 120).isActive                                  = true
		self.setTimePicker2.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive                     = true
		self.setTimePicker2.topAnchor.constraint(equalTo: self.repeatSegmented.bottomAnchor, constant: 10).isActive = true
		
		self.setWeekDay.translatesAutoresizingMaskIntoConstraints                                                  = false
		self.setWeekDay.widthAnchor.constraint(equalToConstant: 250).isActive                                      = true
		self.setWeekDay.heightAnchor.constraint(equalToConstant: 120).isActive                                     = true
		self.setWeekDay.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive                        = true
		self.setWeekDay.topAnchor.constraint(equalTo: self.repeatSegmented.bottomAnchor, constant: 10).isActive    = true
		
		self.infoLabel.translatesAutoresizingMaskIntoConstraints                                                   = false
		self.infoLabel.widthAnchor.constraint(equalToConstant: 300).isActive                                       = true
		self.infoLabel.heightAnchor.constraint(equalToConstant: 60).isActive                                       = true
		self.infoLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive                         = true
		self.infoLabel.topAnchor.constraint(equalTo: self.textField.bottomAnchor, constant: 20).isActive           = true
	}
}
