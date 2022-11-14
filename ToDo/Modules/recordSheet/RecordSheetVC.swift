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
	var viewModel: RecordSheetViewModelProtocol!
	private var cellVoice: VoiceCell?
	lazy var recordButton = makeStartButton()
	lazy var timeLabel = makeTimeLabel()
	lazy var tableView = makeTableView()
	
	//MARK: - Animation Property
	lazy var bigLabel = makeTimeBigLabel()
	lazy var curtainView = UIView()
	lazy var differenceInSize = CGFloat()
	
	
	//MARK: - ViewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		//		setupTableView()
		viewModel.settings()
		viewModel.setupRecording()
		addSubview()
		setupConstraints()
		viewModel.animations.animSet(smallLb: timeLabel, bigLb: bigLabel, differenceInSize: &differenceInSize)
	}
	
	deinit {
		print("RecordSheetVC Deinit")
		NotificationCenter.default.post(name: Notification.Name("interactivePopGestureRecognizerON"), object: nil)
	}
	
	
	//MARK: - Methods
	@objc func startStop() {
		let number = UserDefaults.standard.object(forKey: "\(viewModel.id)")
		if number as? Int == 0 {
			FileAdmin.createFolder(name: "\(viewModel.id)")
			CoreDataMethods.shared.saveVoiceImage(tag: viewModel.id)
		}
		toggleRecordOrStop()
	}
	
	private func toggleRecordOrStop() {
		switch viewModel.isAudioRecordingGranted {
		case true: startRecord()
		case false: stopRecord()
		}
	}
	
	private func startAnimation() {
		TapticFeedback.shared.soft
		viewModel.animations.animateImageView(smallLb: timeLabel, bigLb: bigLabel, differenceInSize: differenceInSize)
		//viewModel.animations.curtain(color: .red, superView: view, upDown: .down, curtainView: curtainView)
	}
	
	private func stopAnimation() {
		TapticFeedback.shared.soft
		viewModel.animations.animateDownImageView(smallLb: timeLabel, bigLb: bigLabel, differenceInSize: differenceInSize)
		//viewModel.animations.curtain(color: .red, superView: view, upDown: .up, curtainView: curtainView)
	}
	
	private func startRecord() {
		startAnimation()
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
			viewModel.numberOfRecord += 1
			guard let audioFileUrl = FileAdmin.createFile(nameFolder: "\(viewModel.id)", name: "\(viewModel.numberOfRecord).m4a", contents: nil) else { return }
			
			//Create the audio recording, and assign ourselves as the delegate
			viewModel.audioRecorder = try AVAudioRecorder(url: audioFileUrl, settings: settings)
			viewModel.audioRecorder.isMeteringEnabled = true
			viewModel.audioRecorder.delegate = self
			viewModel.audioRecorder.record()
			viewModel.meterTimerRecord = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioRecordMeter(timer:)), userInfo:nil, repeats:true)
			recordButton.setImage(UIImage(systemName: Constants.stopButtonImage,
																		withConfiguration: Constants.config)?.withTintColor(Constants.recordButtonColor,
																																												renderingMode: .alwaysOriginal), for: .normal)
			UserDefaults.standard.set(viewModel.numberOfRecord, forKey: "\(viewModel.id)")
			UserDefaults.standard.set(Date.now, forKey: "\(viewModel.numberOfRecord).m4a")
		}
		catch let error {
			print("Error for start audio recording: \(error.localizedDescription)")
		}
		viewModel.isAudioRecordingGranted = false
	}
	
	private func stopRecord() {
		stopAnimation()
		viewModel.audioRecorder.stop()
		viewModel.audioRecorder = nil
		timeLabel.text = "00:00:00"
		bigLabel.text = "00:00:00"
		viewModel.meterTimerRecord.invalidate()
		recordButton.setImage(UIImage(systemName: Constants.recordButtonImage,
																	withConfiguration: Constants.config)?.withTintColor(Constants.recordButtonColor,
																																											renderingMode: .alwaysOriginal), for: .normal)
		viewModel.isAudioRecordingGranted = true
		tableView.reloadData()
	}
	
	@objc func updateAudioRecordMeter(timer: Timer) {
		if viewModel.audioRecorder.isRecording {
			let hr = Int((viewModel.audioRecorder.currentTime / 60) / 60)
			let min = Int(viewModel.audioRecorder.currentTime / 60)
			let sec = Int(viewModel.audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
			let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
			timeLabel.text = totalTimeString
			bigLabel.text = totalTimeString
			viewModel.audioRecorder.updateMeters()
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
		return viewModel.numberOfRecord
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		viewModel.selectedIndex = indexPath
		tableView.beginUpdates()
		tableView.reloadRows(at: [viewModel.selectedIndex], with: .none)
		tableView.endUpdates()
	}
	
	private func visualViewVoiceCell(indexPath: IndexPath, cell: VoiceCell) {
		let date = UserDefaults.standard.object(forKey: "\(String(indexPath.row + 1)).m4a")
		let text = "№ \(String(indexPath.row + 1)) \(try! DateFormat.formatDate(textFormat: "HH:mm:ss, MMM d", date: date as? Date ?? Date.now))"
		cell.textFieldLabel.text = text
		cell.taskDateLabel.text = try? DateFormat.formatDate(textFormat: "HH:mm:ss EEEE, MMM d", date: date as? Date ?? Date.now)
		cell.buttonAction = { [weak self] in
			guard let self = self else { return }
			guard let path = FileAdmin.getFileUrl(nameFolder: "\(self.viewModel.id)", name: "\(indexPath.row + 1).m4a") else { return }
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
		cell.selectionStyle = .none
		cell.animate()
		return cell
	}
	
	internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if viewModel.selectedIndex == indexPath { return 162 }
		return 60
	}
	
	internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		
		guard let fileURL = FileAdmin.getFileUrl(nameFolder: "\(viewModel.id)", name: "\(indexPath.row + 1).m4a") else { return }
		do {
			try FileManager.default.removeItem(at: fileURL)
			print("file is removed")
			viewModel.numberOfRecord -= 1
			UserDefaults.standard.set(viewModel.numberOfRecord, forKey: "\(viewModel.id)") //"myNumber"
			self.tableView.deleteRows(at: [indexPath], with: .automatic)
			self.tableView.reloadData()
			UserDefaults.standard.removeObject(forKey: "\(String(indexPath.row + 1)).m4a")
			timeLabel.text = "00:00:00"
			if viewModel.numberOfRecord == 0 {
				print("zero records")
				CoreDataMethods.shared.saveVoiceImage(tag: viewModel.id, isVisible: false)
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
