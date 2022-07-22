//
//  File.swift
//  ToDo
//
//  Created by Антон on 12.07.2022.
//

import Foundation
import CoreData
import UIKit

protocol AlertTaskProtocol: MainTasksProtocol {
	
	var isItOverdue  : Bool { get }
	var taskTime     : String { get }
	var taskDate     : String { get }
	var taskDateDate : Date { get }
	var alarmImage   : Bool { get }
	
}

class AlertTask: AlertTaskProtocol {
	func isItCompleted() {
	}
	
	
	var coreDataModel: [Tasks] = []
	var model = TaskStruct()
	
	var taskTitle   : String
	var taskTime    : String
	var taskDate    : String
	var taskDateDate: Date
	var alarmImage  : Bool
	var createdAt   : Date
	var check       : Bool
	var isItOverdue : Bool
	
	init(taskTitle: String,
			 taskTime: String,
			 taskDate: String,
			 taskDateDate: Date,
			 alarmImage: Bool,
			 createdAt: Date,
			 check: Bool,
			 isItOverdue: Bool) {
		self.taskTitle    = taskTitle
		self.taskTime     = taskTime
		self.taskDate     = taskDate
		self.taskDateDate = taskDateDate
		self.alarmImage   = alarmImage
		self.createdAt    = createdAt
		self.check        = check
		self.isItOverdue  = isItOverdue
	}
	
	
	func saveAlertTask(taskTitle:    String,
										 taskTime:     String,
										 taskDate:     String,
										 taskDateDate: Date,
										 createdAt:    Date,
										 check:        Bool,
										 alarmImage:   Bool,
										 repeatImage:  Bool,
										 timeInterval: String) {
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		guard let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: context) else {return}
		let model = Tasks(entity: entity, insertInto: context)
		model.taskTitle     = taskTitle
		model.taskTime      = taskTime
		model.taskDate      = taskDate
		model.taskDateDate  = taskDateDate
		model.createdAt     = createdAt
		model.check         = check
		model.alarmImage    = alarmImage
		model.repeatImage   = false
		model.timeInterval  = nil
		do{
			try context.save()
			coreDataModel.append(model)
		} catch let error as NSError {
			print(error.localizedDescription)
		}
		LocalNotification.shared.sendReminderNotification("reminder \(taskTime)", taskTitle, taskDateDate)
	}
	
	
	func saveRepeatTask(taskTitle:    String,
											taskTime:     String,
											taskDate:     String,
											taskDateDate: Date,
											createdAt:    Date,
											check:        Bool,
											alarmImage:   Bool,
											repeatImage:  Bool,
											timeInterval: String) {
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		guard let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: context) else {return}
		let model = Tasks(entity: entity, insertInto: context)
		model.taskTitle     = taskTitle
		model.taskTime      = nil
		model.taskDate      = nil
		model.taskDateDate  = nil
		model.createdAt     = createdAt
		model.check         = check
		model.alarmImage    = alarmImage
		model.repeatImage   = repeatImage
		model.timeInterval  = timeInterval
		do{
			try context.save()
			coreDataModel.append(model)
		} catch let error as NSError {
			print(error.localizedDescription)
		}
		LocalNotification.shared.sendRepeatNotification("repeat every \(Int(timeInterval)!/60) min", taskTitle, timeInterval)
	}
	
	
	func saveJustTask(taskTitle:    String,
										taskTime:     String,
										taskDate:     String,
										taskDateDate: Date,
										createdAt:    Date,
										check:        Bool,
										alarmImage:   Bool,
										repeatImage:  Bool,
										timeInterval: String) {
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		guard let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: context) else {return}
		let model = Tasks(entity: entity, insertInto: context)
		model.taskTitle     = taskTitle
		model.taskTime      = nil
		model.taskDate      = nil
		model.taskDateDate  = nil
		model.createdAt     = createdAt
		model.check         = check
		model.alarmImage    = false
		model.repeatImage   = false
		model.timeInterval  = nil
		do{
			try context.save()
			coreDataModel.append(model)
		} catch let error as NSError {
			print(error.localizedDescription)
		}
	}
	
}

