//
//  RecordSheetConst.swift
//  ToDo
//
//  Created by Антон on 19.09.2022.
//

import Foundation
import UIKit


extension RecordSheetVC {
	
	func makeStartButton() -> UIButton {
		let btn = UIButton(type: .system)
		btn.setTitle("start recording", for: .normal)
		btn.addTarget(self, action: #selector(startRecord), for: .touchUpInside)
		return btn
	}
	
	func makePlayPauseBTN() -> UIButton {
		let button = UIButton(type: .system)
		button.setTitle("pause", for: .normal)
		button.tag = 0
		button.addTarget(self, action: #selector(playPause), for: .touchUpInside)
		return button
	}
	
	func makeStopRecordButton() -> UIButton {
		let btn = UIButton(type: .system)
		btn.setTitle("stop record", for: .normal)
		btn.addTarget(self, action: #selector(stopRecord), for: .touchUpInside)
		return btn
	}
	
	func makeTimeLabel() -> UILabel {
		let lbl = UILabel()
		lbl.textAlignment = .center
		lbl.text = "00:00:00"
		return lbl
	}
	
	func makeTableView() -> UITableView {
		let tV = UITableView()
		tV.delegate = self
		tV.dataSource = self
		tV.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		return tV
	}
	
	
	
	
	func addSubview() {
		self.view.backgroundColor = .secondarySystemBackground
		self.view.addSubview(startButton)
		self.view.addSubview(playPauseBTN)
		self.view.addSubview(tableView)
		self.view.addSubview(stopRecordButton)
		self.view.addSubview(timeLabel)
	}
	
	
	func setupConstraints() {
		
		timeLabel.translatesAutoresizingMaskIntoConstraints = false
		timeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
		timeLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 200).isActive = true
		timeLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
		timeLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
		
		stopRecordButton.translatesAutoresizingMaskIntoConstraints = false
		stopRecordButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
		stopRecordButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 150).isActive = true
		stopRecordButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
		stopRecordButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
		
		playPauseBTN.translatesAutoresizingMaskIntoConstraints = false
		playPauseBTN.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
		playPauseBTN.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
		playPauseBTN.widthAnchor.constraint(equalToConstant: 150).isActive = true
		playPauseBTN.heightAnchor.constraint(equalToConstant: 50).isActive = true
		
		startButton.translatesAutoresizingMaskIntoConstraints = false
		startButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
		startButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
		startButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
		startButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
		
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
		tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
		tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 280).isActive = true
	}
}
