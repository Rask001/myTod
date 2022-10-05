//
//  RecordSheetVC.swift
//  ToDo
//
//  Created by Антон on 19.09.2022.
//

import Foundation
import UIKit
import AVFoundation


final class RecordSheetVC: UIViewController, AVAudioRecorderDelegate {
	
	//MARK: - Property
	private var recordingSession: AVAudioSession!
	private var audioRecorder: AVAudioRecorder!
	private var meterTimerRecord: Timer!
	private var cellVoice: VoiceCell?
	private let data = localTaskStruct.taskStruct
	private var id = 0
	private var numberOfRecord = 0
	private var isAudioRecordingGranted = true
	
	lazy var recordButton = makeStartButton()
	lazy var timeLabel = makeTimeLabel()
	lazy var tableView = makeTableView()
	
	
	//MARK: - Animation Property
	lazy var bigLabel = makeTimeBigLabel()
	lazy var animations = Animations()
	lazy var curtainView = UIView()
	lazy var differenceInSize = CGFloat()
	
	
	//MARK: - ViewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTableView()
		settings()
		setupRecording()
		addSubview()
		setupConstraints()
		animations.animSet(smallLb: timeLabel, bigLb: bigLabel, differenceInSize: &differenceInSize)
	}
	
	//MARK: - Settings
	private func settings() {
		let idInt = try? Helper.createShortIntWithoutStrChar(fromItemsId: data.id)
		guard let idIntNotNil = idInt else { return }
		self.id = idIntNotNil
		switch AVAudioSession.sharedInstance().recordPermission {
		case AVAudioSession.RecordPermission.granted:
			isAudioRecordingGranted = true
			break
		case AVAudioSession.RecordPermission.denied:
			isAudioRecordingGranted = false
			break
		case AVAudioSession.RecordPermission.undetermined:
			AVAudioSession.sharedInstance().requestRecordPermission() { [unowned self] allowed in
				DispatchQueue.main.async { [weak self]  in
					guard let self = self else { return }
					switch allowed {
					case true:
						self.isAudioRecordingGranted = true
					case false:
						self.isAudioRecordingGranted = false
					}
				}
			}
			break
		default:
			break
		}
	}
	
	private func setupTableView() {
		tableView.register(VoiceCell.self, forCellReuseIdentifier: VoiceCell.identifier)
		tableView.delegate = self
		tableView.dataSource = self
		tableView.backgroundColor = .clear
		tableView.separatorStyle = .none
		tableView.allowsSelection  = true
	}
	
	private func setupRecording() {
		recordingSession = AVAudioSession.sharedInstance()
		AVAudioSession.sharedInstance().requestRecordPermission { hasPermission in
			if hasPermission {
				print("Accepted")
			}
		}
		if let number: Int = UserDefaults.standard.object(forKey: "\(id)") as? Int {
			numberOfRecord = number
		} else {
			UserDefaults.standard.set(0, forKey: "\(id)")
		}
	}
	
	
	//MARK: - Methods
	@objc func startRecord() {
		let number = UserDefaults.standard.object(forKey: "\(id)")
		if number as? Int == 0 {
			FileAdmin.createFolder(name: "\(id)")
			CoreDataMethods.shared.saveVoiceImage(tag: id)
		}
		toggleRecordOrStop()
	}
	
	internal func toggleRecordOrStop() {
		switch isAudioRecordingGranted {
		case true: record()
		case false: stop()
		}
	}
	
	internal func record() {
		TapticFeedback.shared.soft
		animations.animateImageView(smallLb: timeLabel, bigLb: bigLabel, differenceInSize: differenceInSize) //animateImageView()
		animations.curtain(color: .red, superView: self.view, upDown: .down, curtainView: curtainView)
		let session = AVAudioSession.sharedInstance()
		do {
			try session.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
			try session.setActive(true)
			let settings = [
				AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
				AVSampleRateKey: 44100,
				AVNumberOfChannelsKey: 2,
				AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
			]
			numberOfRecord += 1
			guard let audioFileUrl = FileAdmin.createFile(nameFolder: "\(id)", name: "\(numberOfRecord).m4a", contents: nil) else { return }
			
			//Create the audio recording, and assign ourselves as the delegate
			audioRecorder = try AVAudioRecorder(url: audioFileUrl, settings: settings)
			audioRecorder.isMeteringEnabled = true
			audioRecorder.delegate = self
			audioRecorder.record()
			meterTimerRecord = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioRecordMeter(timer:)), userInfo:nil, repeats:true)
			recordButton.setImage(UIImage(systemName: Constants.stopButtonImage,
																		withConfiguration: Constants.config)?.withTintColor(Constants.recordButtonColor,
																																							renderingMode: .alwaysOriginal), for: .normal)
			UserDefaults.standard.set(numberOfRecord, forKey: "\(id)")
			UserDefaults.standard.set(Date.now, forKey: "\(numberOfRecord).m4a")
		}
		catch let error {
			print("Error for start audio recording: \(error.localizedDescription)")
		}
		isAudioRecordingGranted = false
	}
	
	internal func stop() {
		TapticFeedback.shared.soft
		animations.animateDownImageView(smallLb: timeLabel, bigLb: bigLabel, differenceInSize: differenceInSize)
		animations.curtain(color: .red, superView: self.view, upDown: .up, curtainView: curtainView)
		audioRecorder.stop()
		audioRecorder = nil
		timeLabel.text = "00:00:00"
		bigLabel.text = "00:00:00"
		meterTimerRecord.invalidate()
		recordButton.setImage(UIImage(systemName: Constants.recordButtonImage,
																	withConfiguration: Constants.config)?.withTintColor(Constants.recordButtonColor,
																																						renderingMode: .alwaysOriginal), for: .normal)
		isAudioRecordingGranted = true
		tableView.reloadData()
	}
	
	@objc func updateAudioRecordMeter(timer: Timer) {
		if audioRecorder.isRecording {
			let hr = Int((audioRecorder.currentTime / 60) / 60)
			let min = Int(audioRecorder.currentTime / 60)
			let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
			let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
			timeLabel.text = totalTimeString
			bigLabel.text = totalTimeString
			audioRecorder.updateMeters()
		}
	}

//	private func displayAlert(title: String, message: String) {
//		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//		alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
//		present(alert, animated: true, completion: nil)
//	}
}


//MARK: - extension
extension RecordSheetVC: UITableViewDelegate, UITableViewDataSource {
	
	internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return numberOfRecord
	}
	
	private func visualViewVoiceCell(indexPath: IndexPath, cell: VoiceCell) {
		let date = UserDefaults.standard.object(forKey: "\(String(indexPath.row + 1)).m4a")
		let text = "№ \(String(indexPath.row + 1)) \(DateFormat.formatDate(textFormat: "HH:mm:ss, MMM d", date: date as? Date ?? Date.now))"
		cell.textFieldLabel.text = text
		cell.taskDateLabel.text = DateFormat.formatDate(textFormat: "HH:mm:ss EEEE, MMM d", date: date as? Date ?? Date.now)
		cell.buttonAction = { [weak self] in
			guard let self = self else { return }
			guard let path = FileAdmin.getFileUrl(nameFolder: "\(self.id)", name: "\(indexPath.row + 1).m4a") else { return }
			self.cellVoice = cell
			cell.audioPlayer = try AVAudioPlayer(contentsOf: path)
			cell.togglePlayback()
			let durationTime = Int(cell.audioPlayer.duration)
			let minutes1 = durationTime / 60
			let seconds1 = durationTime - minutes1 * 60
			cell.timeNegative.text = String(format: "-%02d:%02d", minutes1, seconds1)
		}
	}
	
	internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: VoiceCell.identifier, for: indexPath) as! VoiceCell
		visualViewVoiceCell(indexPath: indexPath, cell: cell)
		return cell
	}
	
	internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 152
	}
	
	internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		
		guard let fileURL = FileAdmin.getFileUrl(nameFolder: "\(id)", name: "\(indexPath.row + 1).m4a") else { return }
		do {
			try FileManager.default.removeItem(at: fileURL)
			print("file is removed")
			numberOfRecord -= 1
			UserDefaults.standard.set(numberOfRecord, forKey: "\(id)") //"myNumber"
			self.tableView.deleteRows(at: [indexPath], with: .automatic)
			self.tableView.reloadData()
			UserDefaults.standard.removeObject(forKey: "\(String(indexPath.row + 1)).m4a")
			timeLabel.text = "00:00:00"
			if numberOfRecord == 0 {
				print("zero records")
				CoreDataMethods.shared.saveVoiceImage(tag: id, isVisible: false)
			}
		} catch {
			print(error.localizedDescription)
			print("Could not delete file, probably read-only filesystem")
		}
		self.tableView.reloadData()
	}
}


fileprivate enum Constants {
	static var recordButtonColor: UIColor { UIColor(named: "SoftRed") ?? .red}
	static var recordButtonImage: String { "record.circle.fill" }
	static var stopButtonImage: String { "stop" }
	static var config: UIImage.SymbolConfiguration { UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large) }
}
