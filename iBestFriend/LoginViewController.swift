//
//  ViewController.swift
//  iBestFriend
//
//  Created by Clayton Harper on 3/2/16.
//  Copyright © 2016 Clayton Harper. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
	
	// MARK: - Outlets
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	// MARK: - Actions


	@IBAction func loginButtonTouched(sender: AnyObject) {
		Users.loginWithEmail(usernameTextField.text!, password: passwordTextField.text!)
	}
	@IBAction func facebookLoginTouched(sender: AnyObject) {
		
	}
	@IBAction func guestButtonTouched(sender: AnyObject) {
		Users.guestLogin()
	}
	@IBAction func forgotPasswordButtonTouched(sender: AnyObject) {
		
	}
	@IBAction func signUpButtonTouched(sender: AnyObject) {
		
	}
}

