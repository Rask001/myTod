//
//  CustomCellViewModel.swift
//  ToDo
//
//  Created by Антон on 09.07.2022.
//

import Foundation


class CustomCellViewModel {
	
	var taskTitle     : String!
	var taskTime      : String!
	var taskDate      : String!
	var taskDateDate  : Date!
	var alarmImage    : Bool!
	var repeatImage   : Bool!
	var check         : Bool!
	var createdAt     : Date!
	var timeInterval  : String!
	
	required init (taskModel: TaskModel) {
		self.taskTitle     = taskModel.taskTitle
		self.taskTime      = taskModel.taskTime
		self.taskDate      = taskModel.taskDate
		self.taskDateDate  = taskModel.taskDateDate
		self.alarmImage    = taskModel.alarmImage
		self.repeatImage   = taskModel.repeatImage
		self.check         = taskModel.check
		self.createdAt     = taskModel.createdAt
		self.timeInterval  = taskModel.timeInterval
	}
}
