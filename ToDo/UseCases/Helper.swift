//
//  Helper.swift
//  ToDo
//
//  Created by Антон on 11.09.2022.
//

import Foundation

final class Helper {
	
	enum Errors: Error {
		case emptyString
		case invalidCharacters
	}

	class func createShortIntWithoutStrChar(fromItemsId itemsId: String) throws -> Int {
		
		var resultInt = 0
		var resultString = ""
		guard !itemsId.isEmpty else {
			throw Errors.emptyString
		}
		
		for num in itemsId {
			if resultString.count < 7 {
				if let chr = Int(String(num)) {
					resultString += String(chr)
				}
			}
		}
		
		resultInt = Int(resultString) ?? 0
		guard resultInt != 0 else {
			throw Errors.invalidCharacters
		}
		return resultInt
	}
	
//	class func EnToRuToEn(araay: [String]) -> [String] {
//		let array1 = araay
//		var newArray: [String] = []
//		for day in array1 {
//			switch day {
//			case "sun":
//				newArray.append("вс")
//			case "mon":
//				newArray.append("пн")
//			case "tue":
//				newArray.append("вт")
//			case "wed":
//				newArray.append("ср")
//			case "thu":
//				newArray.append("чт")
//			case "fri":
//				newArray.append("пт")
//			case "sat":
//				newArray.append("сб")
//			case "вс":
//				newArray.append("sun")
//			case "пн":
//				newArray.append("mon")
//			case "вт":
//				newArray.append("tue")
//			case "ср":
//				newArray.append("wed")
//			case "чт":
//				newArray.append("thu")
//			case "пт":
//				newArray.append("fri")
//			case "сб":
//				newArray.append("sat")
//			default:
//				break
//			}
//		}
//		return newArray
//	}
	
	
	class func arrayToStringWeekDay(array: [String]) -> String {
		var string = ""
		var dayWeekDef = array
		//var dayWeek = EnToRuToEn(araay: array)
		var week: [String] = []
		let locale = NSLocale.preferredLanguages.first!
		if locale.hasPrefix("en") {
			week = [NSLocalizedString("sun", comment: ""),
							NSLocalizedString("mon", comment: ""),
						  NSLocalizedString("tue", comment: ""),
						  NSLocalizedString("wed", comment: ""),
						  NSLocalizedString("thu", comment: ""),
						  NSLocalizedString("fri", comment: ""),
						  NSLocalizedString("sat", comment: "")]
		} else if locale.hasPrefix("ru") {
			week = [NSLocalizedString("mon", comment: ""),
							NSLocalizedString("tue", comment: ""),
							NSLocalizedString("wed", comment: ""),
							NSLocalizedString("thu", comment: ""),
							NSLocalizedString("fri", comment: ""),
							NSLocalizedString("sat", comment: ""),
							NSLocalizedString("sun", comment: "")]
		}
		
		//print("dayWeek: \(dayWeek), dayWeekDef: \(dayWeekDef), week: \(week)")
		
		dayWeekDef.sort { week.firstIndex(of: $0)! < week.firstIndex(of: $1)!}
		//dayWeek.sort { week.firstIndex(of: $0)! < week.firstIndex(of: $1)!}
		
		
		for i in dayWeekDef {
			string.append("\(i), ")
		}
		string.remove(at: string.index(before: string.endIndex))
		string.remove(at: string.index(before: string.endIndex))
		return string
	}
}


final class Counter {
	static var count = 0
}

final class CurrentTabBar {
	static var number = 0
}

