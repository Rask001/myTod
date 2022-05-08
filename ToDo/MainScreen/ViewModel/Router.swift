//
//  Router.swift
//  ToDo
//
//  Created by Антон on 08.05.2022.
//

import Foundation
import UIKit

class Router {
	static let shared = Router()
	
	//модальная презентация контролера
	func present(currentVC: UIViewController, presentedVC: UIViewController){
		currentVC.present(presentedVC, animated: true, completion: nil)
		}
	
}
