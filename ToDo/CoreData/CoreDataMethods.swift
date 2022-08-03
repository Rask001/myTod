//
//  CoreData.swift
//  ToDo
//
//  Created by Антон on 08.05.2022.
//
import UIKit
import CoreData

class CoreDataMethods {

	
	var coreDataModel: [Tasks] = []
	//var model: Tasks!
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
		model.taskTitle     = taskTitle
		model.type          = type
		model.taskTime      = taskTime
		model.taskDate      = taskDate
		model.taskDateDate  = taskDateDate
		model.createdAt     = createdAt
		model.alarmImage    = alarmImage
		model.check         = false
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
		model.taskTitle     = taskTitle
		model.type          = type
		model.taskTime      = taskTime
		model.taskDate      = nil
		model.taskDateDate  = taskDateDate
		model.createdAt     = createdAt
		model.alarmImage    = alarmImage
		model.repeatImage   = repeatImage
		model.check         = false
		model.timeInterval  = nil
		do{
			try context.save()
			coreDataModel.append(model)
		} catch let error as NSError {
			print(error.localizedDescription)
		}
		LocalNotification.shared.sendDaylyReminderNotification("Daily repeats", taskTitle, taskDateDate)
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
		model.taskTitle     = taskTitle
		model.type          = type
		model.taskTime      = taskTime
		model.taskDate      = nil
		model.taskDateDate  = taskDateDate
		model.createdAt     = createdAt
		model.alarmImage    = alarmImage
		model.repeatImage   = repeatImage
		model.check         = false
		model.timeInterval  = nil
		do{
			try context.save()
			coreDataModel.append(model)
		} catch let error as NSError {
			print(error.localizedDescription)
		}
		LocalNotification.shared.sendDaylyReminderWeekDayNotification("Week day repeats", taskTitle, taskDateDate, weekDay)
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
		model.taskTitle     = taskTitle
		model.type          = type
		model.taskTime      = taskTime
		model.taskDate      = nil
		model.taskDateDate  = taskDateDate
		model.createdAt     = createdAt
		model.alarmImage    = alarmImage
		model.repeatImage   = repeatImage
		model.check         = false
		model.timeInterval  = nil
		do{
			try context.save()
			coreDataModel.append(model)
		} catch let error as NSError {
			print(error.localizedDescription)
		}
		LocalNotification.shared.sendDaylyReminderMonthNotification("Week day repeats", taskTitle, taskDateDate, monthDay)
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
		model.taskTitle     = taskTitle
		model.type          = type
		model.alarmImage    = alarmImage
		model.repeatImage   = repeatImage
		model.timeInterval  = timeInterval
		model.createdAt     = createdAt
		model.taskTime      = nil
		model.taskDate      = nil
		model.taskDateDate  = nil
		model.check         = false
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
		model.taskTitle     = taskTitle
		model.createdAt     = createdAt
		model.type          = type
		model.taskTime      = nil
		model.taskDate      = nil
		model.taskDateDate  = nil
		model.check         = false
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
	
	//MARK: - Delete Cell
	public func deleteCell(indexPath: IndexPath, presentedViewController: UIViewController) { 
		//tappedRigid()
		let task             = coreDataModel[indexPath.row]
		let taskTitle        = task.taskTitle
		let areYouSureAllert = UIAlertController(title: "Delete \"\(taskTitle)\"?", message: nil, preferredStyle: .actionSheet)
		let noAction         = UIAlertAction(title: "cancel", style: .cancel)
		let yesAction        = UIAlertAction(title: "Yes, delete \"\(taskTitle)\"", style: .destructive) {_ in
			self.deleteFromContext(indexPath: indexPath, taskTitle: taskTitle, task: task)
		}
		areYouSureAllert.addAction(noAction)
		areYouSureAllert.addAction(yesAction)
		presentedViewController.present(areYouSureAllert, animated: true)
	}
	
	private func deleteFromContext(indexPath: IndexPath, taskTitle: String, task: Tasks) {
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		LocalNotification.shared.deleteLocalNotification(taskTitle)
		context.delete(task as NSManagedObject)
		coreDataModel.remove(at: indexPath.row)
		let _ : NSError! = nil
		do {
			try context.save()
      NotificationCenter.default.post(name: Notification.Name("TableViewReloadData"), object: .none)
		} catch {
			print("error : \(error)")
		}
	}
	
	//MARK: - Fetch Request
	public func fetchRequest() {
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()
		do{
			coreDataModel = try context.fetch(fetchRequest)
		} catch let error as NSError {
			print(error.localizedDescription)
		}
	}
}
