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
			coreDataModel.append(model)
		} catch let error as NSError {
			print(error.localizedDescription)
		}
		guard date != nil else { return }
		sendReminderNotification("Напоминание \(time)", title, date!, repead, timeInterval)
	}
	
	//MARK: - Delete Cell
	public func deleteCell(indexPath: IndexPath, presentedViewController: UIViewController) {
		//tappedRigid()
		let model            = coreDataModel
		let task             = coreDataModel[indexPath.row]
		let taskTitle        = task.taskTitle
		let areYouSureAllert = UIAlertController(title: "Delete '\(taskTitle)'?", message: nil, preferredStyle: .actionSheet)
		let noAction         = UIAlertAction(title: "cancel", style: .cancel)
		let yesAction        = UIAlertAction(title: "Yes, delete '\(taskTitle)'", style: .destructive) { _ in
			self.deleteFromContext(indexPath: indexPath, taskTitle: taskTitle, task: task, model: model)
		}
		areYouSureAllert.addAction(noAction)
		areYouSureAllert.addAction(yesAction)
		presentedViewController.present(areYouSureAllert, animated: true)
	}
	
	private func deleteFromContext(indexPath: IndexPath, taskTitle: String, task: Tasks, model: [Tasks]) {
		var model   = coreDataModel
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["id_\(taskTitle)"])
		context.delete(task as NSManagedObject)
		model.remove(at: indexPath.row)
		let _ : NSError! = nil
		do {
			try context.save()
			MainVC.shared.tableView.deleteRows(at: [indexPath], with: .left)
      NotificationCenter.default.post(name: Notification.Name("TableViewReloadData"), object: .none)
		} catch {
			print("error : \(error)")
		}
	}
	
	//MARK: - Fetch Request
	public func fetchRequest(){
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()
		do{
			coreDataModel = try context.fetch(fetchRequest)
		} catch let error as NSError {
			print(error.localizedDescription)
		}
	}
}
