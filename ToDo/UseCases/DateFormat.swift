//
//  DateFormat.swift
//  ToDo
//
//  Created by Антон on 19.09.2022.
//

import Foundation


final class DateFormat {
	enum Errors: Error {
		case containsNumberCharecters
	}
	
	class func formatDate(textFormat: String, date: Date) throws -> String {
		let textFormat = textFormat
			let numberCharacters = NSCharacterSet.decimalDigits

		guard textFormat.rangeOfCharacter(from: numberCharacters) == nil else { throw Errors.containsNumberCharecters }
		let date = date
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = textFormat
		let result = dateFormatter.string(from: date)
		return result
	}
}
