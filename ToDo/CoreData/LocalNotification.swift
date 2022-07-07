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
