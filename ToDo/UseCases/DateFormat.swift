//
//  DateFormat.swift
//  ToDo
//
//  Created by Антон on 19.09.2022.
//

import Foundation


class DateFormat {
	class func formatDate(textFormat: String, date: Date) -> String {
		let date = date
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = textFormat
		let result = dateFormatter.string(from: date)
		return result
	}
	
}
