//
//  NewTask+exst.swift
//  ToDo
//
//  Created by Антон on 24.06.2022.
//

import Foundation
import UIKit

//MARK: - Extension

extension NewTask: UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return 7
	}
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		let result = weekDaysArray[row]
		taskStruct.weekDay = result
		return result
	}
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		let result = weekDaysArray[row]
		taskStruct.weekDay = result
		infoLabel.text = "repeat every \(taskStruct.weekDay!) at \(taskStruct.taskTime ?? "")"
	}
}

extension NewTask: TappedHeavyProtocol {
	func tappedHeavy() {
		tappedFeedBack.tappedHeavy()
	}
}

extension NewTask: TappedSoftProtocol {
	func tappedSoft() {
		tappedFeedBack.tappedSoft()
	}
}

extension NewTask: UITextViewDelegate {
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
}

extension NewTask: NewTaskProtocol {
	
}
