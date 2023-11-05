//
//  PasswordSettingsVC.swift
//  ToDo
//
//  Created by Антон on 17.11.2022.
//


protocol PasswordSettingsVCOutput: AnyObject { }

protocol PasswordSettingsVCInput: AnyObject { }

import UIKit

//MARK: - VIEW
final class PasswordSettingsVC: UIViewController {
    
    private enum Constants {
        static var passwordAndFaceID: String { NSLocalizedString("Passcode & FaceID", comment: "") }
        static var enterOldPassword: String { NSLocalizedString("...enter the old password", comment: "") }
        static var enterNewPassword: String { NSLocalizedString("...enter the password", comment: "") }
        static var confirmNewPassword: String { NSLocalizedString("...confirm the password", comment: "") }
        static var passwordIsSet: String { NSLocalizedString("the password is set!", comment: "") }
        static var createAndConfirmNewPass: String { NSLocalizedString("Create and confirm your new password", comment: "") }
        static var toConfirmEnterOldPass: String { NSLocalizedString("To confirm, enter your password", comment: "") }
        static var errorPassLong: String { NSLocalizedString("password must be 4 characters long", comment: "") }
        static var errorPassDontMatch: String { NSLocalizedString("the entered passwords do not match", comment: "") }
        static var errorWrongPass: String { NSLocalizedString("wrong password", comment: "") }
        static var passRemoved: String { NSLocalizedString("password removed", comment: "") }
        static var removePass: String { NSLocalizedString("remove password", comment: "") }
        static var next: String { NSLocalizedString("next", comment: "") }
        static var save: String { NSLocalizedString("save", comment: "") }
    }
    
    //MARK: - PROPERTY
    private let tableView = UITableView()
    private let gradient = CAGradientLayer()
    private let usePasswordLabel = UILabel()
    private let infoPasswordLabel = UILabel()
    private let passwordSwitch = UISwitch()
    private let oldPasswordTextField = UITextField()
    private let newPasswordTextField = UITextField()
    private let confirmPasswordTextField = UITextField()
    private let textFieldStackView = UIStackView()
    private let keyboardToolbarNew = UIToolbar()
    private let keyboardToolbarOld = UIToolbar()
    private let keyboardToolbarConfirm = UIToolbar()
    private var animations = Animations()
    
    var viewModel: PasswordSettingsVCViewModelProtocol?
    
    //MARK: - LIVECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        Theme.switchTheme(gradient: gradient, view: view, traitCollection: traitCollection)
        usePasswordLabelSetup()
        infoPasswordLabelSetup()
        usePasswordSwitchSetup()
        textFieldStackViewSetup()
        newPasswordTextFieldSetup()
        oldPasswordTextFieldSetup()
        confirmPasswordTextFieldSetup()
        setupTextFieldToolBar(title: NSLocalizedString(Constants.removePass, comment: ""), toolBar: keyboardToolbarOld, action: #selector(offEnterOldPasswordToolBar))
        setupTextFieldToolBar(title: NSLocalizedString(Constants.next, comment: ""), toolBar: keyboardToolbarNew, action: #selector(nextEnterNewPasswordToolBar))
        setupTextFieldToolBar(title: NSLocalizedString(Constants.save, comment: ""), toolBar: keyboardToolbarConfirm, action: #selector(saveConfirmNewPasswordToolBar))
        addSubview()
        layout()
    }

    var newPassword = ""
    
    //MARK: - SETUP
    private func infoPasswordLabelSetup() {
        infoPasswordLabel.text = ""
        infoPasswordLabel.textAlignment = .center
        infoPasswordLabel.numberOfLines = 2
        
    }
    
    private func usePasswordLabelSetup() {
        usePasswordLabel.text = Constants.passwordAndFaceID
    }
    
    private func usePasswordSwitchSetup() {
        passwordSwitch.isOn = UserDefaults.standard.bool(forKey: AppDelegate.passStatusKey)
        passwordSwitch.addTarget(self, action: #selector(turnPassword(sender:)), for: .valueChanged)
    }
    
    private func oldPasswordTextFieldSetup() {
        oldPasswordTextField.isHidden = true
        oldPasswordTextField.placeholder = Constants.enterOldPassword
        oldPasswordTextField.keyboardType = .numberPad
        oldPasswordTextField.isSecureTextEntry = true
        oldPasswordTextField.inputAccessoryView = keyboardToolbarOld
    }
    
    private func newPasswordTextFieldSetup() {
        newPasswordTextField.isHidden = true
        newPasswordTextField.placeholder = Constants.enterNewPassword
        newPasswordTextField.keyboardType = .numberPad
        newPasswordTextField.isSecureTextEntry = true
        newPasswordTextField.inputAccessoryView = keyboardToolbarNew
    }
    
    private func confirmPasswordTextFieldSetup() {
        confirmPasswordTextField.isHidden = true
        confirmPasswordTextField.placeholder = Constants.confirmNewPassword
        confirmPasswordTextField.keyboardType = .numberPad
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.inputAccessoryView = keyboardToolbarConfirm
    }
    
    private func textFieldStackViewSetup() {
        textFieldStackView.isHidden = false
        textFieldStackView.axis = .vertical
        textFieldStackView.spacing = 40
        textFieldStackView.alignment = .fill
        textFieldStackView.distribution = .fillEqually
        textFieldStackView.addArrangedSubview(oldPasswordTextField)
        textFieldStackView.addArrangedSubview(newPasswordTextField)
        textFieldStackView.addArrangedSubview(confirmPasswordTextField)
    }
    
    
    private func setupTextFieldToolBar(title: String, toolBar: UIToolbar, action: Selector?) {
        toolBar.barStyle = .default
        toolBar.items=[
            UIBarButtonItem(title: NSLocalizedString("cancel", comment: ""), style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissKeyb)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: title, style: UIBarButtonItem.Style.plain, target: self, action: action)
        ]
        toolBar.sizeToFit()
    }
    
    @objc func dismissKeyb() {
        oldPasswordTextField.text = ""
        newPasswordTextField.text = ""
        confirmPasswordTextField.text = ""
        view.endEditing(true)
    }
    
    
    @objc func nextEnterNewPasswordToolBar() {
        guard newPasswordTextField.text?.count == 4 else {
            errorHandling(label: infoPasswordLabel,
                          errorText: Constants.errorPassLong,
                          previousText: Constants.createAndConfirmNewPass); return }
        newPassword = newPasswordTextField.text!
        confirmPasswordTextField.becomeFirstResponder()
    }
    
    @objc func saveConfirmNewPasswordToolBar() {
        guard confirmPasswordTextField.text?.count == 4 else {
            errorHandling(label: infoPasswordLabel,
                          errorText: Constants.errorPassLong,
                          previousText: Constants.createAndConfirmNewPass)
            return
        }
        
        guard confirmPasswordTextField.text == newPassword else {
            errorHandling(label: infoPasswordLabel,
                          errorText: Constants.errorPassDontMatch,
                          previousText: Constants.createAndConfirmNewPass)
            return
        }
        
        do {
            try KeychainManager.shared.saveAccount(service: "ToDo", account: "User", password: newPassword)
            UserDefaults.standard.set(true, forKey: AppDelegate.passStatusKey)
            view.endEditing(true)
        } catch {
            print("error saveAccount")
        }
        do {
            _ = try KeychainManager.shared.getPassword(service: "ToDo", account: "User")
            infoPasswordLabel.text = Constants.passwordIsSet
            oldPasswordTextField.text = ""
            newPasswordTextField.text = ""
            confirmPasswordTextField.text = ""
            oldPasswordTextField.isHidden = true
            newPasswordTextField.isHidden = true
            confirmPasswordTextField.isHidden = true
        } catch {
            print("error getPassword")
        }
    }
    
    @objc func offEnterOldPasswordToolBar() {
        guard oldPasswordTextField.text?.count == 4 else {
            errorHandling(label: infoPasswordLabel,
                          errorText: Constants.errorPassLong,
                          previousText: Constants.toConfirmEnterOldPass); return }
        var pass = ""
        do {
            pass = try KeychainManager.shared.getPassword(service: "ToDo", account: "User") ?? ""
        } catch {
            print("error")
        }
        
        if oldPasswordTextField.text == pass {
            KeychainManager.shared.deleteAccount(service: "ToDo", account: "User")
            UserDefaults.standard.set(false, forKey: AppDelegate.passStatusKey)
            infoPasswordLabel.text = Constants.passRemoved
            oldPasswordTextField.text = ""
            oldPasswordTextField.isHidden = true
            view.endEditing(true)
            
        } else {
            errorHandling(label: infoPasswordLabel, errorText: Constants.errorWrongPass, previousText: Constants.toConfirmEnterOldPass)
            oldPasswordTextField.text = ""
        }
    }
    
    private func isHiddenUI(_ newPasswordTextField: Bool, _ oldPasswordTextField: Bool, _ confirmPasswordTextField: Bool, _ infoPasswordLabel: Bool) {
        self.newPasswordTextField.isHidden = newPasswordTextField
        self.oldPasswordTextField.isHidden = oldPasswordTextField
        self.confirmPasswordTextField.isHidden = confirmPasswordTextField
        self.infoPasswordLabel.isHidden = infoPasswordLabel
    }
    
    @objc func turnPassword(sender: UISwitch) {
        switch sender.isOn {
        case true:
            if UserDefaults.standard.bool(forKey: AppDelegate.passStatusKey) {
                isHiddenUI(true, true, true, true) //newPasswordTextField, oldPasswordTextField, confirmPasswordTextField, infoPasswordLabel
            } else {
                infoPasswordLabel.text = Constants.createAndConfirmNewPass
                isHiddenUI(false, true, false, false) //newPasswordTextField, oldPasswordTextField, confirmPasswordTextField, infoPasswordLabel
            }
        case false:
            if !UserDefaults.standard.bool(forKey: AppDelegate.passStatusKey) {
                isHiddenUI(true, true, true, true) //newPasswordTextField, oldPasswordTextField, confirmPasswordTextField, infoPasswordLabel
            } else {
                infoPasswordLabel.text = Constants.toConfirmEnterOldPass
                isHiddenUI(true, false, true, false) //newPasswordTextField, oldPasswordTextField, confirmPasswordTextField, infoPasswordLabel
            }
        }
    }
}

//MARK: - LAYOUT
extension PasswordSettingsVC {
    private func addSubview() {
        view.addSubview(tableView)
        view.addSubview(usePasswordLabel)
        view.addSubview(passwordSwitch)
        view.addSubview(infoPasswordLabel)
        view.addSubview(textFieldStackView)
    }
    
    private func layout() {
        usePasswordLabel.translatesAutoresizingMaskIntoConstraints = false
        usePasswordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        usePasswordLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        usePasswordLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        passwordSwitch.translatesAutoresizingMaskIntoConstraints = false
        passwordSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        passwordSwitch.centerYAnchor.constraint(equalTo: usePasswordLabel.centerYAnchor).isActive = true
        
        infoPasswordLabel.translatesAutoresizingMaskIntoConstraints = false
        infoPasswordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        infoPasswordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        infoPasswordLabel.topAnchor.constraint(equalTo: usePasswordLabel.bottomAnchor, constant: 40).isActive = true
        infoPasswordLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        textFieldStackView.translatesAutoresizingMaskIntoConstraints = false
        textFieldStackView.widthAnchor.constraint(equalToConstant: 335).isActive = true
        textFieldStackView.bottomAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: view.bottomAnchor, multiplier: -400).isActive = true
        textFieldStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textFieldStackView.topAnchor.constraint(equalTo: infoPasswordLabel.bottomAnchor, constant: 40).isActive = true
    }
}


private extension PasswordSettingsVC {
    private func errorHandling(label: UILabel, errorText: String, previousText: String) {
        label.text = errorText
        animations.shake(text: label, duration: 0.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            label.text = previousText
        }
    }
}
