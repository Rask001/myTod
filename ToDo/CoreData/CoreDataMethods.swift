//
//  CoreData.swift
//  ToDo
//
//  Created by Антон on 08.05.2022.
//
import UIKit
import CoreData

final class CoreDataMethods {
	
	
	internal var coreDataModel: [Tasks] = []
	internal var todayTasksArray: [Tasks] = []
	internal var overdueArray: [Tasks] = []
	internal var currentArray: [Tasks] = []
	internal var completedArray: [Tasks] = []
	internal var sectionIndex: Int?
	private var sectionStructCur = SectionStruct(header: "current tasks", row: [])
	private var sectionStructOver = SectionStruct(header: "overdue tasks", row: [])
	private var sectionStructCompleted = SectionStruct(header: "completed tasks", row: [])
	internal var selectionStructArray: [SectionStruct] = []
	//let helper = Helper()
	
	static let shared = CoreDataMethods()
	
	//MARK: - SAVE TASK
	
	func saveAlertTask(taskTitle:    String,
										 taskTime:     String,
										 taskDate:     String,
										 taskDateDate: Date,
										 createdAt:    Date,
										 alarmImage:   Bool,
										 type:         String) {
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		guard let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: context) else {return}
		let model = Tasks(entity: entity, insertInto: context)
		model.id            = UUID().uuidString
		model.taskTitle     = taskTitle
		model.type          = type
		model.taskTime      = taskTime
		model.taskDate      = taskDate
		model.taskDateDate  = taskDateDate
		model.createdAt     = createdAt
		model.alarmImage    = alarmImage
		model.descriptImage = false
		model.check         = false
		model.repeatImage   = false
		model.voiceImage    = false
		model.timeInterval  = nil
		model.descript      = ""
		model.descriptSize  = 20
		model.weekDays      = []
		do{
			try context.save()
			coreDataModel.append(model)
		} catch let error as NSError {
			print(error.localizedDescription)
		}
		
		//fetchRequest()
		LocalNotification.shared.sendReminderNotification("reminder \(taskTime)", taskTitle, taskDateDate)
	}
	
	func saveDailyRepitionTask(taskTitle:    String,
														 taskTime:     String,
														 taskDateDate: Date,
														 createdAt:    Date,
														 alarmImage:   Bool,
														 repeatImage:  Bool,
														 type:         String) {
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		guard let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: context) else {return}
		let model = Tasks(entity: entity, insertInto: context)
		model.id            = UUID().uuidString
		model.taskTitle     = taskTitle
		model.type          = type
		model.taskTime      = taskTime
		model.taskDate      = nil
		model.taskDateDate  = taskDateDate
		model.createdAt     = createdAt
		model.alarmImage    = alarmImage
		model.repeatImage   = repeatImage
		model.descriptImage = false
		model.voiceImage    = false
		model.check         = false
		model.timeInterval  = nil
		model.descript      = ""
		model.descriptSize  = 20
		model.weekDays      = []
		do{
			try context.save()
			coreDataModel.append(model)
		} catch let error as NSError {
			print(error.localizedDescription)
		}
		LocalNotification.shared.sendDaylyReminderNotification("daily reminders", taskTitle, taskDateDate)
	}
	
	func saveWeekDaysRepitionTask(taskTitle:    String,
																taskTime:     String,
																taskDateDate: Date,
																createdAt:    Date,
																alarmImage:   Bool,
																repeatImage:  Bool,
																type:         String,
																weekDay:      [String]) {
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		guard let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: context) else {return}
		let model = Tasks(entity: entity, insertInto: context)
		model.id            = UUID().uuidString
		model.taskTitle     = taskTitle
		model.type          = type
		model.taskTime      = taskTime
		model.taskDate      = nil
		model.taskDateDate  = taskDateDate
		model.createdAt     = createdAt
		model.alarmImage    = alarmImage
		model.repeatImage   = repeatImage
		model.descriptImage = false
		model.voiceImage    = false
		model.check         = false
		model.timeInterval  = nil
		model.descript      = ""
		model.descriptSize  = 20
		model.weekDays      = weekDay
		do{
			try context.save()
			coreDataModel.append(model)
		} catch let error as NSError {
			print(error.localizedDescription)
		}
		LocalNotification.shared.sendDaylyReminderWeekDayNotification("weekly reminders", taskTitle, taskDateDate, weekDay)
	}
	
	func saveDaysMonthRepitionTask(taskTitle:   String,
																 taskTime:     String,
																 taskDateDate: Date,
																 createdAt:    Date,
																 alarmImage:   Bool,
																 repeatImage:  Bool,
																 type:         String,
																 monthDay:     [String]) {
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		guard let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: context) else {return}
		let model = Tasks(entity: entity, insertInto: context)
		model.id            = UUID().uuidString
		model.taskTitle     = taskTitle
		model.type          = type
		model.taskTime      = taskTime
		model.taskDate      = nil
		model.taskDateDate  = taskDateDate
		model.createdAt     = createdAt
		model.alarmImage    = alarmImage
		model.repeatImage   = repeatImage
		model.descriptImage = false
		model.voiceImage    = false
		model.check         = false
		model.timeInterval  = nil
		model.descript      = ""
		model.descriptSize  = 20
		model.weekDays      = []
		do{
			try context.save()
			coreDataModel.append(model)
		} catch let error as NSError {
			print(error.localizedDescription)
		}
		LocalNotification.shared.sendDaylyReminderMonthNotification("monthly reminders", taskTitle, taskDateDate, monthDay)
	}
	
	func saveRepeatTask(taskTitle:    String,
											createdAt:    Date,
											alarmImage:   Bool,
											repeatImage:  Bool,
											timeInterval: String,
											type:         String) {
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		guard let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: context) else {return}
		let model = Tasks(entity: entity, insertInto: context)
		model.id            = UUID().uuidString
		model.taskTitle     = taskTitle
		model.type          = type
		model.alarmImage    = alarmImage
		model.repeatImage   = repeatImage
		model.descriptImage = false
		model.voiceImage    = false
		model.timeInterval  = timeInterval
		model.createdAt     = createdAt
		model.taskTime      = nil
		model.taskDate      = nil
		model.taskDateDate  = nil
		model.check         = false
		model.descript      = ""
		model.descriptSize  = 20
		model.weekDays      = []
		do{
			try context.save()
			coreDataModel.append(model)
		} catch let error as NSError {
			print(error.localizedDescription)
		}
		LocalNotification.shared.sendRepeatNotification("repeat every \(Int(timeInterval)!/60) min", taskTitle, timeInterval)
	}
	
	
	func saveJustTask(taskTitle: String, createdAt: Date, type: String) {
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		guard let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: context) else {return}
		let model = Tasks(entity: entity, insertInto: context)
		model.id            = UUID().uuidString
		model.taskTitle     = taskTitle
		model.createdAt     = createdAt
		model.type          = type
		model.taskTime      = nil
		model.taskDate      = nil
		model.taskDateDate  = nil
		model.check         = false
		model.alarmImage    = false
		model.repeatImage   = false
		model.descriptImage = false
		model.voiceImage    = false
		model.timeInterval  = nil
		model.descript      = ""
		model.descriptSize  = 20
		model.weekDays      = []
		do{
			try context.save()
			coreDataModel.append(model)
		} catch let error as NSError {
			print(error.localizedDescription)
		}
	}
	
	public func saveVoiceImage(tag: Int, isVisible: Bool = true) {
		//CoreDataMethods.shared.fetchRequest()
		
		
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()
		do {
			coreDataModel = try context.fetch(fetchRequest)
		} catch let error as NSError {
			print(error.localizedDescription)
		}
		
		let model = CoreDataMethods.shared.coreDataModel
		for items in model {
			let itemsId = Helper.createShortIntWithoutStrChar(fromItemsId: items.id)
			if tag == itemsId {
				items.voiceImage = true
				items.voiceImage = isVisible
			}
		}
		do {
			try context.save()
			print("save voiceImage")
		} catch let error as NSError {
			print(error.localizedDescription)
		}
		NotificationCenter.default.post(name: Notification.Name("TableViewReloadData"), object: .none)
	}
	
	public func saveDescription(cellTag: Int, description: String, descriptionSize: Double) {
		CoreDataMethods.shared.fetchRequest()        //FIX:
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		let model = CoreDataMethods.shared.coreDataModel
		for items in model {
			let itemsId = Helper.createShortIntWithoutStrChar(fromItemsId: items.id)
			if cellTag == itemsId {
				items.descript = description
				items.descriptSize = descriptionSize
				if description != "" {
					items.descriptImage = true
				} else {
					items.descriptImage = false
				}
			}
		}
		do {
			try context.save()
			print("save description")
			print(descriptionSize)
		} catch let error as NSError {
			print(error.localizedDescription)
		}
		NotificationCenter.default.post(name: Notification.Name("TableViewReloadData"), object: .none)
	}
	
	
	//MARK: - editingCell
	public func editingCell(cellTag: Int, newText: String) {
		CoreDataMethods.shared.fetchRequest()        //FIX:
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		let model = CoreDataMethods.shared.coreDataModel
		for items in model {
			let itemsId = Helper.createShortIntWithoutStrChar(fromItemsId: items.id)
			if cellTag == itemsId {
				items.taskTitle = newText
			}
		}
		do {
			try context.save()
			print("save editing")
		} catch let error as NSError {
			print(error.localizedDescription)
		}
		NotificationCenter.default.post(name: Notification.Name("TableViewReloadData"), object: .none)
	}
	
	//MARK: - Delete Cell
	public func deleteCell(indexPath: IndexPath, presentedViewController: UIViewController, tasksModel: [Tasks]) {
		let task             = tasksModel[indexPath.row]
		let taskTitle        = task.taskTitle
		let areYouSureAllert = UIAlertController(title: "Delete \"\(taskTitle)\"?", message: nil, preferredStyle: .actionSheet)
		let noAction         = UIAlertAction(title: "cancel", style: .cancel)
		let yesAction        = UIAlertAction(title: "Yes, delete \"\(taskTitle)\"", style: .destructive) {_ in
			self.deleteFromContext(indexPath: indexPath, taskTitle: taskTitle, task: task)
			//			let idInt = Helper.createShortIntWithoutStrChar(fromItemsId: task.id)
			//			print(idInt)
			//			FileAdmin.deleteFolder(name: "\(idInt)")
		}
		areYouSureAllert.addAction(noAction)
		areYouSureAllert.addAction(yesAction)
		presentedViewController.present(areYouSureAllert, animated: true)
	}
	
	private func deleteFromContext(indexPath: IndexPath, taskTitle: String, task: Tasks) {
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		LocalNotification.shared.deleteLocalNotification(taskTitle)
		context.delete(task as NSManagedObject)
		
		let idInt = Helper.createShortIntWithoutStrChar(fromItemsId: task.id)
		print(idInt)
		FileAdmin.deleteFolder(name: "\(idInt)")
		
		var index = 0
		for item in currentArray {
			if item.id == task.id {
				currentArray.remove(at: index)
				index += 1
			}
		}
		index = 0
		for item in overdueArray {
			if item.id == task.id {
				overdueArray.remove(at: index)
				index += 1
			}
		}
		index = 0
		for item in completedArray {
			if item.id == task.id {
				completedArray.remove(at: index)
				index += 1
			}
		}
		index = 0
		for item in todayTasksArray {
			if item.id == task.id {
				todayTasksArray.remove(at: index)
				index += 1
			}
		}
		
		let _ : NSError! = nil
		do {
			
			try context.save()
			NotificationCenter.default.post(name: Notification.Name("TableViewReloadData"), object: .none)
		} catch {
			print("error : \(error)")
		}
	}
	
	private func appendTodayTask(coreDataModel array: [Tasks]) -> [Tasks] {
		var arrayResult: [Tasks] = []
		for item in array {
			if let notNil = item.taskDateDate {
				let todayItem = Calendar.current.dateComponents([.day], from: notNil)
				let today = Calendar.current.dateComponents([.day], from: Date.now)
				if todayItem == today, notNil > Date.now {
					arrayResult.append(item)
				}
			}
		}
		return arrayResult
	}
	
	private func appendOverdueTask(coreDataModel array: [Tasks]) -> [Tasks] {
		var arrayResult: [Tasks] = []
		for item in array {
			if let notNil = item.taskDateDate {
				let todayItem = Calendar.current.dateComponents([.day], from: notNil)
				let today = Calendar.current.dateComponents([.day], from: Date.now)
				if todayItem == today, notNil < Date.now {
					arrayResult.append(item)
				}
			}
		}
		return arrayResult
	}
	
	private func appendCurrentTask(coreDataModel array: [Tasks]) -> [Tasks] {
		var arrayResult: [Tasks] = []
		for item in array {
			if item.taskDateDate == nil || item.taskDateDate ?? Date.now > Date.now {
				arrayResult.append(item)
			}
		}
		return arrayResult
	}
	
	private func appendCompletedTask(currentTask: inout [Tasks], todayTask: inout [Tasks], overdueTask: inout [Tasks], coreDataModel: [Tasks]) -> [Tasks] {
		var arrayResult: [Tasks] = []
		for item in coreDataModel {
			if item.check == true {
				arrayResult.append(item)
			}
		}
		
		for item in overdueTask {
			if item.check == true {
				overdueTask.removeAll{ $0.check == true }
			}
		}
		
		for item in currentTask {
			if item.check == true {
				currentTask.removeAll{ $0.check == true }
			}
		}
		
		for item in currentTask {
			if item.check == true {
				todayTask.removeAll{ $0.check == true }
			}
		}
		return arrayResult
	}
	
	
	//MARK: - Fetch Request
	public func fetchRequest() {
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()
		do {
			coreDataModel = try context.fetch(fetchRequest)
			fetchRequestBody(coreDataModel) //вынес чуть ниже чтобы не засорять код
		} catch let error as NSError {
			print(error.localizedDescription)
		}
	}
	
	private func fetchRequestBody(_ coreDataModel: [Tasks]) {
		todayTasksArray = appendTodayTask(coreDataModel: coreDataModel)
		overdueArray = appendOverdueTask(coreDataModel: coreDataModel)
		currentArray = appendCurrentTask(coreDataModel: coreDataModel)
		completedArray = appendCompletedTask(currentTask: &currentArray, todayTask: &todayTasksArray, overdueTask: &overdueArray, coreDataModel: coreDataModel)
		
		var sel: [SectionStruct] = []
		
		let currentEmpty = { self.currentArray.isEmpty }
		let overEmpty = { self.overdueArray.isEmpty }
		let completedEmpty = { self.completedArray.isEmpty }
		
		if currentEmpty(), overEmpty(), completedEmpty() {
			sel = []
			
		} else if currentEmpty(), overEmpty(), !completedEmpty() {
			sel = [sectionStructCompleted]
			sel[0].row = completedArray
			
		} else if currentEmpty(), !overEmpty(), completedEmpty() {
			sel = [sectionStructOver]
			sel[0].row = overdueArray
			
		} else if !currentEmpty(), overEmpty(), completedEmpty() {
			sel = [sectionStructCur]
			sel[0].row = currentArray
			
		} else if currentEmpty(), !overEmpty(), !completedEmpty() {
			sel = [sectionStructOver, sectionStructCompleted]
			sel[0].row = overdueArray
			sel[1].row = completedArray
			
		} else if !currentEmpty(), !overEmpty(), completedEmpty() {
			sel = [sectionStructCur, sectionStructOver]
			sel[0].row = currentArray
			sel[1].row = overdueArray
			
		} else if !currentEmpty(), overEmpty(), !completedEmpty() {
			sel = [sectionStructCur, sectionStructCompleted]
			sel[0].row = currentArray
			sel[1].row = completedArray
			
		} else if !currentEmpty(), !overEmpty(), !completedEmpty() {
			sel = [sectionStructCur, sectionStructOver, sectionStructCompleted]
			sel[0].row = currentArray
			sel[1].row = overdueArray
			sel[2].row = completedArray
		}
		selectionStructArray = sel
	}
}
