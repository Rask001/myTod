//
//  DateFormatTest.swift
//  ToDoTests
//
//  Created by Антон on 05.10.2022.
//

import XCTest
@testable import ToDo

final class DateFormatTests: XCTestCase {
	
	func testWhenDateFormatContainsNumberCharecters() {
		let input = "hh: MM4"
		let date = Date.now
		XCTAssertThrowsError(try DateFormat.formatDate(textFormat: input, date: date), "Должна быть полученна ошибка '.containsNumberCharecters'") { error in
			XCTAssertEqual(error as? DateFormat.Errors, .containsNumberCharecters)
		}
	}
}
