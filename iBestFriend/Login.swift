//
//  Login.swift
//  iBestFriend
//
//  Created by Clayton Harper on 3/2/16.
//  Copyright © 2016 Clayton Harper. All rights reserved.
//

import UIKit
import Firebase

class Login: UIViewController {
	
	// MARK: - Outlets
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		FirebaseRefs.rootRef.observeAuthEventWithBlock { (authData) -> Void in
			if authData != nil {
				self.performSegueWithIdentifier("LoginToList", sender: nil)
			}
		}
	}
	
	// MARK: - Actions
	@IBAction func loginButtonTouched(sender: AnyObject) {
		Users.loginWithEmail(usernameTextField.text!, password: passwordTextField.text!)
	}
	@IBAction func facebookLoginTouched(sender: AnyObject) {
		Users.loginWithFacebook()
	}
	@IBAction func guestButtonTouched(sender: AnyObject) {
		Users.guestLogin()
	}
	@IBAction func forgotPasswordButtonTouched(sender: AnyObject) {
		Users.resetPasswordByEmail(usernameTextField.text!)
	}

}

