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
	
	
	lazy var startButton = makeStartButton()
	lazy var playPauseBTN = makePlayPauseBTN()
	lazy var stopRecordButton = makeStopRecordButton()
	lazy var timeLabel = makeTimeLabel()
	lazy var tableView = makeTableView()
	
	private var numberOfRecord = 0
	private var isAudioRecordingGranted: Bool!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTableView()
		settings()
		setupRecording()
		addSubview()
		setupConstraints()
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
				DispatchQueue.main.async {
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
	
	private func setupStopRecord() {
		stopRecordButton.setTitle("stop record", for: .normal)
		stopRecordButton.addTarget(self, action: #selector(stopRecord), for: .touchUpInside)
	}
	
	private func setupStartButton() {
		startButton.setTitle("start recording", for: .normal)
		startButton.addTarget(self, action: #selector(startRecord), for: .touchUpInside)
	}
	
	private func setupPlayPauseButton() {
		playPauseBTN.setTitle("pause", for: .normal)
		playPauseBTN.addTarget(self, action: #selector(playPause), for: .touchUpInside)
	}
	
	private func setupTableView() {
		self.tableView.register(VoiceCell.self, forCellReuseIdentifier: VoiceCell.identifier)
		tableView.delegate = self
		tableView.dataSource = self
		tableView.backgroundColor = .clear
		tableView.separatorStyle = .none
	}
	
	@objc func stopRecord() {
		audioRecorder.stop()
		audioRecorder = nil
		timeLabel.text = "00:00:00"
		meterTimerRecord.invalidate()
		tableView.reloadData()
	}
	
	@objc func playPause() {
		
	}

	
	@objc func startRecord() {
		
		if numberOfRecord == 0 {
			FileAdmin.createFolder(name: "\(id)")
		}
		
		if isAudioRecordingGranted {
			
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
				
				UserDefaults.standard.set(numberOfRecord, forKey: "\(id)")
				UserDefaults.standard.set(Date.now, forKey: "\(numberOfRecord).m4a")
			}
			
			catch let error {
				print("Error for start audio recording: \(error.localizedDescription)")
			}
		}
	}
	
	@objc func updateAudioRecordMeter(timer: Timer) {
		
		if audioRecorder.isRecording {
			let hr = Int((audioRecorder.currentTime / 60) / 60)
			let min = Int(audioRecorder.currentTime / 60)
			let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
			let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
			timeLabel.text = totalTimeString
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
		}
	}
}




extension RecordSheetVC: UITableViewDelegate, UITableViewDataSource {
		
	internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
			return numberOfRecord
		}
		

	
	private func visualViewVoiceCell(indexPath: IndexPath, cell: VoiceCell) {
		
		let date = UserDefaults.standard.object(forKey: "\(String(indexPath.row + 1)).m4a")
		let text = "№ \(String(indexPath.row + 1)) \(DateFormat.formatDate(textFormat: "HH:mm:ss EEEE, MMM d", date: date as? Date ?? Date.now))"
		cell.textFieldLabel.text = text
		cell.taskDateLabel.text = DateFormat.formatDate(textFormat: "HH:mm:ss EEEE, MMM d", date: date as? Date ?? Date.now)
	//	[weak self]
		cell.buttonAction = { [weak self] in
			
			guard let self = self else { return }
			guard let path = FileAdmin.getFileUrl(nameFolder: "\(self.id)", name: "\(indexPath.row + 1).m4a") else { return }
			
			self.cellVoice = cell
			cell.audioPlayer = try AVAudioPlayer(contentsOf: path)
			cell.togglePlayback()
		}
	}
	
//
//	if self.audioPlayer?.isPlaying != nil {
//		//self?.audioPlayer?.pause()
//		cell.playPauseButton.setImage(UIImage(systemName: "pause.fill")?.withTintColor(UIColor.black, renderingMode: .alwaysOriginal), for: .normal)
//	} else {
//		//self?.audioPlayer?.play()
//		cell.playPauseButton.setImage(UIImage(systemName: "play.fill")?.withTintColor(UIColor.black, renderingMode: .alwaysOriginal), for: .normal)
//	}
//
			
	
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
			} catch {
				print(error.localizedDescription)
				print("Could not delete file, probably read-only filesystem")
			}
		self.tableView.reloadData()
		//}
	}
	
	}

