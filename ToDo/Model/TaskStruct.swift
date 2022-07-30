//
//  TaskStruct.swift
//  ToDo
//
//  Created by Антон on 08.07.2022.
//

import Foundation

struct TaskStruct {
	
	enum TypeTask: String {
		case justType = "justType"
		case singleAlertType = "singleAlertType"
		case timeRepeatType = "timeRepeatType"
		case dayRepeatType = "dayRepeatType"
		case weekRepeatType = "weekRepeatType"
		case monthRepeatType = "monthRepeatType"
	}
	
	var taskTitle     : String = ""
	var taskTime      : String?
	var taskDate      : String?
	var taskDateDate  : Date?
	var alarmImage    : Bool = false
	var repeatImage   : Bool = false
	var check         : Bool = false
	var createdAt     : Date?
	var timeInterval  : String? = nil
	var weekDay       : String?
	var dayOfMonth    : String?
	var weekDayChoice : [String]? = []
	var type          : TypeTask = .justType
}
