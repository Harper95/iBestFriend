//
//  Place.swift
//  iBestFriend
//
//  Created by Clayton Harper on 3/4/16.
//  Copyright © 2016 Clayton Harper. All rights reserved.
//

import UIKit

public class Place {
	
	// MARK - Properties
	var rating: Int = 0
	var animal: String
	var type: String
	var name: String
	var long, lat: Double
	var hazards: String?
	var photo: UIImage?
	
	//MARK - Initialization
	init(animal: String, type: String, name: String, long: Double, lat: Double) {
		self.animal = animal
		self.type = type
		self.name = name
		self.long = long
		self.lat = lat
	}
	
}
