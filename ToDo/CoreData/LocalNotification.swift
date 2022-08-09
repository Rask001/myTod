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
		let request = UNNotificationRequest(identifier: "id_\(body)0", content: content, trigger: trigger)
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
		let request2 = UNNotificationRequest(identifier: "id_\(body)0", content: content, trigger: timeIntervalTrigger)
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
		let request = UNNotificationRequest(identifier: "id_\(body)0", content: content, trigger: trigger)
		UNUserNotificationCenter.current().add(request) { error in
			if error != nil {
				print(error?.localizedDescription as Any)
			}
		}
	}
	
	func sendDaylyReminderWeekDayNotification(_ title: String, _ body: String, _ taskDateDate: Date, _ weekDay: [String]) {
		self.content.title = title
		self.content.sound = .default
		self.content.body  = body
		var num = 0
		let weekDayArray = weekDay
		for i in weekDayArray {
			let dateComponents = convertDateWeek(of: i, and: taskDateDate)
			let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.weekday, .hour, .minute], from: dateComponents), repeats: true)
			let request = UNNotificationRequest(identifier: "id_\(body)\(num)", content: content, trigger: trigger)
			UNUserNotificationCenter.current().add(request) { error in
				if error != nil {
					print(error?.localizedDescription as Any)
				}
			}
			num += 1
			print(request)
		}
	}
	
	func sendDaylyReminderMonthNotification(_ title: String, _ body: String, _ taskDateDate: Date, _ monthDay: [String]) {
		self.content.title = title
		self.content.sound = .default
		self.content.body  = body
		let calendar = Calendar(identifier: .gregorian)
		let monthRange = calendar.range(of: .day, in: .month, for: Date.now)!
		let daysInMonth = monthRange.count
		
		var num = 0
		let monthDayArray = monthDay
		for i in monthDayArray {
			var item = i
			guard var intager = Int(item) else { return }
			if intager >= daysInMonth {
				intager = daysInMonth
				item = String(intager)
			}
			
			let dateComponents = convertDateMonth(of: item, and: taskDateDate)
			let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.day, .hour, .minute], from: dateComponents), repeats: true)
			let request = UNNotificationRequest(identifier: "id_\(body)\(num)", content: content, trigger: trigger)
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
		var arrayMonth:[String] = []
		for num in 0...31 {
			arrayMonth.append("id_\(title)\(num)")
		}
		UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: arrayMonth)
		UNUserNotificationCenter.current().getPendingNotificationRequests { array in
			DispatchQueue.global(qos: .default).async {
				print(array)
			}
		}
//		UNUserNotificationCenter.current().getDeliveredNotifications { array in
//			DispatchQueue.global(qos: .default).async {
//				print(array)
//			}
//		}
	}
	
	func deleteAllNotification() {
		UNUserNotificationCenter.current().removeAllDeliveredNotifications()
		UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
	}
	
	func convertDateWeek(of dayStr: String, and date: Date) -> Date {
		let dFStrToDate = DateFormatter()
		let components = Calendar.current.dateComponents([.hour, .minute], from: date)
		let componentsForm = DateComponentsFormatter()
		let componentsStr = componentsForm.string(from: components)
		let str = "\(dayStr),\(componentsStr!)"
		dFStrToDate.dateFormat = "E,HH:mm"
		let result = dFStrToDate.date(from: str) ?? dFStrToDate.date(from:"\(dayStr),00:\(componentsStr!)")
		return result!
	}
	
	func convertDateMonth(of dayStr: String, and date: Date) -> Date {
		let dFStrToDate = DateFormatter()
		let components = Calendar.current.dateComponents([.hour, .minute], from: date)
		let componentsForm = DateComponentsFormatter()
		let componentsStr = componentsForm.string(from: components)
		let str = "\(dayStr),\(componentsStr!)"
		dFStrToDate.dateFormat = "d,HH:mm"
		let result = dFStrToDate.date(from: str) ?? dFStrToDate.date(from:"\(dayStr),00:\(componentsStr!)")
		return result!
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
