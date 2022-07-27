//
//  fabric.swift
//  ToDo
//
//  Created by Антон on 12.07.2022.
//

//import Foundation
//
//enum taskType {
//	case just, alert, repeated
//}
//
//class FactoryTasks {
//	static let shared = FactoryTasks()
//	
//	func create(type: taskType) -> MainTasksProtocol {
//
//		switch type {
//		case .just:
//			return createTask(type: type) as! JustTaskProtocol
//		case .alert:
//			return createTask(type: type) as! AlertTaskProtocol
//		case .repeated:
//			return createTask(type: type) as! RepeatTaskProtocol
//		}
//	}
//	func createTask(type: taskType) -> AnyClass {
//		switch type {
//		case .just:
//			createJust()
//		case .alert:
//			createAlert()
//		case .repeated:
//			createRepeat()
//		}
//	}
//}



//protocol AbstractTaskFactory {
//
//	func createJust() -> JustTaskProtocol
//
//	func createAlert() -> AlertTaskProtocol
//
//	func createRepeat() -> RepeatTaskProtocol
//
//	}
//
//func createJust() -> JustTask {
//
//	print("класс создан")
//	return JustTask()
//}
