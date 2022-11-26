//
//  SettingViewModelProtocol.swift
//  ToDo
//
//  Created by Антон on 11.10.2022.
//

import Foundation
import UIKit

//MARK: - SecondViewModelProtocol
protocol SettingViewModelProtocol {
	func createNavController(view: UIViewController)
	func getSegmentedItems() -> [String]
	func changeLanguage()
	func goToChangePassword()
}
