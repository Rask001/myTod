//
//  DateFormatter.swift
//  ToDo
//
//  Created by Антон on 15.09.2022.
//

import Foundation
import UIKit
final class DateForm {
	func format(data: Date) -> String {
		let dateForm = DateFormatter()
		dateForm.dateFormat = "E, d MMM HH:mm"
		let createdAt = dateForm.string(from: data)
		return createdAt
	}
}

