//
//  RecordSheetVC.swift
//  ToDo
//
//  Created by Антон on 19.09.2022.
//

import Foundation
import UIKit
import AVFoundation



class RecordSheetVC: UIViewController, AVAudioRecorderDelegate {
	
	var recordingSession: AVAudioSession!
	var audioRecorder: AVAudioRecorder!
	var audioPlayer: AVAudioPlayer!
	var meterTimer:Timer!
	
	lazy var startButton = makeStartButton()
	lazy var playPauseBTN = makePlayPauseBTN()
	lazy var stopRecordButton = makeStopRecordButton()
	lazy var timeLabel = makeTimeLabel()
	lazy var tableView = makeTableView()
	
	var numberOfRecord = 0
	var isAudioRecordingGranted: Bool!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTableView()
		settings()
		setupRecording()
		addSubview()
		setupConstraints()
	}
	
	func settings() {
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
	
	func setupStopRecord() {
		stopRecordButton.setTitle("stop record", for: .normal)
		stopRecordButton.addTarget(self, action: #selector(stopRecord), for: .touchUpInside)
	}
	
	func setupStartButton() {
		startButton.setTitle("start recording", for: .normal)
		startButton.addTarget(self, action: #selector(startRecord), for: .touchUpInside)
	}
	
	func setupPlayPauseButton() {
		playPauseBTN.setTitle("pause", for: .normal)
		playPauseBTN.addTarget(self, action: #selector(playPause), for: .touchUpInside)
	}
	
	func setupTableView() {
		self.tableView.register(VoiceCell.self, forCellReuseIdentifier: VoiceCell.identifier)
		tableView.delegate = self
		tableView.dataSource = self
		tableView.backgroundColor = .secondarySystemBackground
		tableView.separatorStyle = .none
	}
	
	@objc func stopRecord() {
		audioRecorder.stop()
		audioRecorder = nil
		meterTimer.invalidate()
		tableView.reloadData()
	}

	
	@objc func playPause() {
		if audioPlayer.isPlaying {
			audioPlayer.pause()
			playPauseBTN.setTitle("play", for: .normal)
		} else {
			audioPlayer.play()
			playPauseBTN.setTitle("pause", for: .normal)
		}
		
	}
	
	@objc func startRecord() {
		
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
				//Create audio file name URL
				let audioFilename = getDirectory().appendingPathComponent("\(numberOfRecord).m4a")
				let audioFileName = URL(fileURLWithPath: "\(numberOfRecord).m4a", relativeTo: getDirectory())
				print(audioFilename.path)
				print(audioFileName.path)
				
				//Create the audio recording, and assign ourselves as the delegate
				audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
				audioRecorder.delegate = self
				audioRecorder.isMeteringEnabled = true
				audioRecorder.record()
				meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioRecordMeter(timer:)), userInfo:nil, repeats:true)
				UserDefaults.standard.set(numberOfRecord, forKey: "myNumber")
				UserDefaults.standard.set(Date.now, forKey: "\(numberOfRecord).m4a")
				print(numberOfRecord)
				tableView.reloadData()
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
	
	@objc func updateAudioPlayerMeter(timer: Timer) {
		
		if audioPlayer.isPlaying {
			let hr = Int((audioPlayer.currentTime / 60) / 60)
			let min = Int(audioPlayer.currentTime / 60)
			let sec = Int(audioPlayer.currentTime.truncatingRemainder(dividingBy: 60))
			
			let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
			timeLabel.text = totalTimeString
			audioPlayer.updateMeters()
		}
	}
	
	
	//получаем место хранения файла
	func getDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
		return paths
	}
	
	func displayAlert(title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
		present(alert, animated: true, completion: nil)
	}
	
	
	func setupRecording() {
		recordingSession = AVAudioSession.sharedInstance()
		AVAudioSession.sharedInstance().requestRecordPermission { hasPermission in
			if hasPermission {
				print("Accepted")
			}
		}
		if let number: Int = UserDefaults.standard.object(forKey: "myNumber") as? Int {
			numberOfRecord = number
		}
	}
}




extension RecordSheetVC: UITableViewDelegate, UITableViewDataSource {
		
		public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
			return numberOfRecord
		}
		
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell   = tableView.dequeueReusableCell(withIdentifier: VoiceCell.identifier, for: indexPath) as! VoiceCell
		let date = UserDefaults.standard.object(forKey: "\(String(indexPath.row + 1)).m4a")
		let text = "№ \(String(indexPath.row + 1)) \(DateFormat.formatDate(textFormat: "HH:mm:ss EEEE, MMM d", date: date as? Date ?? Date.now))"
		cell.textFieldLabel.text = text
		cell.taskDateLabel.text = DateFormat.formatDate(textFormat: "HH:mm:ss EEEE, MMM d", date: date as? Date ?? Date.now)
		//cell.textLabel?.text = text
		return cell
	}
			
			
//			let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		
		func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
			let path = getDirectory().appendingPathComponent("\(indexPath.row + 1).m4a")
			do{
				audioPlayer = try AVAudioPlayer(contentsOf: path)
				audioPlayer.play()
				meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioPlayerMeter(timer:)), userInfo:nil, repeats:true)
			} catch {
				displayAlert(title: "error", message: "smth wrong")
			}
		}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 120
	}
//	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//		return 100
//	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		let documentDirectory = paths[0]
		
		let fileURL = URL(fileURLWithPath: "\(indexPath.row + 1).m4a", relativeTo: documentDirectory)

			do {
				try FileManager.default.removeItem(at: fileURL)
				print("file is removed")
				numberOfRecord -= 1
				UserDefaults.standard.set(numberOfRecord, forKey: "myNumber")
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

