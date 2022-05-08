//
//  CoreData.swift
//  ToDo
//
//  Created by Антон on 08.05.2022.
//
import UIKit
import CoreData

class CoreDataMethods {
	var coreDataModel = [Tasks]()
	
	//MARK: - SAVE TASK
	func saveTask(withTitle title: String, withTime time: String, withDate date: Date, withCheck check: Bool, withAlarmLabelBuul alarm: Bool, withRepeatLabelBool repead: Bool) {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		guard let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: context) else {return}
		let model = Tasks(entity: entity, insertInto: context)
		model.taskTitle = title
		model.taskTime = time
		model.timeLabelDate = date
		model.check = check
		model.alarmImage = alarm
		model.repeatImage = repead
		do{
			try context.save()
			coreDataModel.append(model)
		} catch let error as NSError {
			print(error.localizedDescription)
		}
	}
}
