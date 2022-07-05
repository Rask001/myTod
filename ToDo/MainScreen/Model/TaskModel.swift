//
//  Model.swift
//  ToDoRewrite
//
//  Created by Антон on 06.05.2022.
//

import Foundation

class TaskModel: NSObject {
	
	var taskTitle     : String
	var taskTime      : String?
	var taskDate      : String?
	var alarmImage    : Bool
	var repeatImage   : Bool
	var timeLabelDate : Date?
	var check         : Bool = false
	var createdAt     : Date?
	var timeInterval  : String?
	
	
	init(taskTitle: String, taskTime: String?, taskDate: String?, alarmImage: Bool, repeatImage: Bool, timeLabelDate: Date?, check: Bool, createdAt: Date?, timeInterval: String?) {
		self.taskTitle     = taskTitle
		self.taskTime      = taskTime
		self.taskDate      = taskDate
		self.alarmImage    = alarmImage
		self.repeatImage   = repeatImage
		self.timeLabelDate = timeLabelDate
		self.check         = check
		self.createdAt     = createdAt
		self.timeInterval  = timeInterval

	}
	
	static let shared = TaskModel(taskTitle: "",
												 taskTime: nil,
												 taskDate: nil,
												 alarmImage: false,
												 repeatImage: false,
												 timeLabelDate: nil,
												 check: false,
												 createdAt: nil,
												 timeInterval: nil)
	
}

