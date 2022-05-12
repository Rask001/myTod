//
//  LocalNotification.swift
//  ToDo
//
//  Created by Антон on 12.05.2022.
//

import UserNotifications


	func sendReminderNotification(_ title: String, _ body: String, _ date: Date){
		//guard switchAlert.isOn == true else { return }
		let content = UNMutableNotificationContent()
		content.title = body
		content.sound = .default
		content.body = body
		
		
		let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date), repeats: false)
		
		
		let request = UNNotificationRequest(identifier: "id_\(body)", content: content, trigger: trigger)
		UNUserNotificationCenter.current().add(request) { error in
			if error != nil {
				print(error?.localizedDescription as Any)
			}
		}
	}
