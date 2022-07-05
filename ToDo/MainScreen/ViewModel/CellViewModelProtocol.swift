//
//  CellViewModelProtocol.swift
//  ToDoRewrite
//
//  Created by Антон on 08.05.2022.
//

import Foundation

protocol CellViewModelProtocol {
	
	var taskTitle     : String { get }
	var taskTime      : String? { get }
	var alarmImage    : Bool { get }
	var repeatImage   : Bool { get }
	var timeLabelDate : Date? { get }
	var check         : Bool { get }
	var createdAt     : Date? { get }
	var timeInterval  : String? { get }
	
}
