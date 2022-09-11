import Foundation
import UIKit

fileprivate enum Constants {
	static var cellFont: UIFont { UIFont(name: "Helvetica Neue", size: 20)!}
	static var cellDistance: CGFloat { -3 }
	static var textFiledFont: UIFont { UIFont(name: "Helvetica Neue", size: 20)!}
}


final class CustomCell: UITableViewCell {
	static let shared = CustomCell()
	static let identifier = "CustomCell"
	let helper = Helper()
	var taskDateDate: Date? = nil
	var id: String = ""
	
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		addSubviewAndConfigure()
		setConstraintsCell()
		gestureRecognizerLongTap()
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func gestureRecognizerLongTap() {
		let	gestureLongRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
		gestureLongRecogniser.minimumPressDuration = 1
		gestureLongRecogniser.delegate = self
		self.addGestureRecognizer(gestureLongRecogniser)
		textFieldLabel.delegate = self
		textFieldLabel.addTarget(self, action: #selector(textFieldDidChange), for: .editingDidEndOnExit)
	}
	

	
	
	@objc func longPress(gestureRecognizer: UILongPressGestureRecognizer) {
		TapticFeedback.shared.medium
		textFieldLabel.isHidden = false
		textFieldLabel.becomeFirstResponder()
		buttonCell.isEnabled = false
	}
	
	@objc func textFieldDidChange() {
		
		self.endEditing(true)
		self.textFieldLabel.isHidden = true
		self.buttonCell.isEnabled = true
		
		CoreDataMethods.shared.fetchRequest()
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		let model = CoreDataMethods.shared.coreDataModel
    let cellTag = buttonCell.tag
		for items in model {
			let itemsId = helper.createShortIntWithoutStrChar(fromItemsId: items.id)
			if cellTag == itemsId {
				items.taskTitle = textFieldLabel.text ?? "error Custon Cell"
			}
		}
		do {
			try context.save()
			print("save editing")
		} catch let error as NSError {
			print(error.localizedDescription)
		}
		NotificationCenter.default.post(name: Notification.Name("TableViewReloadData"), object: .none)
	}
	
	var backgroundViewCell: UIView        = {
		let view                            = UIView()
		view.backgroundColor                = .cellColor
		view.layer.cornerRadius             = 10
		view.layer.shadowColor              = UIColor.black.cgColor
		view.layer.shadowRadius             = 4
		view.layer.shadowOpacity            = 0.2
		view.layer.shadowOffset             = CGSize(width: 0, height: 3 )
		return view
	}()
	
	var taskTitle: UILabel                = {
		let taskTitle                       = UILabel(font: Constants.cellFont, textColor: .black)
		taskTitle.textAlignment             = .left
		taskTitle.adjustsFontSizeToFitWidth = true
		taskTitle.isHidden = false
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
		let buttonCell                      = UIButton(type: .custom)
		buttonCell.layer.cornerRadius       = 17.5
		buttonCell.backgroundColor          = UIColor.backgroundColor
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
	
	var textFieldLabel: UITextField = {
		let textField = UITextField()
		textField.borderStyle               = UITextField.BorderStyle.none
		textField.backgroundColor           = .cellColor
		textField.font                      = Constants.textFiledFont
		textField.textAlignment             = .left
		textField.adjustsFontSizeToFitWidth = true
		textField.clearButtonMode           = .always
		textField.isHidden                  = true
		return textField
	}()
	
	//MARK: - SetConstraints
	func addSubviewAndConfigure() {
		self.contentView.backgroundColor = .clear
		self.backgroundColor = .clear
		self.selectionStyle  = .none
		self.addSubview(backgroundViewCell)
		self.backgroundViewCell.addSubview(taskTime)
		self.backgroundViewCell.addSubview(alarmImageView)
		self.backgroundViewCell.addSubview(repeatImageView)
		self.backgroundViewCell.addSubview(buttonCell)
		self.backgroundViewCell.addSubview(taskTitle)
		self.backgroundViewCell.addSubview(taskDate)
		self.backgroundViewCell.addSubview(textFieldLabel)
	}
	
	func setConstraintsCell() {
		repeatImageView.translatesAutoresizingMaskIntoConstraints                                                         = false
		repeatImageView.topAnchor.constraint(equalTo: self.backgroundViewCell.topAnchor, constant: 4).isActive            = true
		repeatImageView.trailingAnchor.constraint(equalTo: self.alarmImageView.leadingAnchor, constant: -2).isActive      = true
		repeatImageView.widthAnchor.constraint(equalToConstant: 17).isActive                                              = true
		repeatImageView.heightAnchor.constraint(equalToConstant: 17).isActive                                             = true
		     
		alarmImageView.translatesAutoresizingMaskIntoConstraints                                                          = false
		alarmImageView.topAnchor.constraint(equalTo: self.backgroundViewCell.topAnchor, constant: 6).isActive             = true
		alarmImageView.trailingAnchor.constraint(equalTo: self.taskTime.leadingAnchor, constant: -4).isActive             = true
		alarmImageView.widthAnchor.constraint(equalToConstant: 14).isActive                                               = true
		alarmImageView.heightAnchor.constraint(equalToConstant: 14).isActive                                              = true
		     
		taskTime.translatesAutoresizingMaskIntoConstraints                                                                = false
		taskTime.topAnchor.constraint(equalTo: self.backgroundViewCell.topAnchor, constant: 1).isActive                   = true
		taskTime.trailingAnchor.constraint(equalTo: self.backgroundViewCell.trailingAnchor, constant: -3).isActive        = true
		taskTime.widthAnchor.constraint(equalToConstant: self.frame.width/5).isActive                                     = true
		       
		taskDate.translatesAutoresizingMaskIntoConstraints                                                                = false
		taskDate.topAnchor.constraint(equalTo: self.taskTime.bottomAnchor, constant: 1).isActive                          = true
		taskDate.trailingAnchor.constraint(equalTo: self.backgroundViewCell.trailingAnchor, constant: -3).isActive        = true
		taskDate.widthAnchor.constraint(equalToConstant: self.frame.width/5).isActive                                     = true
		  
		backgroundViewCell.translatesAutoresizingMaskIntoConstraints                                                      = false
		backgroundViewCell.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: Constants.cellDistance).isActive = true
		backgroundViewCell.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive                 = true
		backgroundViewCell.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive                            = true
		backgroundViewCell.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive                    = true
		       
		buttonCell.translatesAutoresizingMaskIntoConstraints                                                              = false
		buttonCell.centerYAnchor.constraint(equalTo: self.backgroundViewCell.centerYAnchor).isActive                      = true
		buttonCell.leadingAnchor.constraint(equalTo: self.backgroundViewCell.leadingAnchor, constant: 10).isActive        = true
		buttonCell.heightAnchor.constraint(equalToConstant: 35).isActive                                                  = true
		buttonCell.widthAnchor.constraint(equalToConstant: 35).isActive                                                   = true
		       
		taskTitle.translatesAutoresizingMaskIntoConstraints                                                               = false
		taskTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive                                          = true
		taskTitle.leadingAnchor.constraint(equalTo: buttonCell.trailingAnchor, constant: 8).isActive                      = true
		taskTitle.trailingAnchor.constraint(equalTo: self.repeatImageView.leadingAnchor, constant: -3).isActive           = true
		
		textFieldLabel.translatesAutoresizingMaskIntoConstraints                                                          = false
		textFieldLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive                                     = true
		textFieldLabel.leadingAnchor.constraint(equalTo: buttonCell.trailingAnchor, constant: 8).isActive                 = true
		textFieldLabel.trailingAnchor.constraint(equalTo: self.repeatImageView.leadingAnchor, constant: -3).isActive      = true
	}
}

extension CustomCell: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		true
	}
}

extension CustomCell: UITextViewDelegate {
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.endEditing(true)
		
	}
}
