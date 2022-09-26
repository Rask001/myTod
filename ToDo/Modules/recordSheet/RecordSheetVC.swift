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
	
	private var recordingSession: AVAudioSession!
	private	var audioRecorder: AVAudioRecorder!
	internal var meterTimerRecord: Timer!
	private var cellVoice: VoiceCell?
	private let data = localTaskStruct.taskStruct
	private var id: Int = 0
	
	lazy var recordButton = makeStartButton()
	lazy var timeLabel = makeTimeLabel()
	lazy var tableView = makeTableView()
	lazy var bigLabel = makeTimeBigLabel()
	
	let imageView = UIImageView()
	
//	let anotherLabel = UILabel()
	var differenceInSize = CGFloat()
	
	private var numberOfRecord = 0
	private var isAudioRecordingGranted = true
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTableView()
		settings()
		setupRecording()
		addSubview()
		setupConstraints()
		imageView.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0)
	  imageView.frame = CGRect(x: 0, y: -10, width: self.view.frame.width, height: 10)
		animSet()
	}
	
	private func animSet() {
		self.bigLabel.center = self.timeLabel.center
		self.differenceInSize = bigLabel.font.pointSize / timeLabel.font.pointSize
		self.timeLabel.alpha = 1
		self.bigLabel.alpha = 0
		self.bigLabel.transform = CGAffineTransform(scaleX: 1/self.differenceInSize, y: 1/self.differenceInSize)
	}
	
	private func animateImageView() {
		UIView.animate(withDuration: 1, delay: 0.2) { [weak self]  in
			guard let self = self else { return }
			self.timeLabel.layer.shadowRadius = 5
			self.timeLabel.layer.shadowOpacity = 0.4
			self.timeLabel.layer.shadowOffset = CGSize(width: 0, height: 6 )
			
			self.bigLabel.layer.shadowRadius = 5
			self.bigLabel.layer.shadowOpacity = 0.4
			self.bigLabel.layer.shadowOffset = CGSize(width: 0, height: 6 )
			
			self.timeLabel.alpha = 0
			self.bigLabel.alpha = 1
			self.timeLabel.transform = CGAffineTransform(scaleX: self.differenceInSize, y: self.differenceInSize)
			self.bigLabel.transform = CGAffineTransform.identity
			
			self.imageView.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.1)
			self.imageView.frame = CGRect(x: 0, y: -10, width: self.view.frame.width, height: 800)
		}
	}
	
	private func animateDownImageView() {
		UIView.animate(withDuration: 1, delay: 0.3) { [weak self]  in
			guard let self = self else { return }
			self.timeLabel.font = UIFont(name: "Helvetica Neue Medium", size: 40)
			self.imageView.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.0)
			self.imageView.frame = CGRect(x: 0, y: -10, width: self.view.frame.width, height: 10)
			
			
			self.timeLabel.layer.shadowRadius = 2
			self.timeLabel.layer.shadowOpacity = 0.4
			self.timeLabel.layer.shadowOffset = CGSize(width: 0, height: 3 )
			
			self.bigLabel.layer.shadowRadius = 2
			self.bigLabel.layer.shadowOpacity = 0.4
			self.bigLabel.layer.shadowOffset = CGSize(width: 0, height: 3 )
			
			
			
			self.timeLabel.alpha = 1
			self.bigLabel.alpha = 0
			
			self.bigLabel.transform = CGAffineTransform(scaleX: 1/self.differenceInSize, y: 1/self.differenceInSize)
			self.timeLabel.transform = CGAffineTransform.identity
			
		
		}
	}
	
	private func settings() {
		let idInt = Helper.createShortIntWithoutStrChar(fromItemsId: data.id)
		self.id = idInt
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
					if allowed {
						self.isAudioRecordingGranted = true
					} else {
						self.isAudioRecordingGranted = false
					}
				}
			}
			break
		default:
			break
		}
	}
	
	
//	private func setupPlayPauseButton() {
//		playPauseBTN.setTitle("pause", for: .normal)
//		playPauseBTN.addTarget(self, action: #selector(playPause), for: .touchUpInside)
//	}
	
	private func setupTableView() {
		self.tableView.register(VoiceCell.self, forCellReuseIdentifier: VoiceCell.identifier)
		tableView.delegate = self
		tableView.dataSource = self
		tableView.backgroundColor = .clear
		tableView.separatorStyle = .none
		tableView.allowsSelection  = true
	}
	
	internal func toggleRecordStop() {
		switch isAudioRecordingGranted {
		case true: record()
		case false: stop()
		}
	}
																	
	
	internal func record() {
		animateImageView()
			//Create the session.
			let session = AVAudioSession.sharedInstance()
			do {
				//Configure the session for recording and playback.
				try session.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
				try session.setActive(true)
				//Set up a high-quality recording session.
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
				audioRecorder.delegate = self
				audioRecorder.isMeteringEnabled = true
				audioRecorder.record()
				meterTimerRecord = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioRecordMeter(timer:)), userInfo:nil, repeats:true)
				let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .heavy, scale: .large)
				recordButton.setImage(UIImage(systemName: "stop", withConfiguration: config)?.withTintColor(UIColor(named: "SoftRed")!, renderingMode: .alwaysOriginal), for: .normal)
				UserDefaults.standard.set(numberOfRecord, forKey: "\(id)")
				UserDefaults.standard.set(Date.now, forKey: "\(numberOfRecord).m4a")
			}
			
			catch let error {
				print("Error for start audio recording: \(error.localizedDescription)")
			}
		isAudioRecordingGranted = false
	}
	
	
	internal func stop() {
		animateDownImageView()
		audioRecorder.stop()
		audioRecorder = nil
		timeLabel.text = "00:00:00"
		bigLabel.text = "00:00:00"
		meterTimerRecord.invalidate()
		let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large)
		recordButton.setImage(UIImage(systemName: "record.circle.fill", withConfiguration: config)?.withTintColor(UIColor(named: "SoftRed")!, renderingMode: .alwaysOriginal), for: .normal)
		isAudioRecordingGranted = true
		tableView.reloadData()
	}
	
	
	@objc func startRecord() {
		let number = UserDefaults.standard.object(forKey: "\(id)")
		if number as? Int == 0 {
			FileAdmin.createFolder(name: "\(id)")
			CoreDataMethods.shared.saveVoiceImage(tag: id)
		}
		toggleRecordStop()
	}
	
	
	
	@objc func updateAudioRecordMeter(timer: Timer) {
		
		if audioRecorder.isRecording {
			let hr = Int((audioRecorder.currentTime / 60) / 60)
			let min = Int(audioRecorder.currentTime / 60)
			let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
			//let ms = Int((self.audioRecorder.currentTime * 1000).truncatingRemainder(dividingBy: 1000))
			let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
			timeLabel.text = totalTimeString
			bigLabel.text = totalTimeString
			audioRecorder.updateMeters()
		}
	}
	
	
	private func displayAlert(title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
		present(alert, animated: true, completion: nil)
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
}


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
		let cell   = tableView.dequeueReusableCell(withIdentifier: VoiceCell.identifier, for: indexPath) as! VoiceCell
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

