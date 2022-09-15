//
//  MainIO.swift
//  ToDo
//
//  Created by Антон on 20.07.2022.
//

import Foundation

protocol MainOutput: AnyObject {
	func goToNewTask()
	func goToDetail()
}

protocol MainInput: AnyObject { }
