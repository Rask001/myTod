//
//  NewTaskViewModel.swift
//  ToDo
//
//  Created by Антон on 20.07.2022.
//

import Foundation
import UIKit

protocol NewTaskProtocol: AnyObject {
	func getTaskDateData(_ taskTimeS: String, _ taskDateS: String, _ dayOfMonthS: String, _ taskDateDate: Date)
	func getTaskTimeData(_ taskTimeS: String, _ taskDateDate: Date, _ timeInterval: String)
	
}

protocol NewTaskPresenterProtocol {
	init(view: NewTaskProtocol)
	func dFormatter(dateFromDP: UIDatePicker) -> String
	func tFormatter(paramDataPicker: UIDatePicker) -> (String, String, String)
}

final class NewTaskPresenter: NewTaskPresenterProtocol {
	
	weak var view: NewTaskProtocol?
		
	required init(view: NewTaskProtocol) {
		self.view = view
	}
	
	internal func dFormatter(dateFromDP: UIDatePicker) -> String {
		let dateFromDP                 = dateFromDP.date
		let timeFormatter              = DateFormatter()
		let dateFormatter              = DateFormatter()
		let dateFormatterMonth         = DateFormatter()
		let dayOfMonth                 = DateFormatter()
		timeFormatter.dateFormat       = "HH:mm"
		dateFormatter.dateFormat       = "MMM d"
		dateFormatterMonth.dateFormat  = "EEEE, MMM d"
		dayOfMonth.dateFormat          = "d"
		let taskTimeS                  = timeFormatter.string(from: dateFromDP)
		let taskDateS                  = dateFormatter.string(from: dateFromDP)
		let dayOfMonthS                = dayOfMonth.string(from: dateFromDP)
		let result                     = dateFormatterMonth.string(from: dateFromDP)
	  let taskDateDate               = dateFromDP
		self.view?.getTaskDateData(taskTimeS, taskDateS, dayOfMonthS, taskDateDate)
		return result
	}
	
	internal func tFormatter(paramDataPicker: UIDatePicker) -> (String, String, String) {
		let timeFromDP                  = paramDataPicker.date
		let timeHourFormatter           = DateFormatter()
		let timeMinFormatter            = DateFormatter()
		let timeHourMinFormatter        = DateFormatter()
		timeHourFormatter.dateFormat    = "H"
		timeMinFormatter.dateFormat     = "m"
		timeHourMinFormatter.dateFormat = "HH:mm"
		let timeHRepeatLabel            = timeHourFormatter.string(from: timeFromDP)
		let timeMRepeatLabel            = timeMinFormatter.string(from: timeFromDP)
		let timeHMRepeatLabel           = timeHourMinFormatter.string(from: timeFromDP)
		let timeInterval                = String(((Int(timeHRepeatLabel) ?? 0)*3600) + ((Int(timeMRepeatLabel) ?? 0)*60) )
		let timeHM                      = (timeHRepeatLabel, timeMRepeatLabel, timeHMRepeatLabel)
		self.view?.getTaskTimeData(timeHMRepeatLabel, timeFromDP, timeInterval)
		return timeHM
	}
}
