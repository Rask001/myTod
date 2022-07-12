import Foundation
import UIKit

class CustomCell: UITableViewCell {
	static let shared = CustomCell()
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
	
	
//	var viewModel: TableViewCellViewModelType? {
//		willSet(viewModel) {
//			guard let viewModel = viewModel else { return }
//			
//			self.taskTitle.text = viewModel.taskTitle
//			self.taskTime.text = viewModel.taskTime
//			self.taskDate.text = viewModel.taskDate
//			self.alarmImageView.isHidden = !viewModel.alarmImage
//			self.repeatImageView.isHidden = !viewModel.repeatImage
//			if viewModel.repeatImage == false {
//				self.taskDate.text = viewModel.taskDate
//			} else {
//				self.taskDate.text = "every\(Int(viewModel.timeInterval!)!/60) min"
//			}
//			NotificationCenter.default.post(name: Notification.Name("TableViewReloadData"), object: .none)
//		}
//	}
	
	
	var taskDateDate: Date? = nil
	
	var backgroundViewCell: UIView        = {
		let view                            = UIView()
		view.backgroundColor                = .white
		view.layer.cornerRadius             = 10
		return view
	}()
	
	var taskTitle: UILabel                = {
		let taskTitle                       = UILabel(font: .NoteworthyBold20()!, textColor: .black)
		taskTitle.textAlignment             = .left
		taskTitle.adjustsFontSizeToFitWidth = true
		return taskTitle
	}()
	
	var taskTime: UILabel                 = {
		let taskTime                        = UILabel(font: .avenirNext20()!, textColor: .black)
		taskTime.textAlignment              = .center
		taskTime.adjustsFontSizeToFitWidth  = true
		return taskTime
	}()
	
	var taskDate: UILabel                 = {
		let taskDate                        = UILabel(font: .avenirNext20()!, textColor: .black)
		taskDate.textAlignment              = .center
		taskDate.adjustsFontSizeToFitWidth  = true
		return taskDate
	}()
	
	var buttonCell: UIButton              = {
		let buttonCell                      = UIButton(type: .system)
		buttonCell.layer.cornerRadius       = 10
		buttonCell.backgroundColor          = MainVC.shared.view.backgroundColor
		return buttonCell
	}()
	
	var alarmImageView: UIImageView       = {
		let alarmImageView                  = UIImageView()
		alarmImageView.image                = UIImage(systemName: "alarm")
		alarmImageView.tintColor            = .gray
		alarmImageView.contentMode          = .scaleAspectFit
		return alarmImageView
	}()
	
	var repeatImageView: UIImageView      = {
		let repeatImageView                 = UIImageView()
		repeatImageView.image               = UIImage(systemName: "repeat")
		repeatImageView.tintColor           = .gray
		repeatImageView.contentMode         = .scaleAspectFit
		return repeatImageView
	}()
	
	
	//MARK: - SetConstraints
	func addSubviewAndConfigure(){
		self.backgroundColor = .clear
		self.selectionStyle  = .none
		self.addSubview(backgroundViewCell)
		self.backgroundViewCell.addSubview(taskTime)
		self.backgroundViewCell.addSubview(alarmImageView)
		self.backgroundViewCell.addSubview(repeatImageView)
		self.backgroundViewCell.addSubview(buttonCell)
		self.backgroundViewCell.addSubview(taskTitle)
		self.backgroundViewCell.addSubview(taskDate)
	}
	
	func setConstraintsCell() {
		repeatImageView.translatesAutoresizingMaskIntoConstraints                                                    = false
		repeatImageView.topAnchor.constraint(equalTo: self.backgroundViewCell.topAnchor, constant: 4).isActive       = true
		repeatImageView.trailingAnchor.constraint(equalTo: self.alarmImageView.leadingAnchor, constant: -2).isActive = true
		repeatImageView.widthAnchor.constraint(equalToConstant: 17).isActive                                         = true
		repeatImageView.heightAnchor.constraint(equalToConstant: 17).isActive                                        = true
		
		alarmImageView.translatesAutoresizingMaskIntoConstraints                                                     = false
		alarmImageView.topAnchor.constraint(equalTo: self.backgroundViewCell.topAnchor, constant: 6).isActive        = true
		alarmImageView.trailingAnchor.constraint(equalTo: self.taskTime.leadingAnchor, constant: -4).isActive        = true
		alarmImageView.widthAnchor.constraint(equalToConstant: 14).isActive                                          = true
		alarmImageView.heightAnchor.constraint(equalToConstant: 14).isActive                                         = true
		
		taskTime.translatesAutoresizingMaskIntoConstraints                                                           = false
		taskTime.topAnchor.constraint(equalTo: self.backgroundViewCell.topAnchor, constant: 1).isActive              = true
		taskTime.trailingAnchor.constraint(equalTo: self.backgroundViewCell.trailingAnchor, constant: -3).isActive   = true
		taskTime.widthAnchor.constraint(equalToConstant: self.frame.width/5).isActive                                = true
		  
		taskDate.translatesAutoresizingMaskIntoConstraints                                                           = false
		taskDate.topAnchor.constraint(equalTo: self.taskTime.bottomAnchor, constant: 1).isActive                     = true
		taskDate.trailingAnchor.constraint(equalTo: self.backgroundViewCell.trailingAnchor, constant: -3).isActive   = true
		taskDate.widthAnchor.constraint(equalToConstant: self.frame.width/5).isActive                                = true
		  
		backgroundViewCell.translatesAutoresizingMaskIntoConstraints                                                 = false
		backgroundViewCell.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2).isActive                = true
		backgroundViewCell.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive            = true
		backgroundViewCell.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive                       = true
		backgroundViewCell.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive               = true
		  
		buttonCell.translatesAutoresizingMaskIntoConstraints                                                         = false
		buttonCell.centerYAnchor.constraint(equalTo: self.backgroundViewCell.centerYAnchor).isActive                 = true
		buttonCell.leadingAnchor.constraint(equalTo: self.backgroundViewCell.leadingAnchor, constant: 10).isActive   = true
		buttonCell.heightAnchor.constraint(equalToConstant: 35).isActive                                             = true
		buttonCell.widthAnchor.constraint(equalToConstant: 35).isActive                                              = true
		  
		taskTitle.translatesAutoresizingMaskIntoConstraints                                                          = false
		taskTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive                                     = true
		taskTitle.leadingAnchor.constraint(equalTo: buttonCell.trailingAnchor, constant: 8).isActive                 = true
		taskTitle.trailingAnchor.constraint(equalTo: self.repeatImageView.leadingAnchor, constant: -3).isActive      = true
	}
}
