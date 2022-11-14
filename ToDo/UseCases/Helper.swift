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
		case emptyArray
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
	
	class func arrayToStringWeekDay(array: [String]) throws -> String {
		var string = ""
		var dayWeekDef = array
		guard !array.isEmpty else { throw Errors.emptyArray}
		var week: [String] = []
		let locale = NSLocale.preferredLanguages.first!
		if locale.hasPrefix("ru") {
			week = [NSLocalizedString("mon", comment: ""),
							NSLocalizedString("tue", comment: ""),
							NSLocalizedString("wed", comment: ""),
							NSLocalizedString("thu", comment: ""),
							NSLocalizedString("fri", comment: ""),
							NSLocalizedString("sat", comment: ""),
							NSLocalizedString("sun", comment: "")]
		
		} else {
			week = [NSLocalizedString("sun", comment: ""),
							NSLocalizedString("mon", comment: ""),
							NSLocalizedString("tue", comment: ""),
							NSLocalizedString("wed", comment: ""),
							NSLocalizedString("thu", comment: ""),
							NSLocalizedString("fri", comment: ""),
							NSLocalizedString("sat", comment: "")]
		}
		
		//print("dayWeek: \(dayWeek), dayWeekDef: \(dayWeekDef), week: \(week)")
		
		dayWeekDef.sort { week.firstIndex(of: $0)! < week.firstIndex(of: $1)!}  //FIX
		
		
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

