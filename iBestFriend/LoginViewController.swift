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
	@IBOutlet weak var loginButton: UIButton!
	@IBOutlet weak var signUpButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	// MARK: - Actions
	@IBAction func loginButtonTouched(sender: AnyObject) {
		Users.loginWithEmail(usernameTextField.text!, password: passwordTextField.text!)
	}
	@IBAction func signUpButtonTouched(sender: AnyObject) {
		// Create an alert controller
	}
}

