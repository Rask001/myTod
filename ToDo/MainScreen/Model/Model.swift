//
//  Model.swift
//  ToDoRewrite
//
//  Created by Антон on 06.05.2022.
//
import UIKit
import Foundation

class Model {
	let taskTitle     : String
	let taskTime      : String?
	let alarmImage    : Bool
	let repeatImage   : Bool
	let timeLabelDate : Date?
	let check         : Bool
	let createdAt     : Date?
	
	init(taskTitle: String, taskTime: String?, alarmImage: Bool, repeatImage: Bool, timeLabelDate: Date?, check: Bool, createdAt: Date?) {
		self.taskTitle     = taskTitle
		self.taskTime      = taskTime
		self.alarmImage    = alarmImage
		self.repeatImage   = repeatImage
		self.timeLabelDate = timeLabelDate
		self.check         = check
		self.createdAt     = createdAt
	}
	
}
