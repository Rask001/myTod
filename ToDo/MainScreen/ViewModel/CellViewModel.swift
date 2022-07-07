//
//  TaskViewModel.swift
//  ToDo
//
//  Created by Антон on 03.07.2022.
//

import Foundation

class CellViewModel: NSObject, CellViewModelProtocol {
	
	
	let taskModel: TaskModel
	var taskTitle: String
	var taskTime: String?
	var alarmImage: Bool
	var repeatImage: Bool
	var check: Bool
	var createdAt: Date?
	var timeInterval: String?
	
	init(with taskModel: TaskModel) {
		self.taskModel = taskModel
		
		self.taskTitle = taskModel.taskTitle
		self.taskTime = taskModel.taskTime
		self.alarmImage = taskModel.alarmImage
		self.repeatImage = taskModel.repeatImage
		self.check = taskModel.check
		self.createdAt = taskModel.createdAt
		self.timeInterval = taskModel.timeInterval
		
	}
	
}
