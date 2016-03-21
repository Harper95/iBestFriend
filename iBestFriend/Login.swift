//
//  Login.swift
//  iBestFriend
//
//  Created by Clayton Harper on 3/2/16.
//  Copyright © 2016 Clayton Harper. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class Login: UIViewController {
	
	// MARK: - Outlets
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var invalidEmailPasswordStackView: UIStackView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		invalidEmailPasswordStackView.hidden = true
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		FirebaseRefs.rootRef.observeAuthEventWithBlock { (authData) -> Void in
			if authData.provider == "anonymous" { return }
			
			if authData != nil{
				self.performSegueWithIdentifier("LoginToList", sender: nil)
				print("Auto Logged in \(authData.uid)")
			}
		}
	}
	
	// MARK: - Actions
	@IBAction func loginButtonTouched(sender: AnyObject) {
		
		FirebaseRefs.rootRef.authUser(usernameTextField.text!, password: passwordTextField.text!) { error, authData in
			if error != nil {
				self.invalidEmailPasswordStackView.hidden = false
				self.passwordTextField.text! = ""
				print("There was an error logging in user. Error: \(error)")
			} else {
				print("User successfully logged in")
			}
		}
	}
	@IBAction func facebookLoginTouched(sender: AnyObject) {
		Users.loginWithFacebook()
	}
	@IBAction func guestButtonTouched(sender: AnyObject) {
		
		FirebaseRefs.rootRef.authAnonymouslyWithCompletionBlock { error, authData in
			if error != nil {
				print("Error loging in as guest \(error)")
			} else {
				self.performSegueWithIdentifier("LoginToList", sender: nil)
				print("Guest login success. \(authData)")
			}
		}
	}
	@IBAction func forgotPasswordButtonTouched(sender: AnyObject) {
		Users.resetPasswordByEmail(usernameTextField.text!)
	}

}

