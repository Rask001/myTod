//
//  Helper.swift
//  ToDo
//
//  Created by Антон on 11.09.2022.
//

import Foundation


class Helper {
	
	public func createShortIntWithoutStrChar(fromItemsId itemsId: String) -> Int {
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
}
