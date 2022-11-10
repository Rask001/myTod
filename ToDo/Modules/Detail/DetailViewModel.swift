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
	var data: TaskStruct { get }
	var infoAllert: InfoAlert { get }
	func shortInt() -> Int
	func textSizeChange(_ textView: UITextView, _ textFont: String, _ size: Double)
}

class DetailViewModel: DetailViewModelProtocol {
	
	//MARK: - PROPERTY
	let data = localTaskStruct.taskStruct
	let infoAllert = InfoAlert()
	
	//MARK: - ACTIONS
	 func shortInt() -> Int {
		guard let int = try? Helper.createShortIntWithoutStrChar(fromItemsId: data.id) else { return 0 }
		return int
	}
	
	func textSizeChange(_ textView: UITextView, _ textFont: String, _ size: Double) {
		textView.font = UIFont(name: textFont, size: size)
		CoreDataMethods.shared.saveDescription(cellTag: shortInt(), description: textView.text, descriptionSize: size)
	}

	
}
