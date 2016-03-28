//
//  Pet.swift
//  iBestFriend
//
//  Created by Clayton Harper on 3/27/16.
//  Copyright © 2016 Clayton Harper. All rights reserved.
//

struct Breed {
	let greyhound = "Greyhound"
}

import Foundation

public class Pet {
	
	var name: String
	var breed: Breed
	var birthday: NSDate
	var weight: Double
	
	init(name: String, breed: Breed, birthday: NSDate, weight: Double) {
		self.name = name
		self.breed = breed
		self.birthday = birthday
		self.weight = weight
	}
}