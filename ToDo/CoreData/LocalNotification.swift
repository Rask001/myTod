//
//  LocalNotification.swift
//  ToDo
//
//  Created by Антон on 12.05.2022.
//

import UserNotifications
import Foundation

func sendReminderNotification(_ title: String, _ body: String, _ date: Date, _ repeats: Bool, _ timeInterval: String?) {

		let content = UNMutableNotificationContent()
		content.title = body
		content.sound = .default
		content.body = body
		
		
	let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .weekday, .day, .hour, .minute, .second], from: date), repeats: false)

		
	let request = UNNotificationRequest(identifier: "id_\(body)", content: content, trigger: trigger)
		UNUserNotificationCenter.current().add(request) { error in
			if error != nil {
				print(error?.localizedDescription as Any)
			}
		}
	
	
	guard repeats == true else { return }
	
	//let timeIntString = Int(timeInterval!) ?? 0
	let timeIntStr = (timeInterval! as NSString).integerValue
	
	let timeIntervalTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeIntStr), repeats: repeats)
	let request2 = UNNotificationRequest(identifier: "id_\(body)", content: content, trigger: timeIntervalTrigger)
		UNUserNotificationCenter.current().add(request2) { error in
			if error != nil {
				print(error?.localizedDescription as Any)
			}
		}
	}
