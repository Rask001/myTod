//
//  CustomHeader.swift
//  ToDo
//
//  Created by Антон on 02.09.2022.
//
import Foundation
import UIKit

fileprivate enum Constants {
	static var taskTitleFont: UIFont { UIFont(name: "Futura", size: 20)!}
}

final class CustomHeader: UITableViewCell {
	static let shared = CustomHeader()
	static let identifier = "CustomHeader"

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		addSubviewAndConfigure()
		setConstraintsCell()
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	var backgroundViewCell: UIView        = {
		let view                            = UIView()
		view.backgroundColor                = .orange
		view.layer.cornerRadius             = 10
		return view
	}()

	var taskTitle: UILabel                = {
		let taskTitle                       = UILabel(font: Constants.taskTitleFont, textColor: .black)
		taskTitle.textAlignment             = .left
		taskTitle.adjustsFontSizeToFitWidth = true
		return taskTitle
	}()



//	MARK: - SetConstraints
	private func addSubviewAndConfigure() {
		self.backgroundColor = .red
		self.addSubview(backgroundViewCell)
		self.backgroundViewCell.addSubview(taskTitle)

	}

	private func setup(model: SectionStruct) {
		self.taskTitle.text = model.header
	}

	private func setConstraintsCell() {
		taskTitle.translatesAutoresizingMaskIntoConstraints                                                          = false
		taskTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive                                     = true
		taskTitle.leadingAnchor.constraint(equalTo: backgroundViewCell.trailingAnchor, constant: 20).isActive        = true
	}
}
