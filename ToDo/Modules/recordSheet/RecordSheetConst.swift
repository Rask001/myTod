//
//  RecordSheetConst.swift
//  ToDo
//
//  Created by Антон on 19.09.2022.
//

import Foundation
import UIKit

//MARK: - Constants
private enum Constants {
	static var bigLabelFont: UIFont { UIFont(name: "Helvetica Neue Medium", size: 45)! }
	static var timeLabelFont: UIFont { UIFont(name: "Helvetica Neue Medium", size: 40)! }
	static var recordButtonBackgroundColor: UIColor { .clear }
	static var recordButtonCornerRadius: CGFloat { 35 }
	static var recordButtonColor: UIColor { UIColor(named: "SoftRed") ?? .red}
	static var recordButtonImage: String { "record.circle.fill" }
	static var stopButtonImage: String { "stop" }
	static var config: UIImage.SymbolConfiguration { UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large) }
}

extension RecordSheetVC {
	
	internal func makeStartButton() -> UIButton {
		let recordButton = UIButton()
		recordButton.layer.cornerRadius = Constants.recordButtonCornerRadius
		recordButton.setImage(UIImage(systemName: Constants.recordButtonImage,
																	withConfiguration: Constants.config)?.withTintColor(Constants.recordButtonColor,
																																						renderingMode: .alwaysOriginal), for: .normal)
		recordButton.scalesLargeContentImage = true
		recordButton.layer.shadowColor = UIColor.black.cgColor
		recordButton.layer.shadowRadius = 3
		recordButton.layer.shadowOpacity = 0.2
		recordButton.layer.shadowOffset = CGSize(width: 0, height: 3 )
		recordButton.backgroundColor = Constants.recordButtonBackgroundColor
		recordButton.addTarget(self, action: #selector(startRecord), for: .touchUpInside)
		return recordButton
	}
	
	internal func makeTimeLabel() -> UILabel {
		let lbl = UILabel()
		lbl.textAlignment = .center
		lbl.font = Constants.timeLabelFont
		lbl.text = "00:00:00"
		
		lbl.layer.shadowColor = UIColor.black.cgColor
		lbl.layer.shadowRadius = 2
		lbl.layer.shadowOpacity = 0.4
		lbl.layer.shadowOffset = CGSize(width: 0, height: 3 )
		lbl.backgroundColor = .clear//
		return lbl
	}
	
	internal func makeTimeBigLabel() -> UILabel {
		let lbl = UILabel()
		lbl.textAlignment = .center
		lbl.font = Constants.bigLabelFont
		lbl.text = "00:00:00"
		
		lbl.layer.shadowColor = UIColor.black.cgColor
		lbl.layer.shadowRadius = 2
		lbl.layer.shadowOpacity = 0.4
		lbl.layer.shadowOffset = CGSize(width: 0, height: 3 )
		lbl.backgroundColor = .clear//
		return lbl
	}
	
	internal func makeTableView() -> UITableView {
		let tV = UITableView()
		tV.delegate = self
		tV.dataSource = self
		tV.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		return tV
	}
	
	
	//MARK: - SetupConstraints
	internal func addSubview() {
		self.view.backgroundColor = .secondarySystemBackground
		self.view.addSubview(curtainView)
		self.view.addSubview(recordButton)
		self.view.addSubview(tableView)
		self.view.addSubview(timeLabel)
		self.view.addSubview(bigLabel)
	}
	
	internal func setupConstraints() {
		bigLabel.translatesAutoresizingMaskIntoConstraints = false
		bigLabel.centerXAnchor.constraint(equalTo: self.timeLabel.centerXAnchor).isActive = true
		bigLabel.centerYAnchor.constraint(equalTo: self.recordButton.centerYAnchor).isActive = true
		bigLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50).isActive = true
		bigLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
		bigLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
		
		timeLabel.translatesAutoresizingMaskIntoConstraints = false
		timeLabel.centerYAnchor.constraint(equalTo: self.recordButton.centerYAnchor).isActive = true
		timeLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50).isActive = true
		timeLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
		timeLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
		
		recordButton.translatesAutoresizingMaskIntoConstraints = false
		recordButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50).isActive = true
		recordButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
		recordButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
		recordButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
		
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
		tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
		tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 170).isActive = true
	}
}
