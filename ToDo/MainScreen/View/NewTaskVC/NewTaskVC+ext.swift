//
//  NewTaskVC+exst.swift
//  ToDo
//
//  Created by Антон on 24.06.2022.
//

import Foundation
import UIKit

//MARK: - Extension

extension NewTaskVC: UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return 7
	}
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		let result = weekDaysArray[row]
		weekDays = result
		return result
	}
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		let result = weekDaysArray[row]
		weekDays = result
		infoLabel.text = "repeat every \(result) at \(timelabel)"
	}
	
	func tapObserves(){
	let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
		tap.numberOfTapsRequired = 2
		self.zaplatka.addGestureRecognizer(tap)
	}
	
	func zaplatkaSetup() {
		zaplatka.backgroundColor = self.view.backgroundColor
		zaplatka.isHidden = true
		zaplatka.isUserInteractionEnabled = true
	}
	
	@objc func handleTap() {
		print("tap")
	}
	
}
