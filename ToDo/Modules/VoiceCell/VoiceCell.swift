//
//  VoiceCell.swift
//  ToDo
//
//  Created by Антон on 20.09.2022.
//

import Foundation
import UIKit


//MARK: - class CustomCell
final class VoiceCell: UITableViewCell {

	static let identifier = "VoiceCell"
	
	lazy var backgroundViewCell = makeBackgroundViewCell()
	lazy var textFieldLabel = makeTextField()
	lazy var taskTitle = makeTaskTitle()
	lazy var taskTime = makeTaskTime()
	lazy var timePlus = makeTimePlus()
	lazy var timeNegative = makeTimeNegative()
	lazy var taskDateLabel = makeTaskDate()
	lazy var buttonCell = makeButtonCell()
	lazy var playPauseButton = makePlayPauseButton()

	var taskDateDate: Date? = nil
	var id: String = ""
	
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		addSubviewAndConfigure()
		setConstraintsCell()
		gestureRecognizerLongTap()
		gestureRecognizerTap()
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
