//
//  SignUpVC.swift
//  iBestFriend
//
//  Created by Clayton Harper on 3/19/16.
//  Copyright © 2016 Clayton Harper. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController, UITextFieldDelegate {
	
	// MARK: - Outlets
	@IBOutlet weak var newEmailTextField: UITextField!
	@IBOutlet weak var newPasswordTextField: UITextField!
	@IBOutlet weak var secondPasswordTextField: UITextField!
	@IBOutlet weak var securityAnswerTextField: UITextField!
	@IBOutlet weak var securityQuestionPickerView: UIPickerView!
	
	@IBOutlet weak var newEmailLabel: UILabel!
	@IBOutlet weak var newPasswordLabel: UILabel!
	@IBOutlet weak var secondPasswordLabel: UILabel!
	@IBOutlet weak var securityAnswerLabel: UILabel!
	
	@IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!

	let securityQuestions: [String] = ["What was your first pet's name?", "What is your favorite animal?", "How many pet's do you own?", "What was your first pet?", "Who is your vet?"]
	var usersSecurityQuestion: String = ""
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		securityQuestionPickerView.dataSource = self
		securityQuestionPickerView.delegate = self
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignUpVC.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignUpVC.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
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
	
	func userCompletedForm() -> Bool {
		if newPasswordTextField.text!.characters.count < 8 && newPasswordTextField.text != secondPasswordTextField.text {
			newPasswordLabel.textColor = UIColor.redColor()
			secondPasswordLabel.textColor = UIColor.redColor()
			return false
		}
		if securityAnswerTextField.text!.isEmpty {
			securityAnswerLabel.textColor = UIColor.redColor()
			return false
		}
		return true
	}
	
	// MARK: - Actions
	@IBAction func newUserSignInTapped(sender: AnyObject) {
		if userCompletedForm() {
			
			FirebaseRefs.rootRef.createUser(newEmailTextField.text!, password: newPasswordTextField.text!) { error, result in
				if error != nil {
					self.newEmailLabel.textColor = UIColor.redColor()
					print("There was an error creating an account. Error: \(error)")
				} else {
					let uid = result["uid"] as? String
					print("Successfully created user account with uid: \(uid)")
				}
			}
			performSegueWithIdentifier("SignUpComplete", sender: nil)
		}
	}

}

extension SignUpVC: UIPickerViewDataSource {
	
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return securityQuestions.count
	}
}

extension SignUpVC : UIPickerViewDelegate {
	
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return securityQuestions[row]
	}
	
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		usersSecurityQuestion = securityQuestions[row]
	}
	
}
