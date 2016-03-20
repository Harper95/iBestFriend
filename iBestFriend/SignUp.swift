//
//  SignUp.swift
//  iBestFriend
//
//  Created by Clayton Harper on 3/19/16.
//  Copyright © 2016 Clayton Harper. All rights reserved.
//

import UIKit

class SignUp: UIViewController, UITextFieldDelegate {
	
	// MARK: - Outlets
	@IBOutlet weak var newEmailTextField: UITextField!
	@IBOutlet weak var newPasswordTextField: UITextField!
	@IBOutlet weak var secondPasswordTextField: UITextField!
	@IBOutlet weak var securityAnswerTextField: UITextField!
	@IBOutlet weak var securityQuestionPickerView: UIPickerView!
	@IBOutlet weak var newUserSignIn: UIButton!

	let securityQuestions: [String] = ["What was your first pet's name?", "What is your favorite animal?", "How many pet's do you own?", "What was your first pet?", "Who is your vet?"]
	var usersSecurityQuestion: String = ""
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		securityQuestionPickerView.dataSource = self
		securityQuestionPickerView.delegate = self
	}
	
	// MARK: - Actions
	@IBAction func newUserSignInTapped(sender: AnyObject) {
		guard newEmailTextField.text!.isValidEmail()
			&& newPasswordTextField.text!.characters.count > 7
			&& secondPasswordTextField.text == newPasswordTextField.text
			&& !securityAnswerTextField.text!.isEmpty
			else { return }
		
		Users.createUserWithEmail(newEmailTextField.text!, password: newPasswordTextField.text!)
		
		performSegueWithIdentifier("SignUpToLogin", sender: self)
	}

}

extension SignUp: UIPickerViewDataSource {
	
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return securityQuestions.count
	}
}

extension SignUp : UIPickerViewDelegate {
	
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return securityQuestions[row]
	}
	
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		usersSecurityQuestion = securityQuestions[row]
	}
	
}
