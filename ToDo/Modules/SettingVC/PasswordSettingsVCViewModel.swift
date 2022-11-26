//
//  PasswordSettingsVCViewModel.swift
//  ToDo
//
//  Created by Антон on 17.11.2022.
//

import Foundation

protocol PasswordSettingsVCViewModelProtocol {
	
}

final class PasswordSettingsVCViewModel: PasswordSettingsVCViewModelProtocol {
	private weak var output: PasswordSettingsVCOutput?
	
	required init(output: PasswordSettingsVCOutput) {
		self.output = output
	}
	
}
