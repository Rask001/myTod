//
//  SecondVC.swift
//  ToDo
//
//  Created by Антон on 28.08.2022.
//

import UIKit

class SecondVC: UIViewController {
	
	
	//MARK: - Properties
	let viewModel: SecondViewModelProtocol
	init(viewModel: SecondViewModelProtocol) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	//MARK: - liveCycles
    override func viewDidLoad() {
        super.viewDidLoad()
			navigationControllerSetup()
			view.backgroundColor = .backgroundColor
		}
	
	private func navigationControllerSetup() {
		navigationItem.title = "secondVC"
		let textAttributes = [NSAttributedString.Key.font: UIFont.futura20()!, NSAttributedString.Key.foregroundColor: UIColor.blackWhite]
		navigationController?.navigationBar.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
		
	}
	
}
