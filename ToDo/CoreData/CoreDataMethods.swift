//
//  CoreData.swift
//  ToDo
//
//  Created by Антон on 08.05.2022.
//
import UIKit
import CoreData

class CoreDataMethods {
	static let shared = CoreDataMethods()
	//MARK: - SAVE TASK
	func saveTask(withTitle title: String, withTimeLabel time: String, withDateLabel dateLabel: String, withDate date: Date?, withCheck check: Bool, withAlarmLabelBuul alarm: Bool, withRepeatLabelBool repead: Bool, withTimeInterval timeInterval: String?) {
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		guard let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: context) else {return}
		let model = Tasks(entity: entity, insertInto: context)
		model.taskTitle     = title
		model.taskTime      = time
		model.taskDate      = dateLabel
		model.timeLabelDate = date
		model.check         = check
		model.alarmImage    = alarm
		model.repeatImage   = repead
		model.timeInterval  = timeInterval
		do{
			try context.save()
			MainVC.shared.coreDataModel.append(model)
		} catch let error as NSError {
			print(error.localizedDescription)
		}
		guard date != nil else { return }
		sendReminderNotification("Напоминание \(time)", title, date!, repead, timeInterval)
	}
	
	public func deleteCell(indexPath: IndexPath, presentedViewController: UIViewController) {
		//tappedRigid()
		MainVC.shared.fetchRequest()
		var model            = MainVC.shared.coreDataModel
		let task             = MainVC.shared.coreDataModel[indexPath.row]
		let taskTitle        = task.taskTitle
		let areYouSureAllert = UIAlertController(title: "Delete '\(taskTitle)'?", message: nil, preferredStyle: .actionSheet)
		let noAction         = UIAlertAction(title: "Cancel", style: .cancel)
		let yesAction        = UIAlertAction(title: "Delete", style: .destructive){ action in
		let context          = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		
			
			UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["id_\(taskTitle)"])
																																					 
			context.delete(task as NSManagedObject)
			model.remove(at: indexPath.row)
			
			let _ : NSError! = nil
			do {
				print(indexPath.row)
				//MainVC.shared.tableView.deleteRows(at: [indexPath], with: .left)
				try context.save()
				NotificationCenter.default.post(name: Notification.Name("Reload"), object: .none)
			} catch {
				print("error : \(error)")
			}
		}
		areYouSureAllert.addAction(yesAction)
		areYouSureAllert.addAction(noAction)
		presentedViewController.present(areYouSureAllert, animated: true)
	}
}
