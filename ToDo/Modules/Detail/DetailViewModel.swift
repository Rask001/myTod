//
//  DetailViewModel.swift
//  ToDo
//
//  Created by Антон on 12.10.2022.
//

import Foundation
import UIKit
//MARK: - PROTOCOL
protocol DetailViewModelProtocol {
	var data: TaskStruct! { get }
	var infoAlert: InfoAlert! { get }
	func shortInt() -> Int
	func textSizeChange(_ textView: UITextView, _ textFont: String, _ size: Double)
	func saveDescription(description: String, descriptionSize: Double, view: UIView?)
}

class DetailViewModel: DetailViewModelProtocol {

	//MARK: - PROPERTY
	let data: TaskStruct!
	let infoAlert: InfoAlert!
	
	required init(data: TaskStruct, infoAlert: InfoAlert) {
		self.data = data
		self.infoAlert = infoAlert
	}
	
	//MARK: - ACTIONS
	 func shortInt() -> Int {
		guard let int = try? Helper.createShortIntWithoutStrChar(fromItemsId: data.id) else { return 0 }
		return int
	}
	
	func textSizeChange(_ textView: UITextView, _ textFont: String, _ size: Double) {
		textView.font = UIFont(name: textFont, size: size)
		saveDescription(description: textView.text, descriptionSize: size, view: nil)
	}
	
	func saveDescription(description: String, descriptionSize: Double, view: UIView?) {
		CoreDataMethods.shared.saveDescription(cellTag: shortInt(), description: description, descriptionSize: descriptionSize)
		view?.endEditing(true)
	}
}
