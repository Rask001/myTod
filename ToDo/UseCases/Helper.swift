//
//  Helper.swift
//  ToDo
//
//  Created by Антон on 11.09.2022.
//

import Foundation


class Helper {
	
	class func createShortIntWithoutStrChar(fromItemsId itemsId: String) -> Int {
		var resultInt = 0
		var resultString = ""
		for num in itemsId {
			if resultString.count < 7 {
				if let chr = Int(String(num)) {
					resultString += String(chr)
				}
			}
		}
		resultInt = Int(resultString) ?? 777
		return resultInt
	}
	
	class func arrayToStringWeekDay(array: [String]) -> String {
		var string = ""
		let week = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"]
		var dayWeek = array
		dayWeek.sort { week.firstIndex(of: $0)! < week.firstIndex(of: $1)!}
		print (dayWeek)
		for i in dayWeek {
			string.append("\(i), ")
		}
		string.remove(at: string.index(before: string.endIndex))
		string.remove(at: string.index(before: string.endIndex))
		return string
	}
}


class Counter {
	static var count = 0
}
