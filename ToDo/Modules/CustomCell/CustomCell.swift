import Foundation
import UIKit


//MARK: - class CustomCell
final class CustomCell: UITableViewCell {

	static let identifier = "CustomCell"
	
	lazy var backgroundViewCell = makeBackgroundViewCell()
	lazy var textFieldLabel = makeTextField()
	lazy var taskTitle = makeTaskTitle()
	lazy var taskTime = makeTaskTime()
	lazy var taskDate = makeTaskDate()
	lazy var weekLabel = makeWeekLabel()
	lazy var buttonCell = makeButtonCell()
	lazy var buttonOk = makeButtonOk()
	lazy var alarmImageView = makeAlarmImageView()
	lazy var repeatImageView = makeRepeatImageView()
	lazy var descriptImageView = makeDescriptImageView()
	lazy var voiceImageView = makeVoiceImageView()
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
