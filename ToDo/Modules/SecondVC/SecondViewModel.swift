//
//  SecondViewModel.swift
//  ToDo
//
//  Created by Антон on 28.08.2022.
//

import Foundation


//MARK: - SecondViewModelProtocol

protocol SecondViewModelProtocol {

}

//MARK: - SecondViewModel

class SecondViewModel {
	private weak var output: SecondVCOutput?
	weak var view: SecondVC?
	init(output: SecondVCOutput) {
		self.output = output
	}
}

extension SecondViewModel: SecondViewModelProtocol {
	
}
