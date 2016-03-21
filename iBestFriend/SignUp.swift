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
	
	@IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!

	let securityQuestions: [String] = ["What was your first pet's name?", "What is your favorite animal?", "How many pet's do you own?", "What was your first pet?", "Who is your vet?"]
	var usersSecurityQuestion: String = ""
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		securityQuestionPickerView.dataSource = self
		securityQuestionPickerView.delegate = self
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
	}
	
	override func viewDidDisappear(animated: Bool) {
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
	}
	
	func keyboardWillShow(notification: NSNotification) {
		let userInfo: [NSObject: AnyObject] = notification.userInfo!
		let keyboardFrame: CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
		
		UIView.animateWithDuration(0.1, animations: { () -> Void in
			self.scrollViewBottomConstraint.constant = keyboardFrame.size.height + 20
		})
	}

	func keyboardWillHide(sender: NSNotification) {
		let userInfo: [NSObject: AnyObject] = sender.userInfo!
		let keyboardSize: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
		
		self.view.frame.origin.y += keyboardSize.height
	}
	
	// MARK: - Actions
	@IBAction func newUserSignInTapped(sender: AnyObject) {
		guard newEmailTextField.text!.isValidEmail()
			&& newPasswordTextField.text!.characters.count > 7
			&& secondPasswordTextField.text == newPasswordTextField.text
			&& !securityAnswerTextField.text!.isEmpty
			else { return }
		
		Users.createUserWithEmail(newEmailTextField.text!, password: newPasswordTextField.text!)
		
		performSegueWithIdentifier("SignUpComplete", sender: self)
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
