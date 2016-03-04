//
//  ViewController.swift
//  iBestFriend
//
//  Created by Clayton Harper on 3/2/16.
//  Copyright © 2016 Clayton Harper. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

	@IBOutlet weak var logoImageView: UIImageView!
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func loginButtonTouched(sender: AnyObject) {
	}

	@IBAction func signUpButtonTouched(sender: AnyObject) {
	}
}

