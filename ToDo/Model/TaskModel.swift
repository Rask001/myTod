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
	var taskDateDate  : Date?
	var alarmImage    : Bool = false
	var repeatImage   : Bool = false
	var check         : Bool = false
	var createdAt     : Date?
	var timeInterval  : String? = nil
	
	
	init(taskTitle: String, taskTime: String?, taskDate: String?, taskDateDate: Date?, alarmImage: Bool, repeatImage: Bool, check: Bool, createdAt: Date?, timeInterval: String?) {
		self.taskTitle     = taskTitle
		self.taskTime      = taskTime
		self.taskDate      = taskDate
		self.taskDateDate  = taskDateDate
		self.alarmImage    = alarmImage
		self.repeatImage   = repeatImage
		self.check         = check
		self.createdAt     = createdAt
		self.timeInterval  = timeInterval

	}
	
	static let shared = TaskModel(taskTitle: "",
												 taskTime: nil,
												 taskDate: nil,
												 taskDateDate: nil,
												 alarmImage: false,
												 repeatImage: false,
												 check: false,
												 createdAt: Date.now,
												 timeInterval: nil)
	
}

