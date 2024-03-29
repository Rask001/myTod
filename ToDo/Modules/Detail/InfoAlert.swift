//
//  InfoAlert.swift
//  ToDo
//
//  Created by Антон on 25.09.2022.
//

import Foundation
import UIKit


final class InfoAlert: UIViewController{
	
	private enum CTitle {
		static var labelFont: UIFont { UIFont(name: "Helvetica Neue", size: 15)! }
		static var dataCheckCompleted = NSLocalizedString("Completed", comment: "")
		static var dataCheckNotCompleted = NSLocalizedString("Not completed", comment: "")
		static var withoutTime = NSLocalizedString("Without time", comment: "")
		static var no = NSLocalizedString("No", comment: "")
		static var yes = NSLocalizedString("Yes", comment: "")
	}
	
	private let infoViewAllert = UIView()
	private let data = localTaskStruct.taskStruct
	
	lazy var dateLabel = createLabel()
	lazy var createdAt = createLabel()
	lazy var statusLabel = createLabel()
	lazy var isOverdue = createLabel()
	lazy var viewAlert = createViewAlert()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		getData()
		addSubviewAndConfigure()
		setConstraints()
	}
	
	private func createViewAlert() -> UIView {
		let view = UIView()
		view.backgroundColor = .cellColor
		view.layer.cornerRadius = 10
		return view
	}
	
	private func createLabel() -> UILabel {
		let label = UILabel()
		label.textAlignment = .left
		label.font          = CTitle.labelFont
		label.textColor     = .blackWhite
		label.backgroundColor = .clear
		return label
	}
	
	private func getData() {
		let dateForm = DateForm()
		let check = data.check ? CTitle.dataCheckCompleted : CTitle.dataCheckNotCompleted
		let taskDate = data.taskDateDate == nil ? CTitle.withoutTime : dateForm.format(data: data.taskDateDate!)
		let isOver: String
		if data.taskDateDate != nil {
			isOver = data.taskDateDate! > Date.now ? CTitle.no : CTitle.yes
		} else {
			isOver = CTitle.withoutTime
		}
		
		self.statusLabel.text = String.localizedStringWithFormat(NSLocalizedString("status: %@", comment: ""), check)
		self.createdAt.text = String.localizedStringWithFormat(NSLocalizedString("creation time: %@", comment: ""), dateForm.format(data: data.createdAt))
		self.dateLabel.text = String.localizedStringWithFormat(NSLocalizedString("alert time: %@", comment: ""), taskDate)
		self.isOverdue.text = String.localizedStringWithFormat(NSLocalizedString("is overdue: %@", comment: ""), isOver)
	}
	
	@objc func dismissView() {
		dismiss(animated: true)
	}
}


	//MARK: - Layout
	extension InfoAlert {
		
	private func addSubviewAndConfigure() {
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
		tapGesture.numberOfTapsRequired = 1
		self.view.addGestureRecognizer(tapGesture)
		self.view.backgroundColor = .clear
		self.view.addSubview(viewAlert)
		self.viewAlert.addSubview(dateLabel)
		self.viewAlert.addSubview(createdAt)
		self.viewAlert.addSubview(statusLabel)
		self.viewAlert.addSubview(isOverdue)
	}
	
	
	private func setConstraints() {
		self.viewAlert.translatesAutoresizingMaskIntoConstraints = false
		self.viewAlert.widthAnchor.constraint(equalToConstant: 290).isActive = true
		self.viewAlert.heightAnchor.constraint(equalToConstant: 150).isActive = true
		self.viewAlert.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
		self.viewAlert.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
		
		self.dateLabel.translatesAutoresizingMaskIntoConstraints = false
		self.dateLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
		self.dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
		self.dateLabel.centerXAnchor.constraint(equalTo: self.viewAlert.centerXAnchor).isActive = true
		self.dateLabel.topAnchor.constraint(equalTo: self.viewAlert.topAnchor, constant: 20).isActive = true
		
		self.createdAt.translatesAutoresizingMaskIntoConstraints = false
		self.createdAt.widthAnchor.constraint(equalToConstant: 250).isActive = true
		self.createdAt.heightAnchor.constraint(equalToConstant: 20).isActive = true
		self.createdAt.centerXAnchor.constraint(equalTo: self.viewAlert.centerXAnchor).isActive = true
		self.createdAt.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor, constant: 10).isActive = true
		
		self.statusLabel.translatesAutoresizingMaskIntoConstraints = false
		self.statusLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
		self.statusLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
		self.statusLabel.centerXAnchor.constraint(equalTo: self.viewAlert.centerXAnchor).isActive = true
		self.statusLabel.topAnchor.constraint(equalTo: self.createdAt.bottomAnchor, constant: 10).isActive = true
		
		self.isOverdue.translatesAutoresizingMaskIntoConstraints = false
		self.isOverdue.widthAnchor.constraint(equalToConstant: 250).isActive = true
		self.isOverdue.heightAnchor.constraint(equalToConstant: 20).isActive = true
		self.isOverdue.centerXAnchor.constraint(equalTo: self.viewAlert.centerXAnchor).isActive = true
		self.isOverdue.topAnchor.constraint(equalTo: self.statusLabel.bottomAnchor, constant: 10).isActive = true
		
	}
}
