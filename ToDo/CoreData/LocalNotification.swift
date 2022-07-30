//
//  LocalNotification.swift
//  ToDo
//
//  Created by Антон on 12.05.2022.
//

import UserNotifications
import Foundation

class LocalNotification {
	static var shared = LocalNotification()
	let content = UNMutableNotificationContent()
	
	func sendReminderNotification(_ title: String, _ body: String, _ taskDateDate: Date) {
		self.content.title = title
		self.content.sound = .default
		self.content.body  = body
		
		let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .weekday, .day, .hour, .minute, .second], from: taskDateDate), repeats: false)
		let request = UNNotificationRequest(identifier: "id_\(body)", content: content, trigger: trigger)
		UNUserNotificationCenter.current().add(request) { error in
			if error != nil {
				print(error?.localizedDescription as Any)
			}
		}
	}
	
	func sendRepeatNotification(_ title: String, _ body: String, _ timeInterval: String?) {
		self.content.title = title
		self.content.sound = .default
		self.content.body  = body
		
		let timeIntStr = (timeInterval! as NSString).integerValue
		let timeIntervalTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeIntStr), repeats: true)
		let request2 = UNNotificationRequest(identifier: "id_\(body)", content: content, trigger: timeIntervalTrigger)
		UNUserNotificationCenter.current().add(request2) { error in
			if error != nil {
				print(error?.localizedDescription as Any)
			}
		}
	}
	
	func sendDaylyReminderNotification(_ title: String, _ body: String, _ taskDateDate: Date) {
		self.content.title = title
		self.content.sound = .default
		self.content.body  = body
		
		let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.hour, .minute, .second], from: taskDateDate), repeats: true)
		let request = UNNotificationRequest(identifier: "id_\(body)", content: content, trigger: trigger)
		UNUserNotificationCenter.current().add(request) { error in
			if error != nil {
				print(error?.localizedDescription as Any)
			}
		}
	}
	
	func convertDate(of dayStr: String, and date: Date) -> Date {
		let dFStrToDate = DateFormatter()
		let components = Calendar.current.dateComponents([.hour, .minute], from: date)
		let componentsForm = DateComponentsFormatter()
		let componentsStr = componentsForm.string(from: components)
		let str = "\(dayStr),\(componentsStr!)"
		dFStrToDate.dateFormat = "E,HH:mm"
		let result = dFStrToDate.date(from: str) ?? dFStrToDate.date(from:"\(dayStr),00:\(componentsStr!)")
		return result!
	}
	
	func sendDaylyReminderWeekDayNotification(_ title: String, _ body: String, _ taskDateDate: Date, _ weekDay: [String]) {
		self.content.title = title
		self.content.sound = .default
		self.content.body  = body
		var num = 0
		let weekDayArray = weekDay
		for i in weekDayArray {
			let dateComponents = convertDate(of: i, and: taskDateDate)
			let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.weekday, .hour, .minute], from: dateComponents), repeats: true)
			let request = UNNotificationRequest(identifier: "id_\(body)-\(num)", content: content, trigger: trigger) //удаление нужно проработать
			UNUserNotificationCenter.current().add(request) { error in
				if error != nil {
					print(error?.localizedDescription as Any)
				}
			}
			num += 1
			print(request)
		}
	}
	
	func deleteLocalNotification(_ title: String) {
		let identifier = ["id_\(title)", "id_\(title)-0", "id_\(title)-1", "id_\(title)-2", "id_\(title)-3", "id_\(title)-4", "id_\(title)-5"]
		UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifier)
		UNUserNotificationCenter.current().getPendingNotificationRequests { array in
//			DispatchQueue.global(qos: .default).async {
//				print(array)
//			}
		}
	}
	
	func deleteAllNotification() {
		UNUserNotificationCenter.current().removeAllDeliveredNotifications()
		UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
	}
	
	
}

//запрос у пользователя на отправку локал нотификейшн
class LocalNotificationRequest {
	static var shared = LocalNotificationRequest()
	func requestAuthorization(notificationCenter: UNUserNotificationCenter) {
		notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
			guard success else { return }
			notificationCenter.getNotificationSettings { (settings) in
				guard settings.authorizationStatus == .authorized else { return }
			}
		}
	}
}
