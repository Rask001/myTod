//
//  RecordSheetViewModel.swift
//  ToDo
//
//  Created by Антон on 10.11.2022.
//
import AVFoundation
import Foundation

//MARK: - Protocol
protocol RecordSheetViewModelProtocol {
	var animations: Animations { get }
	var timeLabelText: String { get set }
	func settings()
	func setupRecording()
	var id: Int { get set }
	var numberOfRecord: Int { get set }
	var data: TaskStruct { get }
	var audioRecorder: AVAudioRecorder! { get set }
	var meterTimerRecord: Timer! { get set }
	var isAudioRecordingGranted: Bool { get set }
	var selectedIndex: IndexPath { get set }
	//	func record()
	//	func stop()
	//	func toggleRecordOrStop()
}

//MARK: - Settings
final class RecordSheetViewModel: RecordSheetViewModelProtocol {
	var selectedIndex: IndexPath = IndexPath(row: 0, section: 0)
	let animations: Animations
	var timeLabelText: String = ""
	var isAudioRecordingGranted: Bool = true
	var recordingSession: AVAudioSession!
	var audioRecorder: AVAudioRecorder!
	var meterTimerRecord: Timer!
	var data: TaskStruct = localTaskStruct.taskStruct
	var id = 0
	var numberOfRecord = 0
	
	required init(animations: Animations) {
		self.animations = animations
	}
	
	
	func settings() {
		let idInt = try? Helper.createShortIntWithoutStrChar(fromItemsId: data.id)
		guard let idIntNotNil = idInt else { return }
		id = idIntNotNil
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

	func setupRecording() {
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
	
	//	internal func record() {
	//		TapticFeedback.shared.soft
	//	 // стоило бы перевести анимации на глобал .userinteractive
	//		viewModel.animations.animateImageView(smallLb: timeLabel, bigLb: bigLabel, differenceInSize: differenceInSize) //animateImageView()
	//		viewModel.animations.curtain(color: .red, superView: self.view, upDown: .down, curtainView: curtainView)
	//		let session = AVAudioSession.sharedInstance()
	//		do {
	//			try session.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
	//			try session.setActive(true)
	//			let settings = [
	//				AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
	//				AVSampleRateKey: 44100,
	//				AVNumberOfChannelsKey: 2,
	//				AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
	//			]
	//			numberOfRecord += 1
	//			guard let audioFileUrl = FileAdmin.createFile(nameFolder: "\(id)", name: "\(numberOfRecord).m4a", contents: nil) else { return }
	//
	//			//Create the audio recording, and assign ourselves as the delegate
	//			audioRecorder = try AVAudioRecorder(url: audioFileUrl, settings: settings)
	//			audioRecorder.isMeteringEnabled = true
	//			audioRecorder.delegate = self
	//			audioRecorder.record()
	//			meterTimerRecord = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioRecordMeter(timer:)), userInfo:nil, repeats:true)
	//			recordButton.setImage(UIImage(systemName: Constants.stopButtonImage,
	//																		withConfiguration: Constants.config)?.withTintColor(Constants.recordButtonColor,
	//																																							renderingMode: .alwaysOriginal), for: .normal)
	//			UserDefaults.standard.set(numberOfRecord, forKey: "\(id)")
	//			UserDefaults.standard.set(Date.now, forKey: "\(numberOfRecord).m4a")
	//		}
	//		catch let error {
	//			print("Error for start audio recording: \(error.localizedDescription)")
	//		}
	//		isAudioRecordingGranted = false
	//	}
	//
	//	internal func stop() {
	//		TapticFeedback.shared.soft
	//		animations.animateDownImageView(smallLb: timeLabel, bigLb: bigLabel, differenceInSize: differenceInSize)
	//		animations.curtain(color: .red, superView: self.view, upDown: .up, curtainView: curtainView)
	//		audioRecorder.stop()
	//		audioRecorder = nil
	//		timeLabel.text = "00:00:00"
	//		bigLabel.text = "00:00:00"
	//		meterTimerRecord.invalidate()
	//		recordButton.setImage(UIImage(systemName: Constants.recordButtonImage,
	//																	withConfiguration: Constants.config)?.withTintColor(Constants.recordButtonColor,
	//																																						renderingMode: .alwaysOriginal), for: .normal)
	//		isAudioRecordingGranted = true
	//		tableView.reloadData()
	//	}
	//
	//	func toggleRecordOrStop() {
	//		switch isAudioRecordingGranted {
	//		case true: record()
	//		case false: stop()
	//		}
	//	}
	
}
