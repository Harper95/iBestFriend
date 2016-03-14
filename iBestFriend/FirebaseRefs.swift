//
//  FirebaseRefs.swift
//  iBestFriend
//
//  Created by Clayton Harper on 3/13/16.
//  Copyright © 2016 Clayton Harper. All rights reserved.
//

import Firebase

public class FirebaseRefs {
	
	static let rootRef = Firebase(url: "https://ibestfriend.firebaseio.com/")
	static let breedRef = Firebase(url: "https://ibestfriend.firebaseio.com/breeds/")
	static let placeRef = Firebase(url: "https://ibestfriend.firebaseio.com/places")
	
}