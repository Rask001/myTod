//
//  NewTaskViewModel.swift
//  ToDo
//
//  Created by Антон on 20.07.2022.
//

import Foundation

protocol NewTaskViewModelProtocol {
	func createTask()
	func cancelTask()
}

class NewTaskViewModel {
	weak var view: NewTaskProtocol?
	private weak var output: NewTaskOutput?
	init(output: NewTaskOutput) {
		self.output = output
	}
}

extension NewTaskViewModel: NewTaskViewModelProtocol {
	func createTask() {
		//
	}
	
	func cancelTask() {
		//
	}
	

}
