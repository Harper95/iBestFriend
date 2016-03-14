//
//  Users.swift
//  iBestFriend
//
//  Created by Clayton Harper on 3/13/16.
//  Copyright © 2016 Clayton Harper. All rights reserved.
//

import Foundation
import FBSDKLoginKit

public class Users {
	
	// MARK: - Email and Password Authentication
	static func createUserWithEmail(email: String, password: String) {
		FirebaseRefs.rootRef.createUser(email, password: password) { error, result in
			
			if error != nil {
				print("There was an error creating an account. Error: \(error)")
			} else {
				let uid = result["uid"] as? String
				print("Successfully created user account with uid: \(uid)")
			}
		}
	}
	
	static func loginWithEmail(email: String, password: String) {
		FirebaseRefs.rootRef.authUser(email, password: password) { error, authData in
			
			if error != nil {
				print("There was an error logging in user. Error: \(error)")
			} else {
				print("User successfully logged in")
			}
		}
	}
	
	static func changeEmailFrom(oldEmail: String, password: String, newEmail: String) {
		FirebaseRefs.rootRef.changeEmailForUser(oldEmail, password: password, toNewEmail: newEmail) { error in
			
			if error != nil {
				print("Error changing email. Error: \(error)")
			} else {
				print("Email changed successfully")
			}
		}
	}
	
	static func changePasswordForUser(email: String, oldPassword: String, newPassword: String) {
		FirebaseRefs.rootRef.changePasswordForUser(email, fromOld: oldPassword, toNew: newPassword) { error in
			
			if error != nil {
				print("Error changing password. Error: \(error)")
			} else {
				print("Password changed successfully")
			}
		}
	}
	
	static func resetPasswordByEmail(email: String) {
		FirebaseRefs.rootRef.resetPasswordForUser(email) { error in
			
			if error != nil {
				print("Email not sent. Error: \(error)")
			} else {
				print("Email Sent")
			}
		}
	}
	
	// MARK: - Facebook Authentication
	static func loginWithFacebook() {
		let facebookLogin = FBSDKLoginManager()
		
		facebookLogin.logInWithReadPermissions(["email"], fromViewController: nil) { facebookResult, facebookError in
			
			if facebookError != nil {
				print("Facebook login failed. Error: \(facebookError)")
			} else if facebookResult.isCancelled {
				print("Facebook login was cancelled")
			} else {
				let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
				
				FirebaseRefs.rootRef.authWithOAuthProvider("facebook", token: accessToken) { error, authData in
					
					if error != nil {
						print("Facebook login failed. \(error)")
					} else {
						print("Facebook login success. \(authData)")
					}
				}
			}
		}
	}
	
	//MARK: - Guest Authentication
	static func guestLogin() {
		FirebaseRefs.rootRef.authAnonymouslyWithCompletionBlock { error, authData in
			
			if error != nil {
				print("Error loging in as guest \(error)")
			} else {
				print("Guest login success. \(error)")
			}
		}
	}
}