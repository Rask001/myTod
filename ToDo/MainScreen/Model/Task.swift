//
//  TaskModel.swift
//  ToDo
//
//  Created by Антон on 27.03.2022.
//

import Foundation

struct Task {
	let textTask: String
	let timeLabel: String?
	let timeLabelDate: Date?
	let createdAt: Date?
	let completed: Bool = false
	let alarmLabel: Bool = false
	let repeatLabel: Bool = false
	
	init(textTask: String, timeLabel: String?, timeLabelDate: Date?, createdAt: Date?) {
		self.textTask = textTask
		self.timeLabel = timeLabel
		self.timeLabelDate = timeLabelDate
		self.createdAt = createdAt
	}
	
}
