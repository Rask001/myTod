//
//  VoiceCell.swift
//  ToDo
//
//  Created by Антон on 20.09.2022.
//


import Foundation
import UIKit
import AVFAudio


//MARK: - class CustomCell
final class VoiceCell: UITableViewCell {
	
	static let identifier = "VoiceCell"
	var check = false
	internal var audioPlayer: AVAudioPlayer!
	internal var meterTimer: Timer!
	
	
	lazy var backgroundViewCell = makeBackgroundViewCell()
	lazy var textFieldLabel = makeTextField()
	lazy var taskTitle = makeTaskTitle()
	lazy var taskTime = makeTaskTime()
	lazy var timePlus = makeTimePlus()
	lazy var timeNegative = makeTimeNegative()
	lazy var taskDateLabel = makeTaskDate()
	lazy var buttonCell = makeButtonCell()
	lazy var playPauseButton = makePlayPauseButton()
	lazy var slider = makeSlider()
	
	var buttonAction: (() throws -> Void)?
	var taskDateDate: Date? = nil
	var id: String = UUID().uuidString
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		addSubviewAndConfigure()
		setConstraintsCell()
		UserDefaults.standard.set(0, forKey: "pauseTime")
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}