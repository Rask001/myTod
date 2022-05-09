//
//  CoreData.swift
//  ToDo
//
//  Created by Антон on 08.05.2022.
//
import UIKit
import CoreData

class CoreDataMethods {
	
	//MARK: - SAVE TASK
	func saveTask(withTitle title: String, withTime time: String, withDate date: Date, withCheck check: Bool, withAlarmLabelBuul alarm: Bool, withRepeatLabelBool repead: Bool) {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
		let context = appDelegate.persistentContainer.viewContext
		guard let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: context) else {return}
		let model = Tasks(entity: entity, insertInto: context)
		model.taskTitle     = title
		model.taskTime      = time
		model.timeLabelDate = date
		model.check         = check
		model.alarmImage    = alarm
		model.repeatImage   = repead
		do{
			try context.save()
			MainVC.shared.coreDataModel.append(model)
		} catch let error as NSError {
			print(error.localizedDescription)
		}
	}
	
//	public func deleteCell(indexPath: IndexPath) {
//		//tappedRigid()
//		let task = CoreDataMethods.coreDataModel[indexPath.row]
//		let nameCell = task.taskTitle
//		let areYouSureAllert = UIAlertController(title: "Delete '\(nameCell)'?", message: nil, preferredStyle: .actionSheet)
//		let yesAction = UIAlertAction(title: "Delete", style: .destructive){
//			[self] action in
//		let appDelegate = UIApplication.shared.delegate as! AppDelegate
//		let context = appDelegate.persistentContainer.viewContext
//		let index = indexPath.row
//
//		//UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["id_\(nameCell)"])
//
//			context.delete(CoreDataMethods.coreDataModel[index] as NSManagedObject)
//			CoreDataMethods.coreDataModel.remove(at: index)
//
//		let _ : NSError! = nil
//		do {
//			MainVC.shared.tableView.deleteRows(at: [indexPath], with: .left)
//
//
//			try context.save()
//			MainVC.shared.tableView.reloadData()
//		} catch {
//			print("error : \(error)")
//		}
//	}
//
//		let noAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
//		}
//		areYouSureAllert.addAction(yesAction)
//		areYouSureAllert.addAction(noAction)
//		MainVC.shared.present(areYouSureAllert, animated: true)
//	}
	
}
