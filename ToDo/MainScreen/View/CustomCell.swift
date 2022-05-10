import Foundation
import UIKit

class CustomCell: UITableViewCell {
	
	static let identifier = "CustomCell"
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.backgroundColor = .clear
		addSubviewAndConfigure()
		setConstraintsCell()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	var backgroundViewCell: UIView        = {
		let view                            = UIView()
		view.backgroundColor                = .white
		view.layer.cornerRadius             = 10
		return view
	}()
	
	var taskTitle: UILabel                = {
		let taskTitle                       = UILabel(font: .avenir20()!, textColor: .black)
		taskTitle.textAlignment             = .left
		taskTitle.adjustsFontSizeToFitWidth = true
		return taskTitle
	}()
	
	var taskTime: UILabel                 = {
		let taskTime                        = UILabel(font: .avenirNext16()!, textColor: .black)
		taskTime.textAlignment              = .left
		taskTime.adjustsFontSizeToFitWidth  = true
		return taskTime
	}()
	
	var buttonCell: UIButton              = {
		let buttonCell                      = UIButton(type: .system)
		buttonCell.layer.cornerRadius       = 10
		buttonCell.backgroundColor          = MainVC.shared.view.backgroundColor
		//buttonCell.isEnabled                = true
		//buttonCell.addTarget(CustomCell.self, action: #selector(), for: .touchUpInside)
		return buttonCell
	}()
	
	var alarmImageView: UIImageView       = {
		let alarmImageView                  = UIImageView()
		alarmImageView.image                = UIImage(systemName: "alarm")
		alarmImageView.frame                = CGRect(x: 280, y: 5, width: 12, height: 12)
		alarmImageView.tintColor            = .gray
		alarmImageView.contentMode          = .scaleAspectFit
		return alarmImageView
	}()
	
	var repeatImageView: UIImageView      = {
		let repeatImageView                 = UIImageView()
		repeatImageView.image               = UIImage(systemName: "repeat")
		repeatImageView.frame               = CGRect(x: 265, y: 5, width: 13, height: 13)
		repeatImageView.tintColor           = .gray
		repeatImageView.contentMode         = .scaleAspectFit
		return repeatImageView
	}()
	
	
	func addSubviewAndConfigure(){
		self.backgroundColor = .clear
		self.selectionStyle = .none
		self.addSubview(backgroundViewCell)
		self.backgroundViewCell.addSubview(taskTime)
		self.backgroundViewCell.addSubview(alarmImageView)
		self.backgroundViewCell.addSubview(repeatImageView)
		self.backgroundViewCell.addSubview(buttonCell)
		self.backgroundViewCell.addSubview(taskTitle)
		
	}
	
	func setConstraintsCell() {
		taskTime.translatesAutoresizingMaskIntoConstraints           = false
		backgroundViewCell.translatesAutoresizingMaskIntoConstraints = false
		buttonCell.translatesAutoresizingMaskIntoConstraints         = false
		taskTitle.translatesAutoresizingMaskIntoConstraints          = false
		
		NSLayoutConstraint.activate([
			taskTime.topAnchor.constraint(equalTo: self.backgroundViewCell.topAnchor, constant: 1),
			taskTime.trailingAnchor.constraint(equalTo: self.backgroundViewCell.trailingAnchor, constant: -3),
			taskTime.widthAnchor.constraint(equalToConstant: self.frame.width/6),
		])
		
		NSLayoutConstraint.activate([
			backgroundViewCell.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2),
			backgroundViewCell.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
			backgroundViewCell.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
			backgroundViewCell.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5)
		])
		
		NSLayoutConstraint.activate([
			buttonCell.centerYAnchor.constraint(equalTo: self.backgroundViewCell.centerYAnchor),
			buttonCell.leadingAnchor.constraint(equalTo: self.backgroundViewCell.leadingAnchor, constant: 10),
			buttonCell.heightAnchor.constraint(equalToConstant: 35),
			buttonCell.widthAnchor.constraint(equalToConstant: 35)
		])
		
		NSLayoutConstraint.activate([
			taskTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			taskTitle.leadingAnchor.constraint(equalTo: buttonCell.trailingAnchor, constant: 8),
			taskTitle.trailingAnchor.constraint(equalTo: self.repeatImageView.leadingAnchor, constant: -3)
		])
	}
	
	
	
}
